use actix_cors::Cors;
use actix_web::{web, App, HttpServer, Result};
use env_logger::Env;
use std::env;

mod config;
mod database;
mod handlers;
mod middleware;
mod models;
mod services;

use config::Config;
use database::Database;

#[actix_web::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv::dotenv().ok();
    env_logger::init_from_env(Env::default().default_filter_or("info"));

    let config = Config::from_env();
    let database = Database::new(&config.database_url).await?;

    log::info!("Starting server at {}:{}", config.server_host, config.server_port);

    HttpServer::new(move || {
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .max_age(3600);

        App::new()
            .app_data(web::Data::new(database.clone()))
            .app_data(web::Data::new(config.clone()))
            .wrap(cors)
            .wrap(actix_web::middleware::Logger::default())
            .service(
                web::scope("/api/v1")
                    .service(handlers::auth::config())
                    .service(handlers::posts::config())
            )
            .service(handlers::health::health_check)
    })
    .bind(format!("{}:{}", config.server_host, config.server_port))?
    .run()
    .await?;

    Ok(())
}