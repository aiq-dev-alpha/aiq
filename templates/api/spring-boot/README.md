# Spring Boot REST API Template

A production-ready Spring Boot REST API template with JWT authentication, PostgreSQL database, comprehensive security configuration, and modern best practices.

## 🚀 Features

- **Spring Boot 3.2** - Latest stable version with all modern features
- **Spring Security 6** - Comprehensive security with JWT authentication
- **Spring Data JPA** - Powerful ORM with Hibernate implementation
- **PostgreSQL Integration** - Enterprise-grade relational database
- **JWT Authentication** - Stateless token-based authentication
- **Bean Validation** - Comprehensive input validation with annotations
- **OpenAPI Documentation** - Auto-generated API documentation with Swagger UI
- **CORS Configuration** - Cross-Origin Resource Sharing support
- **Exception Handling** - Centralized error handling and responses
- **Production Ready** - Includes security, validation, and best practices

## 📁 Project Structure

```
├── pom.xml                          # Maven dependencies and build configuration
├── application.yml                  # Application configuration
└── src/main/java/com/example/project_name/
    ├── Application.java            # Spring Boot main application class
    ├── config/                     # Configuration classes
    │   └── SecurityConfig.java    # Security configuration
    ├── controller/                 # REST controllers
    │   ├── AuthController.java    # Authentication endpoints
    │   ├── PostController.java    # Post CRUD endpoints
    │   └── HealthController.java  # Health check endpoint
    ├── dto/                       # Data Transfer Objects
    │   ├── UserRegistrationRequest.java
    │   ├── UserLoginRequest.java
    │   ├── UserResponse.java
    │   ├── PostRequest.java
    │   ├── PostResponse.java
    │   └── JwtResponse.java
    ├── entity/                    # JPA entities
    │   ├── User.java             # User entity with UserDetails
    │   └── Post.java             # Post entity
    ├── repository/                # Spring Data JPA repositories
    │   ├── UserRepository.java   # User data access
    │   └── PostRepository.java   # Post data access
    ├── security/                  # Security components
    │   ├── JwtUtils.java         # JWT token utilities
    │   ├── JwtAuthenticationFilter.java
    │   └── JwtAuthenticationEntryPoint.java
    └── service/                   # Business logic services
        ├── UserService.java      # User management service
        └── PostService.java      # Post management service
```

## 📦 Dependencies & Library Choices

### 🎯 Core Framework
| Library | Version | Why We Chose It |
|---------|---------|-----------------|
| **Spring Boot** | `3.2.1` | Industry standard Java framework, excellent ecosystem, production-ready |
| **Spring Security** | `6.x` | Comprehensive security framework, OAuth2/JWT support, battle-tested |
| **Spring Data JPA** | `3.x` | Powerful ORM abstraction, reduces boilerplate, excellent query methods |

### 🔐 Authentication & Security
| Library | Purpose | Why This Choice |
|---------|---------|----------------|
| **JJWT** | JWT tokens | Pure Java implementation, secure defaults, comprehensive features |
| **BCrypt** | Password hashing | Industry standard, configurable strength, Spring Security integration |

### 🗄️ Database & Persistence
| Library | Purpose | Benefits |
|---------|---------|---------|
| **PostgreSQL** | Database | Enterprise features, excellent performance, Spring Boot auto-configuration |
| **Hibernate** | ORM | Mature ORM, advanced features, caching, lazy loading |

### 📖 Documentation & Validation
| Library | Purpose | Features |
|---------|---------|---------|
| **SpringDoc OpenAPI** | API docs | OpenAPI 3.0, Swagger UI integration, annotation-driven |
| **Bean Validation** | Input validation | Annotation-based validation, comprehensive rules |

### 🔄 Why These Libraries?

**Spring Boot over Quarkus/Micronaut:**
- Largest ecosystem and community
- Mature production deployments
- Excellent documentation and tooling
- Enterprise support and adoption
- Comprehensive auto-configuration

**Spring Security over Apache Shiro:**
- More comprehensive security features
- Better OAuth2 and JWT support
- Active development and security updates
- Excellent integration with Spring Boot
- Industry standard for Java applications

**JJWT over Auth0 JWT:**
- Pure Java implementation
- No external dependencies
- Secure by default
- Comprehensive algorithm support
- Better performance

**PostgreSQL over MySQL/H2:**
- Advanced features (JSON columns, arrays, window functions)
- Better concurrent performance
- Strong ACID compliance
- Excellent Spring Boot integration
- Enterprise-grade reliability

## 🛠️ Setup

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher
- PostgreSQL 12 or higher
- Git

### Using the Template

1. **Run the setup script:**
   ```bash
   ./setup-template.sh my-api ~/projects/
   ```

2. **Navigate to your project:**
   ```bash
   cd ~/projects/my-api
   ```

3. **Configure database in application.yml:**
   ```yaml
   spring:
     datasource:
       url: jdbc:postgresql://localhost:5432/my_api_db
       username: postgres
       password: your_password
   ```

4. **Create PostgreSQL database:**
   ```sql
   CREATE DATABASE my_api_db;
   ```

5. **Run the application:**
   ```bash
   mvn spring-boot:run
   ```

### Manual Setup

