use actix_web::{web, HttpRequest, HttpResponse, Result, Scope};
use sqlx::PgPool;
use uuid::Uuid;
use validator::Validate;

use crate::{
    config::Config,
    database::Database,
    models::{CreateUserRequest, LoginRequest, LoginResponse, User, UserResponse},
    services::AuthService,
};

pub fn config() -> Scope {
    web::scope("/auth")
        .route("/register", web::post().to(register))
        .route("/login", web::post().to(login))
        .route("/me", web::get().to(get_current_user))
}

pub async fn register(
    body: web::Json<CreateUserRequest>,
    db: web::Data<Database>,
    config: web::Data<Config>,
) -> Result<HttpResponse> {
    if let Err(errors) = body.validate() {
        return Ok(HttpResponse::BadRequest().json(serde_json::json!({
            "error": "Validation failed",
            "details": errors
        })));
    }

    let auth_service = AuthService::new(config.jwt_secret.clone());
    let pool = db.get_pool();

    // Check if user already exists
    let existing_user = sqlx::query_as!(
        User,
        "SELECT * FROM users WHERE email = $1",
        body.email
    )
    .fetch_optional(pool)
    .await;

    match existing_user {
        Ok(Some(_)) => {
            return Ok(HttpResponse::Conflict().json(serde_json::json!({
                "error": "Email already exists"
            })));
        }
        Err(e) => {
            log::error!("Database error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })));
        }
        _ => {}
    }

    // Hash password
    let password_hash = match auth_service.hash_password(&body.password) {
        Ok(hash) => hash,
        Err(e) => {
            log::error!("Password hashing error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to process password"
            })));
        }
    };

    // Create user
    let user = sqlx::query_as!(
        User,
        r#"
        INSERT INTO users (email, password_hash, first_name, last_name)
        VALUES ($1, $2, $3, $4)
        RETURNING *
        "#,
        body.email,
        password_hash,
        body.first_name,
        body.last_name
    )
    .fetch_one(pool)
    .await;

    match user {
        Ok(user) => Ok(HttpResponse::Created().json(UserResponse::from(user))),
        Err(e) => {
            log::error!("Failed to create user: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to create user"
            })))
        }
    }
}

pub async fn login(
    body: web::Json<LoginRequest>,
    db: web::Data<Database>,
    config: web::Data<Config>,
) -> Result<HttpResponse> {
    if let Err(errors) = body.validate() {
        return Ok(HttpResponse::BadRequest().json(serde_json::json!({
            "error": "Validation failed",
            "details": errors
        })));
    }

    let auth_service = AuthService::new(config.jwt_secret.clone());
    let pool = db.get_pool();

    // Find user by email
    let user = sqlx::query_as!(
        User,
        "SELECT * FROM users WHERE email = $1",
        body.email
    )
    .fetch_optional(pool)
    .await;

    let user = match user {
        Ok(Some(user)) => user,
        Ok(None) => {
            return Ok(HttpResponse::Unauthorized().json(serde_json::json!({
                "error": "Invalid credentials"
            })));
        }
        Err(e) => {
            log::error!("Database error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })));
        }
    };

    // Verify password
    match auth_service.verify_password(&body.password, &user.password_hash) {
        Ok(true) => {}
        Ok(false) => {
            return Ok(HttpResponse::Unauthorized().json(serde_json::json!({
                "error": "Invalid credentials"
            })));
        }
        Err(e) => {
            log::error!("Password verification error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Authentication failed"
            })));
        }
    }

    // Generate JWT token
    let token = match auth_service.generate_token(user.id) {
        Ok(token) => token,
        Err(e) => {
            log::error!("Token generation error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to generate token"
            })));
        }
    };

    Ok(HttpResponse::Ok().json(LoginResponse {
        token,
        user: UserResponse::from(user),
    }))
}

pub async fn get_current_user(
    req: HttpRequest,
    db: web::Data<Database>,
) -> Result<HttpResponse> {
    let user_id = match req.extensions().get::<Uuid>() {
        Some(id) => *id,
        None => {
            return Ok(HttpResponse::Unauthorized().json(serde_json::json!({
                "error": "Unauthorized"
            })));
        }
    };

    let pool = db.get_pool();

    let user = sqlx::query_as!(
        User,
        "SELECT * FROM users WHERE id = $1",
        user_id
    )
    .fetch_optional(pool)
    .await;

    match user {
        Ok(Some(user)) => Ok(HttpResponse::Ok().json(UserResponse::from(user))),
        Ok(None) => Ok(HttpResponse::NotFound().json(serde_json::json!({
            "error": "User not found"
        }))),
        Err(e) => {
            log::error!("Database error: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })))
        }
    }
}