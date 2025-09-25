use actix_web::{web, HttpRequest, HttpResponse, Result, Scope};
use uuid::Uuid;
use validator::Validate;

use crate::{
    database::Database,
    middleware::AuthMiddleware,
    models::{CreatePostRequest, Post, PostResponse, PostWithUser, UpdatePostRequest},
};

pub fn config() -> Scope {
    web::scope("/posts")
        .route("", web::get().to(get_posts))
        .route("/{id}", web::get().to(get_post))
        .service(
            web::scope("")
                .wrap(AuthMiddleware)
                .route("", web::post().to(create_post))
                .route("/{id}", web::put().to(update_post))
                .route("/{id}", web::delete().to(delete_post))
        )
}

pub async fn get_posts(db: web::Data<Database>) -> Result<HttpResponse> {
    let pool = db.get_pool();

    let posts = sqlx::query_as!(
        PostWithUser,
        r#"
        SELECT
            p.id, p.title, p.content, p.user_id, p.created_at, p.updated_at,
            u.email as user_email, u.first_name as user_first_name,
            u.last_name as user_last_name, u.created_at as user_created_at,
            u.updated_at as user_updated_at
        FROM posts p
        JOIN users u ON p.user_id = u.id
        ORDER BY p.created_at DESC
        "#
    )
    .fetch_all(pool)
    .await;

    match posts {
        Ok(posts) => {
            let responses: Vec<PostResponse> = posts.into_iter().map(PostResponse::from).collect();
            Ok(HttpResponse::Ok().json(responses))
        }
        Err(e) => {
            log::error!("Database error: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to fetch posts"
            })))
        }
    }
}

pub async fn get_post(
    path: web::Path<Uuid>,
    db: web::Data<Database>,
) -> Result<HttpResponse> {
    let post_id = path.into_inner();
    let pool = db.get_pool();

    let post = sqlx::query_as!(
        PostWithUser,
        r#"
        SELECT
            p.id, p.title, p.content, p.user_id, p.created_at, p.updated_at,
            u.email as user_email, u.first_name as user_first_name,
            u.last_name as user_last_name, u.created_at as user_created_at,
            u.updated_at as user_updated_at
        FROM posts p
        JOIN users u ON p.user_id = u.id
        WHERE p.id = $1
        "#,
        post_id
    )
    .fetch_optional(pool)
    .await;

    match post {
        Ok(Some(post)) => Ok(HttpResponse::Ok().json(PostResponse::from(post))),
        Ok(None) => Ok(HttpResponse::NotFound().json(serde_json::json!({
            "error": "Post not found"
        }))),
        Err(e) => {
            log::error!("Database error: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })))
        }
    }
}

pub async fn create_post(
    req: HttpRequest,
    body: web::Json<CreatePostRequest>,
    db: web::Data<Database>,
) -> Result<HttpResponse> {
    if let Err(errors) = body.validate() {
        return Ok(HttpResponse::BadRequest().json(serde_json::json!({
            "error": "Validation failed",
            "details": errors
        })));
    }

    let user_id = match req.extensions().get::<Uuid>() {
        Some(id) => *id,
        None => {
            return Ok(HttpResponse::Unauthorized().json(serde_json::json!({
                "error": "Unauthorized"
            })));
        }
    };

    let pool = db.get_pool();

    let post = sqlx::query_as!(
        Post,
        r#"
        INSERT INTO posts (title, content, user_id)
        VALUES ($1, $2, $3)
        RETURNING *
        "#,
        body.title,
        body.content,
        user_id
    )
    .fetch_one(pool)
    .await;

    match post {
        Ok(post) => {
            // Fetch the post with user information
            let post_with_user = sqlx::query_as!(
                PostWithUser,
                r#"
                SELECT
                    p.id, p.title, p.content, p.user_id, p.created_at, p.updated_at,
                    u.email as user_email, u.first_name as user_first_name,
                    u.last_name as user_last_name, u.created_at as user_created_at,
                    u.updated_at as user_updated_at
                FROM posts p
                JOIN users u ON p.user_id = u.id
                WHERE p.id = $1
                "#,
                post.id
            )
            .fetch_one(pool)
            .await;

            match post_with_user {
                Ok(post_with_user) => Ok(HttpResponse::Created().json(PostResponse::from(post_with_user))),
                Err(e) => {
                    log::error!("Database error fetching created post: {:?}", e);
                    Ok(HttpResponse::Created().json(PostResponse::from(post)))
                }
            }
        }
        Err(e) => {
            log::error!("Failed to create post: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to create post"
            })))
        }
    }
}

