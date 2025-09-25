# Go Gin API Template

A production-ready REST API template built with Go and the Gin framework, featuring JWT authentication, PostgreSQL database, and comprehensive documentation.

## 🚀 Features

- **REST API** - Built with Gin web framework for high performance
- **Authentication** - JWT-based authentication with middleware
- **Database** - PostgreSQL integration with GORM ORM
- **Documentation** - Auto-generated Swagger/OpenAPI documentation
- **CORS** - Cross-Origin Resource Sharing support
- **Validation** - Request validation with Gin binding
- **Clean Architecture** - Organized code structure with separation of concerns
- **Environment Config** - Environment-based configuration management
- **Logging** - Structured logging with request/response details

## 📁 Project Structure

```
├── main.go                    # Application entry point
├── go.mod                     # Go module dependencies
├── .env.example              # Environment variables template
└── internal/
    ├── config/               # Configuration management
    ├── database/             # Database connection and migrations
    ├── handlers/             # HTTP request handlers
    │   ├── auth.go          # Authentication endpoints
    │   └── posts.go         # Post CRUD endpoints
    ├── middleware/           # HTTP middleware
    │   ├── auth.go          # JWT authentication middleware
    │   └── cors.go          # CORS middleware
    ├── models/              # Data models and DTOs
    │   ├── user.go          # User model with authentication
    │   └── post.go          # Post model with relationships
    ├── router/              # Route definitions and setup
    ├── services/            # Business logic services
    │   └── jwt.go           # JWT token generation/validation
```

## 📦 Dependencies & Library Choices

### 🎯 Core Framework
| Library | Version | Why We Chose It |
|---------|---------|-----------------|
| **gin-gonic/gin** | `v1.9.1` | High-performance HTTP web framework, excellent middleware support, active community |
| **gorm.io/gorm** | `v1.25.5` | Feature-rich ORM with associations, hooks, transactions, and excellent PostgreSQL support |
| **gorm.io/driver/postgres** | `v1.5.4` | Official PostgreSQL driver for GORM with optimized performance |

### 🔐 Authentication & Security
| Library | Purpose | Why This Choice |
|---------|---------|----------------|
| **golang-jwt/jwt/v5** | JWT tokens | Most popular Go JWT library, secure, well-maintained, supports all JWT features |
| **golang.org/x/crypto** | Password hashing | Official Go crypto package, bcrypt implementation for secure password hashing |

### 🛠️ Utility Libraries
| Library | Purpose | Benefits |
|---------|---------|---------|
| **joho/godotenv** | Environment variables | Simple .env file loading, development-friendly |
| **lib/pq** | PostgreSQL driver | Pure Go PostgreSQL driver, reliable and fast |

### 📖 Documentation
| Library | Purpose | Features |
|---------|---------|---------|
| **swaggo/swag** | Swagger generation | Auto-generates OpenAPI docs from Go comments |
| **swaggo/gin-swagger** | Swagger UI integration | Serves interactive API documentation |
| **swaggo/files** | Static file serving | Serves Swagger UI assets |

### 🔄 Why These Libraries?

**Gin over Echo/Fiber:**
- Largest Go web framework community
- Excellent performance benchmarks
- Comprehensive middleware ecosystem
- Simple, intuitive API design
- Battle-tested in production

**GORM over raw SQL/Squirrel:**
- Reduces boilerplate code significantly
- Automatic migrations and schema management
- Built-in associations and eager loading
- Hooks for business logic
- Strong type safety

**JWT over Sessions:**
- Stateless authentication
- Mobile app friendly
- Microservices compatible
- No server-side storage required
- Industry standard

**PostgreSQL over MySQL/MongoDB:**
- ACID compliance and data integrity
- Advanced features (JSON columns, full-text search)
- Excellent Go ecosystem support
- Strong performance for complex queries
- Open source with no licensing concerns

## 🛠️ Setup

