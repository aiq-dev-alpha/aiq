use actix_web::{
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    web, Error, HttpMessage, HttpResponse,
};
use futures_util::future::{ok, LocalBoxFuture, Ready};
use std::{
    future::{ready, Ready as StdReady},
    rc::Rc,
};
use uuid::Uuid;

use crate::{config::Config, services::AuthService};

pub struct AuthMiddleware;

impl<S, B> Transform<S, ServiceRequest> for AuthMiddleware
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error> + 'static,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Transform = AuthMiddlewareService<S>;
    type InitError = ();
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(AuthMiddlewareService {
            service: Rc::new(service),
        }))
    }
}

pub struct AuthMiddlewareService<S> {
    service: Rc<S>,
}

impl<S, B> Service<ServiceRequest> for AuthMiddlewareService<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error> + 'static,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        let srv = self.service.clone();

        Box::pin(async move {
            let auth_header = req.headers().get("Authorization");

            let token = match auth_header {
                Some(header) => match header.to_str() {
                    Ok(header_str) => {
                        if header_str.starts_with("Bearer ") {
                            header_str.trim_start_matches("Bearer ")
                        } else {
                            return Ok(req.into_response(
                                HttpResponse::Unauthorized().json(serde_json::json!({
                                    "error": "Invalid authorization format"
                                }))
                            ));
                        }
                    }
                    Err(_) => {
                        return Ok(req.into_response(
                            HttpResponse::Unauthorized().json(serde_json::json!({
                                "error": "Invalid authorization header"
                            }))
                        ));
                    }
                },
                None => {
                    return Ok(req.into_response(
                        HttpResponse::Unauthorized().json(serde_json::json!({
                            "error": "Authorization header required"
                        }))
                    ));
                }
            };

            let config = req.app_data::<web::Data<Config>>().unwrap();
            let auth_service = AuthService::new(config.jwt_secret.clone());

            match auth_service.validate_token(token) {
                Ok(claims) => {
                    match Uuid::parse_str(&claims.sub) {
                        Ok(user_id) => {
                            req.extensions_mut().insert(user_id);
                            srv.call(req).await
                        }
                        Err(_) => {
                            Ok(req.into_response(
                                HttpResponse::Unauthorized().json(serde_json::json!({
                                    "error": "Invalid user ID in token"
                                }))
                            ))
                        }
                    }
                }
                Err(_) => {
                    Ok(req.into_response(
                        HttpResponse::Unauthorized().json(serde_json::json!({
                            "error": "Invalid token"
                        }))
                    ))
                }
            }
        })
    }
}