1. **Copy template and customize:**
   ```bash
   cp -r spring-boot-template my-project
   cd my-project
   # Update pom.xml artifactId and package names
   ```

2. **Configure application:**
   ```bash
   # Edit application.yml with your database settings
   # Update JWT secret in production
   ```

3. **Build and run:**
   ```bash
   mvn clean install
   mvn spring-boot:run
   ```

## 🏗️ API Architecture

### MVC Pattern with Service Layer

**Controllers** (`/controller`)
- Handle HTTP requests and responses
- Input validation and binding
- Authentication and authorization
- Response formatting

**Services** (`/service`)
- Business logic implementation
- Transaction management
- Data validation and processing
- External service integration

**Repositories** (`/repository`)
- Data access layer
- Query methods and custom queries
- Database operations abstraction

**Entities** (`/entity`)
- JPA entities with relationships
- Database schema mapping
- Lifecycle callbacks and validation

## 🔐 Security Architecture

### JWT Authentication Flow
```java
// Register new user
POST /api/v1/auth/register
{
    "email": "user@example.com",
    "password": "password123",
    "firstName": "John",
    "lastName": "Doe"
}

// Login user
POST /api/v1/auth/login
{
    "email": "user@example.com",
    "password": "password123"
}
// Returns: {"token": "jwt_token", "type": "Bearer", "user": {...}}
```

### Security Configuration
- JWT token validation on protected endpoints
- CORS configuration for cross-origin requests
- Password encryption with BCrypt
- Session management set to stateless
- Custom authentication entry point for unauthorized requests

## 📝 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/me` - Get current user (protected)

### Posts
- `GET /api/v1/posts` - Get all posts (paginated)
- `GET /api/v1/posts/{id}` - Get specific post
- `POST /api/v1/posts` - Create post (protected)
- `PUT /api/v1/posts/{id}` - Update post (protected, owner only)
- `DELETE /api/v1/posts/{id}` - Delete post (protected, owner only)

### Documentation & Health
- `GET /swagger-ui.html` - Swagger UI documentation
- `GET /api-docs` - OpenAPI specification
- `GET /health` - Health check endpoint

## 🗄️ Database Schema

### User Entity
```java
@Entity
@Table(name = "users")
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String email;

    private String password;
    private String firstName;
    private String lastName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

### Post Entity
```java
@Entity
@Table(name = "posts")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    private User author;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

## 🔧 Configuration

Application configuration in `application.yml`:
```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/myapp_db
    username: postgres
    password: password

  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false

jwt:
  secret: your-super-secret-jwt-key
  expiration: 86400000 # 24 hours

springdoc:
  swagger-ui:
    path: /swagger-ui.html
```

## 🧪 Testing

```bash
# Run all tests
mvn test

# Run with coverage
mvn test jacoco:report

# Run integration tests
mvn failsafe:integration-test

# Run specific test class
mvn test -Dtest=UserServiceTest
```

## 🚢 Production Deployment

### Building for Production
```bash
# Create executable JAR
mvn clean package

# Run the JAR
java -jar target/my-api-0.0.1-SNAPSHOT.jar

# With custom profile
java -jar target/my-api-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

### Docker Deployment
```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app
COPY target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Production Configuration
```yaml
# application-prod.yml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

jwt:
  secret: ${JWT_SECRET}
  expiration: ${JWT_EXPIRATION:86400000}

logging:
  level:
    com.example.myapi: INFO
    org.springframework.security: WARN
```

## 📋 Common Commands

```bash
# Development
mvn spring-boot:run
mvn spring-boot:run -Dspring-boot.run.profiles=dev

# Building
mvn clean compile
mvn clean package
mvn clean install

# Testing
mvn test
mvn integration-test

# Database
mvn flyway:migrate
mvn flyway:clean

# Dependency management
mvn dependency:tree
mvn versions:display-dependency-updates
```

## 🎯 Best Practices

### Code Organization
- Use DTOs for API contracts
- Keep controllers thin, services fat
- Use repository interfaces for data access
- Implement proper exception handling

### Security
- Always validate input with Bean Validation
- Use HTTPS in production
- Rotate JWT secrets regularly
- Implement rate limiting
- Log security events

### Performance
- Use pagination for large result sets
- Implement proper database indexes
- Use fetch strategies appropriately (LAZY vs EAGER)
- Configure connection pooling
- Monitor application metrics

### Database
- Use database migrations (Flyway/Liquibase)
- Implement proper indexing strategy
- Use transactions appropriately
- Monitor query performance
- Implement database constraints

## 🔍 Monitoring & Observability

Add these for production:
- Spring Boot Actuator for metrics
- Micrometer for application metrics
- Logback for structured logging
- Health check indicators
- Custom metrics for business logic

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Security Documentation](https://spring.io/projects/spring-security)
- [Spring Data JPA Documentation](https://spring.io/projects/spring-data-jpa)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🗺️ Roadmap

- [ ] Unit and integration tests
- [ ] Database migrations with Flyway
- [ ] Rate limiting with bucket4j
- [ ] Caching with Redis
- [ ] File upload handling
- [ ] Email service integration
- [ ] Monitoring with Actuator
- [ ] Docker Compose for development
- [ ] CI/CD pipeline setup
- [ ] Multi-profile configuration

---

Built with ❤️ using Spring Boot and Spring Security