### Prerequisites
- Go 1.19 or higher
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
   go run main.go
   ```

### Manual Setup

1. **Copy template and customize:**
   ```bash
   cp -r go-gin-template my_project
   cd my_project
   # Update go.mod module name
   ```

2. **Install dependencies:**
   ```bash
   go mod tidy
   ```

3. **Set up environment:**
   ```bash
   cp .env.example .env
   # Configure your database settings
   ```

4. **Run the server:**
   ```bash
   go run main.go
   ```

## 🏗️ API Architecture

### Clean Architecture Layers

**Handlers Layer** (`/handlers`)
- HTTP request/response handling
- Input validation and binding
- Response formatting
- Error handling

**Services Layer** (`/services`)
- Business logic implementation
- Data processing and validation
- External service integrations
- JWT token management

**Models Layer** (`/models`)
- Data structures and DTOs
- Database models with GORM tags
- Validation rules and binding tags
- Response transformation methods

**Database Layer** (`/database`)
- Database connection management
- Migration execution
- Connection pooling configuration

## 🔐 Authentication Flow

### Registration & Login
```go
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
All protected endpoints require `Authorization: Bearer <token>` header.

## 📝 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/me` - Get current user (protected)

### Posts
- `GET /api/v1/posts` - Get all posts
- `GET /api/v1/posts/:id` - Get specific post
- `POST /api/v1/posts` - Create post (protected)
- `PUT /api/v1/posts/:id` - Update post (protected, owner only)
- `DELETE /api/v1/posts/:id` - Delete post (protected, owner only)

### Health & Documentation
- `GET /health` - Health check endpoint
- `GET /swagger/*` - Swagger UI documentation

## 🗄️ Database Models

### User Model
```go
type User struct {
    ID        uint      `json:"id"`
    Email     string    `json:"email"`
    Password  string    `json:"-"`        // Hidden in responses
    FirstName string    `json:"first_name"`
    LastName  string    `json:"last_name"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}
```

### Post Model
```go
type Post struct {
    ID        uint      `json:"id"`
    Title     string    `json:"title"`
    Content   string    `json:"content"`
    UserID    uint      `json:"user_id"`
    User      User      `json:"user"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}
```

## 🔧 Configuration

Environment variables in `.env`:
```env
PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password
DB_NAME=myapp_db
DB_SSLMODE=disable
JWT_SECRET=your-super-secret-jwt-key
```

## 🧪 Testing

```bash
# Run tests
go test ./...

# Run tests with coverage
go test -cover ./...

# Run specific test
go test ./internal/handlers -v
```

## 🚢 Building & Deployment

```bash
# Build binary
go build -o bin/api main.go

# Build for Linux (if on different OS)
GOOS=linux GOARCH=amd64 go build -o bin/api-linux main.go

# Run binary
./bin/api
```

### Docker Deployment
```dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]
```

## 📋 Common Commands

```bash
# Download dependencies
go mod tidy

# Update dependencies
go get -u all

# Format code
go fmt ./...

# Vet code for issues
go vet ./...

# Run with live reload (install air first)
air

# Generate Swagger docs (if modified)
swag init
```

## 🎯 Best Practices

### Code Organization
- Keep handlers thin, business logic in services
- Use dependency injection for testability
- Separate models for requests/responses/database
- Use meaningful package names

### Security
- Always hash passwords with bcrypt
- Validate all input data
- Use HTTPS in production
- Rotate JWT secrets regularly
- Implement rate limiting for production

### Database
- Use transactions for multi-table operations
- Index frequently queried columns
- Use connection pooling
- Implement soft deletes where appropriate

### Error Handling
- Return consistent error responses
- Log errors with appropriate levels
- Don't expose internal errors to clients
- Use custom error types for business logic

## 🔍 Monitoring & Observability

Add these for production:
- Structured logging with logrus/zap
- Metrics with Prometheus
- Request tracing with OpenTelemetry
- Health check endpoints
- Graceful shutdown handling

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- [Gin Documentation](https://gin-gonic.com/docs/)
- [GORM Documentation](https://gorm.io/docs/)
- [Go Documentation](https://golang.org/doc/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🗺️ Roadmap

- [ ] Unit and integration tests
- [ ] Rate limiting middleware
- [ ] Request/response logging
- [ ] Database connection pooling
- [ ] Graceful shutdown
- [ ] Health checks with database connectivity
- [ ] Metrics and monitoring endpoints
- [ ] Docker compose for development
- [ ] CI/CD pipeline configuration

---

Built with ❤️ using Go and Gin