pub async fn update_post(
    req: HttpRequest,
    path: web::Path<Uuid>,
    body: web::Json<UpdatePostRequest>,
    db: web::Data<Database>,
) -> Result<HttpResponse> {
    if let Err(errors) = body.validate() {
        return Ok(HttpResponse::BadRequest().json(serde_json::json!({
            "error": "Validation failed",
            "details": errors
        })));
    }

    let user_id = match req.extensions().get::<Uuid>() {
        Some(id) => *id,
        None => {
            return Ok(HttpResponse::Unauthorized().json(serde_json::json!({
                "error": "Unauthorized"
            })));
        }
    };

    let post_id = path.into_inner();
    let pool = db.get_pool();

    // Check if post exists and user owns it
    let existing_post = sqlx::query_as!(
        Post,
        "SELECT * FROM posts WHERE id = $1",
        post_id
    )
    .fetch_optional(pool)
    .await;

    let existing_post = match existing_post {
        Ok(Some(post)) => post,
        Ok(None) => {
            return Ok(HttpResponse::NotFound().json(serde_json::json!({
                "error": "Post not found"
            })));
        }
        Err(e) => {
            log::error!("Database error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })));
        }
    };

    if existing_post.user_id != user_id {
        return Ok(HttpResponse::Forbidden().json(serde_json::json!({
            "error": "You can only update your own posts"
        })));
    }

    // Update post
    let updated_title = body.title.as_ref().unwrap_or(&existing_post.title);
    let updated_content = body.content.as_ref().unwrap_or(&existing_post.content);

    let updated_post = sqlx::query_as!(
        Post,
        r#"
        UPDATE posts
        SET title = $1, content = $2, updated_at = NOW()
        WHERE id = $3
        RETURNING *
        "#,
        updated_title,
        updated_content,
        post_id
    )
    .fetch_one(pool)
    .await;

    match updated_post {
        Ok(post) => {
            // Fetch the post with user information
            let post_with_user = sqlx::query_as!(
                PostWithUser,
                r#"
                SELECT
                    p.id, p.title, p.content, p.user_id, p.created_at, p.updated_at,
                    u.email as user_email, u.first_name as user_first_name,
                    u.last_name as user_last_name, u.created_at as user_created_at,
                    u.updated_at as user_updated_at
                FROM posts p
                JOIN users u ON p.user_id = u.id
                WHERE p.id = $1
                "#,
                post.id
            )
            .fetch_one(pool)
            .await;

            match post_with_user {
                Ok(post_with_user) => Ok(HttpResponse::Ok().json(PostResponse::from(post_with_user))),
                Err(e) => {
                    log::error!("Database error fetching updated post: {:?}", e);
                    Ok(HttpResponse::Ok().json(PostResponse::from(post)))
                }
            }
        }
        Err(e) => {
            log::error!("Failed to update post: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to update post"
            })))
        }
    }
}

pub async fn delete_post(
    req: HttpRequest,
    path: web::Path<Uuid>,
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

    let post_id = path.into_inner();
    let pool = db.get_pool();

    // Check if post exists and user owns it
    let existing_post = sqlx::query_as!(
        Post,
        "SELECT * FROM posts WHERE id = $1",
        post_id
    )
    .fetch_optional(pool)
    .await;

    let existing_post = match existing_post {
        Ok(Some(post)) => post,
        Ok(None) => {
            return Ok(HttpResponse::NotFound().json(serde_json::json!({
                "error": "Post not found"
            })));
        }
        Err(e) => {
            log::error!("Database error: {:?}", e);
            return Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Database error"
            })));
        }
    };

    if existing_post.user_id != user_id {
        return Ok(HttpResponse::Forbidden().json(serde_json::json!({
            "error": "You can only delete your own posts"
        })));
    }

    // Delete post
    let result = sqlx::query!(
        "DELETE FROM posts WHERE id = $1",
        post_id
    )
    .execute(pool)
    .await;

    match result {
        Ok(_) => Ok(HttpResponse::NoContent().finish()),
        Err(e) => {
            log::error!("Failed to delete post: {:?}", e);
            Ok(HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to delete post"
            })))
        }
    }
}