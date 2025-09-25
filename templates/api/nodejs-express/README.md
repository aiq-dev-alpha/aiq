# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

A production-ready Node.js Express API built with TypeScript, featuring authentication, authorization, validation, security middleware, comprehensive testing, and Docker support.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [API Documentation](#api-documentation)
- [Authentication](#authentication)
- [Security Features](#security-features)
- [Testing](#testing)
- [Docker Support](#docker-support)
- [Deployment](#deployment)
- [Contributing](#contributing)

## ✨ Features

- **TypeScript** - Full TypeScript support with strict configuration
- **Express.js** - Fast, unopinionated web framework
- **MongoDB** - NoSQL database with Mongoose ODM
- **JWT Authentication** - Secure token-based authentication
- **Role-based Authorization** - User roles and permissions
- **Request Validation** - Input validation with Joi
- **Security Middleware** - Helmet, CORS, rate limiting, and more
- **Error Handling** - Centralized error handling with proper HTTP status codes
- **Logging** - Structured logging with Winston
- **API Documentation** - Interactive Swagger/OpenAPI documentation
- **Testing** - Comprehensive test suite with Jest and Supertest
- **Docker Support** - Multi-stage Dockerfile and Docker Compose
- **Code Quality** - ESLint, Prettier, and pre-commit hooks
- **Health Checks** - Kubernetes-ready health endpoints

## 🛠 Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (JSON Web Tokens)
- **Validation**: Joi
- **Testing**: Jest + Supertest + MongoDB Memory Server
- **Documentation**: Swagger/OpenAPI
- **Logging**: Winston
- **Code Quality**: ESLint + Prettier
- **Containerization**: Docker + Docker Compose

## 📁 Project Structure

```
{{PROJECT_NAME}}/
├── src/
│   ├── config/
│   │   ├── database.ts      # MongoDB connection setup
│   │   ├── logger.ts        # Winston logger configuration
│   │   └── swagger.ts       # Swagger/OpenAPI setup
│   ├── controllers/
│   │   ├── authController.ts    # Authentication endpoints
│   │   ├── userController.ts    # User management endpoints
│   │   └── healthController.ts  # Health check endpoints
│   ├── middleware/
│   │   ├── auth.ts          # Authentication & authorization
│   │   ├── error.ts         # Error handling middleware
│   │   └── security.ts      # Security middleware (rate limiting, etc.)
│   ├── models/
│   │   └── User.ts          # User model with Mongoose
│   ├── routes/
│   │   ├── auth.ts          # Authentication routes
│   │   ├── users.ts         # User management routes
│   │   ├── health.ts        # Health check routes
│   │   └── index.ts         # Route aggregator
│   ├── services/            # Business logic services
│   ├── types/
│   │   ├── express.d.ts     # Express type extensions
│   │   └── index.ts         # Common type definitions
│   ├── utils/
│   │   ├── jwt.ts           # JWT utility functions
│   │   └── validation.ts    # Validation schemas and middleware
│   ├── tests/
│   │   ├── setup.ts         # Test setup and configuration
│   │   ├── auth.test.ts     # Authentication tests
│   │   └── health.test.ts   # Health endpoint tests
│   ├── app.ts               # Express app configuration
│   └── server.ts            # Server startup and configuration
├── docker/
│   ├── mongodb/init/        # MongoDB initialization scripts
│   └── nginx/               # Nginx configuration
├── logs/                    # Application logs (created at runtime)
├── uploads/                 # File uploads (created at runtime)
├── .env.example             # Environment variables template
├── .gitignore               # Git ignore rules
├── Dockerfile               # Production Docker image
├── Dockerfile.dev           # Development Docker image
├── docker-compose.yml       # Production Docker Compose
├── docker-compose.dev.yml   # Development Docker Compose
├── jest.config.js           # Jest testing configuration
├── package.json             # NPM dependencies and scripts
├── tsconfig.json            # TypeScript configuration
└── README.md                # Project documentation
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ and npm
- MongoDB 6.0+ (or use Docker)
- Git

### Installation

1. **Clone or create from template**:
   ```bash
   # Using the setup script (recommended)
   ./setup-template.sh my-awesome-api /path/to/projects

   # Or manually
   git clone <repository-url> {{PROJECT_NAME}}
   cd {{PROJECT_NAME}}
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up environment variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start MongoDB** (if not using Docker):
   ```bash
   # Using MongoDB locally
   mongod

   # Or using Docker
   docker run -d -p 27017:27017 --name mongodb mongo:6.0
   ```

5. **Start the development server**:
   ```bash
   npm run dev
   ```

The API will be available at `http://localhost:3000`

### Quick Start with Docker

```bash
# Development environment
docker-compose -f docker-compose.dev.yml up

# Production environment
docker-compose up
```

## ⚙️ Environment Configuration

Copy `.env.example` to `.env` and configure the following variables:

```env
# Server Configuration
NODE_ENV=development
PORT=3000
HOST=localhost

# Database Configuration
MONGODB_URI=mongodb://localhost:27017/{{PROJECT_NAME}}

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d
JWT_COOKIE_EXPIRE=7

# Security
BCRYPT_SALT_ROUNDS=12

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# Logging
LOG_LEVEL=info
```

## 📖 API Documentation

Interactive API documentation is available at:
- **Development**: `http://localhost:3000/api-docs`
- **Swagger JSON**: `http://localhost:3000/api-docs.json`

### Available Endpoints

#### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/logout` - Logout user
- `GET /api/v1/auth/profile` - Get current user profile
- `PUT /api/v1/auth/profile` - Update user profile
- `PUT /api/v1/auth/change-password` - Change password

#### User Management (Admin only)
- `GET /api/v1/users` - Get all users (paginated)
- `GET /api/v1/users/:id` - Get user by ID
- `POST /api/v1/users` - Create new user
- `PUT /api/v1/users/:id` - Update user
- `DELETE /api/v1/users/:id` - Delete user
- `PATCH /api/v1/users/:id/activate` - Activate user
- `PATCH /api/v1/users/:id/deactivate` - Deactivate user

#### Health Checks
- `GET /health` - Health check
- `GET /health/ready` - Readiness check
- `GET /health/live` - Liveness check

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication:

1. **Register** or **login** to receive a JWT token
2. Include the token in requests using the `Authorization` header:
   ```
   Authorization: Bearer <your-jwt-token>
   ```
3. Tokens are also set as HTTP-only cookies for enhanced security

### User Roles

- `user` - Regular user (default)
- `moderator` - Moderator with extended permissions
- `admin` - Administrator with full access

## 🛡️ Security Features

- **Authentication**: JWT-based with secure HTTP-only cookies
- **Authorization**: Role-based access control
- **Rate Limiting**: Configurable rate limiting per endpoint
- **Input Validation**: Request validation with Joi schemas
- **SQL Injection Prevention**: MongoDB sanitization
- **XSS Protection**: Input sanitization and security headers
- **CORS**: Configurable cross-origin resource sharing
- **Security Headers**: Helmet.js for security headers
- **Request Size Limits**: Protection against large payloads
- **Error Handling**: Secure error responses (no sensitive data leakage)

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

### Test Structure

- **Unit Tests**: Individual component testing
- **Integration Tests**: API endpoint testing
- **Database Tests**: Using MongoDB Memory Server
- **Coverage Reports**: Generated in `coverage/` directory

### Test Environment

Tests use an in-memory MongoDB instance and isolated test environment:
- Automatic database cleanup between tests
- Mock external dependencies
- Fast test execution

## 🐳 Docker Support

### Development

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up

# With specific services
docker-compose -f docker-compose.dev.yml up api-dev mongodb-dev
```

### Production

```bash
# Build and start production environment
docker-compose up

# With nginx reverse proxy
docker-compose --profile proxy up
```

### Docker Images

- **Production**: Multi-stage build with optimized Node.js Alpine image
- **Development**: Development image with hot reloading
- **Security**: Non-root user, minimal attack surface

## 📊 Monitoring & Logging

### Logging

- **Winston**: Structured logging with multiple transports
- **Log Levels**: error, warn, info, http, debug
- **Log Rotation**: Automatic log file rotation
- **Request Logging**: HTTP request/response logging

### Health Checks

- **Kubernetes-ready**: `/health`, `/health/ready`, `/health/live`
- **Database Status**: MongoDB connection monitoring
- **Resource Monitoring**: Memory and uptime metrics

## 🚀 Deployment

### Environment Preparation

1. **Production Environment Variables**:
   ```bash
   NODE_ENV=production
   JWT_SECRET=<strong-production-secret>
   MONGODB_URI=<production-mongodb-url>
   ```

2. **Build Application**:
   ```bash
   npm run build
   ```

3. **Start Production Server**:
   ```bash
   npm start
   ```

### Docker Deployment

```bash
# Build production image
docker build -t {{PROJECT_NAME}}:latest .

# Run container
docker run -p 3000:3000 --env-file .env {{PROJECT_NAME}}:latest
```

### Cloud Deployment

The application is ready for deployment on:
- **AWS ECS/Fargate**
- **Google Cloud Run**
- **Azure Container Instances**
- **Kubernetes** (health checks included)
- **Heroku** (Procfile can be added)

## 🔧 Development

### Available Scripts

```bash
npm run dev          # Start development server with hot reload
npm run build        # Build TypeScript to JavaScript
npm start           # Start production server
npm test            # Run test suite
npm run test:watch  # Run tests in watch mode
npm run test:coverage # Run tests with coverage report
npm run lint        # Run ESLint
npm run lint:fix    # Fix ESLint issues
npm run format      # Format code with Prettier
```

### Code Quality

- **ESLint**: TypeScript-specific linting rules
- **Prettier**: Code formatting
- **Husky**: Git hooks for quality assurance
- **Strict TypeScript**: Strict mode enabled

### Adding New Features

1. **Models**: Add to `src/models/`
2. **Controllers**: Add to `src/controllers/`
3. **Routes**: Add to `src/routes/` and register in `src/routes/index.ts`
4. **Middleware**: Add to `src/middleware/`
5. **Tests**: Add corresponding test files
6. **Documentation**: Update Swagger documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow existing TypeScript patterns
- Write tests for new features
- Update documentation
- Ensure all tests pass
- Follow semantic commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **{{AUTHOR_NAME}}** - *Initial work* - [{{AUTHOR_EMAIL}}](mailto:{{AUTHOR_EMAIL}})

## 🙏 Acknowledgments

- Express.js team for the excellent framework
- MongoDB team for the robust database
- TypeScript team for type safety
- All open source contributors

---

**Happy coding!** 🚀

For support or questions, please open an issue or contact [{{AUTHOR_EMAIL}}](mailto:{{AUTHOR_EMAIL}}).