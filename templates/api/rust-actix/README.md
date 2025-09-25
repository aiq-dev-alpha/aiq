# Rust Actix Web API Template

A high-performance, production-ready REST API template built with Rust and Actix Web, featuring async/await, PostgreSQL integration, JWT authentication, and comprehensive error handling.

## 🚀 Features

- **High Performance** - Built with Actix Web for maximum throughput and minimal latency
- **Async/Await** - Full async support with Tokio runtime
- **PostgreSQL Integration** - SQLx for compile-time checked queries
- **JWT Authentication** - Secure token-based authentication
- **Request Validation** - Comprehensive input validation with custom error messages
- **Database Migrations** - Version-controlled schema changes
- **CORS Support** - Cross-Origin Resource Sharing configuration
- **Structured Logging** - Production-ready logging with env_logger
- **Clean Architecture** - Organized code structure with clear separation of concerns
- **Memory Safety** - Rust's ownership system prevents common security vulnerabilities

## 📁 Project Structure

```
├── Cargo.toml                # Dependencies and project metadata
├── .env.example              # Environment variables template
├── src/
│   ├── main.rs              # Application entry point and server setup
│   ├── config/              # Configuration management
│   ├── database/            # Database connection and setup
│   ├── handlers/            # HTTP request handlers
│   │   ├── auth.rs         # Authentication endpoints
│   │   ├── posts.rs        # Post CRUD endpoints
│   │   └── health.rs       # Health check endpoint
│   ├── middleware/          # Custom middleware
│   │   └── auth.rs         # JWT authentication middleware
│   ├── models/             # Data models and DTOs
│   │   ├── user.rs         # User model and DTOs
│   │   └── post.rs         # Post model and DTOs
│   └── services/           # Business logic services
│       └── auth.rs         # Authentication service
└── migrations/             # Database migrations
    ├── 001_create_users.sql
    └── 002_create_posts.sql
```

## 📦 Dependencies & Library Choices

### 🎯 Core Framework
| Library | Version | Why We Chose It |
|---------|---------|-----------------|
| **actix-web** | `4.4` | Fastest Rust web framework, excellent actor model, mature ecosystem |
| **tokio** | `1.35` | De facto async runtime for Rust, excellent performance, comprehensive features |
| **sqlx** | `0.7` | Compile-time SQL validation, async support, excellent PostgreSQL integration |

### 🔐 Authentication & Security
| Library | Purpose | Why This Choice |
|---------|---------|----------------|
| **jsonwebtoken** | JWT tokens | Pure Rust implementation, secure, well-maintained |
| **bcrypt** | Password hashing | Industry standard, configurable cost, secure |
| **uuid** | Unique identifiers | RFC 4122 compliant, cryptographically secure |

### 🛠️ Serialization & Validation
| Library | Purpose | Benefits |
|---------|---------|---------|
| **serde** | JSON serialization | Zero-cost abstractions, compile-time validation |
| **validator** | Input validation | Derive macros, comprehensive validation rules |
| **chrono** | Date/time handling | Timezone-aware, extensive formatting options |

### 📊 Utilities & Observability
| Library | Purpose | Features |
|---------|---------|---------|
| **dotenv** | Environment variables | Development-friendly .env file support |
| **env_logger** | Structured logging | Configurable log levels, production-ready |
| **log** | Logging facade | Standard Rust logging interface |
| **actix-cors** | CORS handling | Flexible CORS configuration |
| **thiserror** | Error handling | Ergonomic custom error types |
| **anyhow** | Error context | Better error messages and context |

### 🔄 Why These Libraries?

**Actix Web over Warp/Axum:**
- Highest performance benchmarks
- Mature ecosystem with extensive middleware
- Actor model provides excellent concurrency
- Production battle-tested
- Active development and community

**SQLx over Diesel:**
- Compile-time query validation
- Full async/await support
- No ORM overhead for simple queries
- Better PostgreSQL feature support
- Lightweight and fast

**JWT over Sessions:**
- Stateless authentication
- Microservices friendly
- Mobile app compatible
- Scalable architecture
- Industry standard

**PostgreSQL over MySQL/SQLite:**
- Advanced features (JSON columns, arrays, full-text search)
- Excellent concurrent performance
- Strong ACID compliance
- Extensive Rust ecosystem support
- Open source with permissive license

## 🛠️ Setup

### Prerequisites
- Rust 1.70 or higher
- PostgreSQL 12 or higher
- Git

### Using the Template

1. **Run the setup script:**
   ```bash
   ./setup-template.sh my_api ~/projects/
   ```

2. **Navigate to your project:**
   ```bash
   cd ~/projects/my_api
   ```

3. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Start PostgreSQL and create database:**
   ```sql
   CREATE DATABASE my_api_db;
   ```

5. **Run the API:**
   ```bash
   cargo run
   ```

### Manual Setup

1. **Copy template and customize:**
   ```bash
   cp -r rust-actix-template my_project
   cd my_project
   # Update Cargo.toml name field
   ```

2. **Install dependencies:**
   ```bash
   cargo check
   ```

3. **Set up environment:**
   ```bash
   cp .env.example .env
   # Configure your database settings
   ```

4. **Run migrations and start server:**
   ```bash
   cargo run
   ```

## 🏗️ API Architecture

### Clean Architecture Pattern

