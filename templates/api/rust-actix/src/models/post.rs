use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;
use validator::Validate;

use super::user::UserResponse;

#[derive(Debug, Clone, FromRow, Serialize)]
pub struct Post {
    pub id: Uuid,
    pub title: String,
    pub content: String,
    pub user_id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize, Validate)]
pub struct CreatePostRequest {
    #[validate(length(min = 1, max = 255, message = "Title must be between 1 and 255 characters"))]
    pub title: String,
    #[validate(length(min = 1, message = "Content is required"))]
    pub content: String,
}

#[derive(Debug, Deserialize, Validate)]
pub struct UpdatePostRequest {
    #[validate(length(min = 1, max = 255, message = "Title must be between 1 and 255 characters"))]
    pub title: Option<String>,
    #[validate(length(min = 1, message = "Content cannot be empty"))]
    pub content: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct PostResponse {
    pub id: Uuid,
    pub title: String,
    pub content: String,
    pub user_id: Uuid,
    pub user: Option<UserResponse>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, FromRow)]
pub struct PostWithUser {
    pub id: Uuid,
    pub title: String,
    pub content: String,
    pub user_id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub user_email: String,
    pub user_first_name: String,
    pub user_last_name: String,
    pub user_created_at: DateTime<Utc>,
    pub user_updated_at: DateTime<Utc>,
}

impl From<Post> for PostResponse {
    fn from(post: Post) -> Self {
        Self {
            id: post.id,
            title: post.title,
            content: post.content,
            user_id: post.user_id,
            user: None,
            created_at: post.created_at,
            updated_at: post.updated_at,
        }
    }
}

impl From<PostWithUser> for PostResponse {
    fn from(post_with_user: PostWithUser) -> Self {
        Self {
            id: post_with_user.id,
            title: post_with_user.title,
            content: post_with_user.content,
            user_id: post_with_user.user_id,
            user: Some(UserResponse {
                id: post_with_user.user_id,
                email: post_with_user.user_email,
                first_name: post_with_user.user_first_name,
                last_name: post_with_user.user_last_name,
                created_at: post_with_user.user_created_at,
                updated_at: post_with_user.user_updated_at,
            }),
            created_at: post_with_user.created_at,
            updated_at: post_with_user.updated_at,
        }
    }
}