**Handlers Layer** (`/handlers`)
- HTTP request/response processing
- Input validation and deserialization
- Response formatting and error handling
- Route configuration and middleware integration

**Services Layer** (`/services`)
- Business logic implementation
- Authentication and authorization
- Data validation and transformation
- External service integrations

**Models Layer** (`/models`)
- Data structures and DTOs
- Database entity definitions
- Serialization/deserialization rules
- Validation constraints

**Database Layer** (`/database`)
- Connection management and pooling
- Migration execution
- Query execution and error handling

## 🔐 Authentication Flow

### Registration & Login
```rust
// Register new user
POST /api/v1/auth/register
{
    "email": "user@example.com",
    "password": "password123",
    "first_name": "John",
    "last_name": "Doe"
}

// Login user
POST /api/v1/auth/login
{
    "email": "user@example.com",
    "password": "password123"
}
// Returns: {"token": "jwt_token", "user": {...}}
```

### Protected Routes
Protected endpoints require `Authorization: Bearer <token>` header and use custom middleware for token validation.

## 📝 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/me` - Get current user (protected)

### Posts
- `GET /api/v1/posts` - Get all posts with user information
- `GET /api/v1/posts/{id}` - Get specific post
- `POST /api/v1/posts` - Create post (protected)
- `PUT /api/v1/posts/{id}` - Update post (protected, owner only)
- `DELETE /api/v1/posts/{id}` - Delete post (protected, owner only)

### Health Check
- `GET /health` - Health check endpoint with timestamp

## 🗄️ Database Models

### User Model
```rust
pub struct User {
    pub id: Uuid,
    pub email: String,
    pub password_hash: String, // Hidden in responses
    pub first_name: String,
    pub last_name: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
```

### Post Model
```rust
pub struct Post {
    pub id: Uuid,
    pub title: String,
    pub content: String,
    pub user_id: Uuid,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
```

## 🔧 Configuration

Environment variables in `.env`:
```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/myapp_db
JWT_SECRET=your-super-secret-jwt-key
SERVER_HOST=127.0.0.1
SERVER_PORT=8080
RUST_LOG=info
```

## 🧪 Testing

```bash
# Run tests
cargo test

# Run tests with output
cargo test -- --nocapture

# Run specific test
cargo test test_auth

# Run with coverage (requires cargo-tarpaulin)
cargo tarpaulin --out Html
```

## 🚢 Building & Deployment

```bash
# Build for development
cargo build

# Build optimized for production
cargo build --release

# Run optimized binary
./target/release/my_project

# Build statically linked binary (Alpine Linux)
cargo build --target x86_64-unknown-linux-musl --release
```

### Docker Deployment
```dockerfile
FROM rust:1.75 as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
COPY migrations ./migrations
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/release/myapp .
COPY --from=builder /app/migrations ./migrations
CMD ["./myapp"]
```

## 📋 Common Commands

```bash
# Check code without building
cargo check

# Run with auto-reload (requires cargo-watch)
cargo watch -x run

# Format code
cargo fmt

# Lint code
cargo clippy

# Update dependencies
cargo update

# Add new migration
# Create migration file manually in migrations/

# Database operations (requires sqlx-cli)
cargo install sqlx-cli
sqlx migrate run
sqlx migrate revert
```

## 🎯 Best Practices

### Code Organization
- Use modules to organize related functionality
- Keep handlers thin, business logic in services
- Use Result types for error handling
- Leverage Rust's type system for safety

### Performance
- Use `#[derive(Clone)]` judiciously
- Prefer `&str` over `String` when possible
- Use connection pooling for database operations
- Enable release optimizations for production

### Security
- Always hash passwords with bcrypt
- Validate all input data with validator crate
- Use HTTPS in production
- Implement rate limiting for public endpoints
- Rotate JWT secrets regularly

### Error Handling
- Use thiserror for custom error types
- Provide meaningful error messages
- Log errors with appropriate levels
- Don't expose internal errors to clients

### Database
- Use transactions for multi-table operations
- Index frequently queried columns
- Use prepared statements (SQLx does this automatically)
- Implement soft deletes where appropriate

## 🔍 Performance & Benchmarks

Actix Web consistently ranks as the fastest Rust web framework:
- **Throughput**: 600k+ requests/second on modern hardware
- **Latency**: Sub-millisecond response times for simple operations
- **Memory Usage**: Minimal heap allocations due to Rust's ownership system
- **CPU Efficiency**: Near-optimal CPU utilization with async/await

## 🔧 Production Considerations

Add these for production:
- Request rate limiting middleware
- Metrics collection (Prometheus)
- Distributed tracing (OpenTelemetry)
- Health checks with database connectivity
- Graceful shutdown handling
- Connection pooling configuration
- SSL/TLS termination
- Request timeout handling

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- [Actix Web Documentation](https://actix.rs/)
- [SQLx Documentation](https://docs.rs/sqlx/)
- [Rust Documentation](https://doc.rust-lang.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🗺️ Roadmap

- [ ] Unit and integration tests
- [ ] OpenAPI/Swagger documentation generation
- [ ] Rate limiting middleware
- [ ] Caching layer (Redis integration)
- [ ] Background job processing
- [ ] Metrics and monitoring endpoints
- [ ] Distributed tracing setup
- [ ] Multi-database support
- [ ] WebSocket support for real-time features
- [ ] GraphQL endpoint option

---

Built with ❤️ using Rust and Actix Web