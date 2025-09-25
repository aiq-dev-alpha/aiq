# Django REST API Template

A production-ready Django REST API template with JWT authentication, PostgreSQL database, comprehensive documentation, and modern best practices.

## 🚀 Features

- **Django REST Framework** - Powerful toolkit for building REST APIs
- **JWT Authentication** - Secure token-based authentication
- **PostgreSQL Integration** - Robust relational database with excellent Django support
- **Custom User Model** - Extended user model with email authentication
- **API Documentation** - Auto-generated OpenAPI/Swagger documentation
- **CORS Support** - Cross-Origin Resource Sharing configuration
- **Celery Integration** - Background task processing with Redis
- **Admin Interface** - Django's powerful admin interface
- **Environment Configuration** - Environment-based settings management
- **Production Ready** - Gunicorn, WhiteNoise, and production configurations

## 📁 Project Structure

```
├── manage.py                 # Django management script
├── requirements.txt          # Python dependencies
├── .env.example             # Environment variables template
├── project_name/            # Main Django project
│   ├── settings.py         # Django settings
│   ├── urls.py             # Main URL configuration
│   ├── wsgi.py             # WSGI application
│   └── celery.py           # Celery configuration
└── apps/                   # Django applications
    ├── accounts/           # User authentication and management
    │   ├── models.py      # Custom User model
    │   ├── serializers.py # DRF serializers
    │   ├── views.py       # API views
    │   ├── urls.py        # URL patterns
    │   └── admin.py       # Admin configuration
    ├── posts/             # Post CRUD operations
    │   ├── models.py      # Post model
    │   ├── serializers.py # DRF serializers
    │   ├── views.py       # API views
    │   ├── urls.py        # URL patterns
    │   └── admin.py       # Admin configuration
    └── common/            # Shared utilities
        ├── models.py      # Base models (TimeStampedModel)
        ├── authentication.py # JWT authentication
        ├── utils.py       # Utility functions
        └── views.py       # Common views (health check)
```

## 📦 Dependencies & Library Choices

### 🎯 Core Framework
| Library | Version | Why We Chose It |
|---------|---------|-----------------|
| **Django** | `5.0.1` | Mature, secure, and feature-rich web framework with excellent documentation |
| **djangorestframework** | `3.14.0` | De facto standard for building REST APIs in Django, comprehensive features |
| **psycopg2-binary** | `2.9.9` | Most popular and reliable PostgreSQL adapter for Python |

### 🔐 Authentication & Security
| Library | Purpose | Why This Choice |
|---------|---------|----------------|
| **PyJWT** | JWT tokens | Pure Python implementation, secure, widely used |
| **django-cors-headers** | CORS handling | Official Django package for CORS, simple configuration |

### 📖 Documentation & API
| Library | Purpose | Benefits |
|---------|---------|---------|
| **drf-spectacular** | OpenAPI docs | Modern replacement for drf-yasg, OpenAPI 3.0 support |
| **django-filter** | API filtering | Powerful filtering capabilities for DRF |

### 🔄 Background Tasks & Caching
| Library | Purpose | Features |
|---------|---------|---------|
| **celery** | Background tasks | Industry standard for async task processing |
| **redis** | Message broker | Fast, reliable message broker and cache |

### 🚀 Production & Deployment
| Library | Purpose | Benefits |
|---------|---------|---------|
| **gunicorn** | WSGI server | Production-ready WSGI HTTP server |
| **whitenoise** | Static files | Simplified static file serving |
| **python-decouple** | Environment variables | Clean environment configuration |

### 🔄 Why These Libraries?

**Django REST Framework over Flask-RESTful:**
- More comprehensive feature set
- Built-in serialization and validation
- Excellent browsable API interface
- Strong authentication and permissions system
- Better integration with Django ORM
- Extensive third-party package ecosystem

**PostgreSQL over MySQL/SQLite:**
- Advanced features (JSON fields, arrays, full-text search)
- Better concurrent performance
- Strong ACID compliance
- Excellent Django integration
- Open source with permissive license

**PyJWT over other JWT libraries:**
- Pure Python implementation
- Secure by default
- Simple and clean API
- Well-maintained
- Industry standard algorithms

**Celery over RQ:**
- More mature and feature-rich
- Better monitoring and management tools
- Supports multiple message brokers
- Advanced routing and task scheduling
- Better error handling and retry mechanisms

## 🛠️ Setup

### Prerequisites
- Python 3.9 or higher
- PostgreSQL 12 or higher
- Redis (for Celery)
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

3. **Activate virtual environment:**
   ```bash
   source venv/bin/activate
   ```

4. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

5. **Create PostgreSQL database:**
   ```sql
   CREATE DATABASE my_api_db;
   ```

6. **Run migrations:**
   ```bash
   python manage.py migrate
   ```

7. **Create superuser:**
   ```bash
   python manage.py createsuperuser
   ```

8. **Start development server:**
   ```bash
   python manage.py runserver
   ```

### Manual Setup

1. **Copy template and customize:**
   ```bash
   cp -r django-template my_project
   cd my_project
   # Update project name in files
   ```

2. **Create virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment and database:**
   ```bash
   cp .env.example .env
   # Configure database settings
   python manage.py migrate
   ```

5. **Run development server:**
   ```bash
   python manage.py runserver
   ```

## 🏗️ API Architecture

### Model-View-Template (MVT) Pattern

**Models** (`models.py`)
- Data structure and database schema
- Business logic and validation
- Relationships and constraints

**Views** (`views.py`)
- Request handling and response formatting
- Authentication and permission checks
- Business logic coordination

**Serializers** (`serializers.py`)
- Data serialization/deserialization
- Input validation and sanitization
- API contract definition

**URLs** (`urls.py`)
- URL routing and endpoint mapping
- API versioning structure

## 🔐 Authentication System

### Custom User Model
```python
class User(AbstractUser, TimeStampedModel):
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)

    USERNAME_FIELD = 'email'  # Login with email instead of username
```

### JWT Authentication Flow
```python
# Register new user
POST /api/v1/auth/register/
{
    "email": "user@example.com",
    "username": "username",
    "password": "password123",
    "password_confirm": "password123",
    "first_name": "John",
    "last_name": "Doe"
}

# Login user
POST /api/v1/auth/login/
{
    "email": "user@example.com",
    "password": "password123"
}
# Returns: {"access_token": "...", "refresh_token": "...", "user": {...}}
```

## 📝 API Endpoints

### Authentication
- `POST /api/v1/auth/register/` - Register new user
- `POST /api/v1/auth/login/` - User login
- `GET /api/v1/auth/me/` - Get current user (protected)

### Posts
- `GET /api/v1/posts/` - Get all posts
- `POST /api/v1/posts/create/` - Create post (protected)
- `GET /api/v1/posts/{id}/` - Get specific post
- `PUT /api/v1/posts/{id}/update/` - Update post (protected, owner only)
- `DELETE /api/v1/posts/{id}/delete/` - Delete post (protected, owner only)

### Documentation & Utilities
- `GET /api/v1/schema/` - OpenAPI schema
- `GET /api/v1/docs/` - Swagger UI documentation
- `GET /health/` - Health check endpoint
- `GET /admin/` - Django admin interface

## 🗄️ Database Models

### User Model (Extended)
```python
class User(AbstractUser, TimeStampedModel):
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

### Post Model
```python
class Post(TimeStampedModel):
    title = models.CharField(max_length=255)
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

## 🔧 Configuration

Environment variables in `.env`:
```env
SECRET_KEY=your-super-secret-django-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

DATABASE_NAME=myapp_db
DATABASE_USER=postgres
DATABASE_PASSWORD=password
DATABASE_HOST=localhost
DATABASE_PORT=5432

JWT_SECRET_KEY=your-jwt-secret-key
REDIS_URL=redis://localhost:6379/0
CORS_ALLOWED_ORIGINS=http://localhost:3000
```

## 🧪 Testing

```bash
# Run all tests
python manage.py test

# Run tests with coverage (install coverage first)
coverage run --source='.' manage.py test
coverage report
coverage html

# Run specific app tests
python manage.py test apps.accounts

# Run with verbose output
python manage.py test --verbosity=2
```

## 🚢 Production Deployment

### Environment Setup
```bash
# Install production dependencies
pip install gunicorn psycopg2-binary

# Collect static files
python manage.py collectstatic --noinput

# Run database migrations
python manage.py migrate
```

### Gunicorn Configuration
```bash
# Start with Gunicorn
gunicorn project_name.wsgi:application --bind 0.0.0.0:8000 --workers 4

# With environment file
gunicorn project_name.wsgi:application --env DJANGO_SETTINGS_MODULE=project_name.settings
```

### Docker Deployment
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000
CMD ["gunicorn", "project_name.wsgi:application", "--bind", "0.0.0.0:8000"]
```

## 📋 Common Commands

```bash
# Database operations
python manage.py makemigrations
python manage.py migrate
python manage.py dbshell

# User management
python manage.py createsuperuser
python manage.py changepassword <username>

# Development
python manage.py runserver
python manage.py shell
python manage.py check

# Static files
python manage.py collectstatic
python manage.py findstatic <filename>

# Background tasks (Celery)
celery -A project_name worker -l info
celery -A project_name beat -l info
```

## 🎯 Best Practices

### Code Organization
- Use Django apps for logical separation
- Keep views thin, models fat
- Use serializers for validation
- Follow PEP 8 style guidelines

### Security
- Always validate input data
- Use Django's built-in security features
- Keep SECRET_KEY secure
- Use HTTPS in production
- Implement proper authentication and authorization

### Performance
- Use select_related() and prefetch_related() for queries
- Implement database indexes for frequently queried fields
- Use caching for expensive operations
- Optimize database queries with Django Debug Toolbar

### Database
- Use migrations for schema changes
- Implement soft deletes where appropriate
- Use database constraints for data integrity
- Index frequently queried columns

## 🔍 Monitoring & Debugging

Add these for production:
- Django Debug Toolbar for development
- Sentry for error tracking
- New Relic or similar for performance monitoring
- Logging configuration for production
- Health check endpoints with database connectivity

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework Documentation](https://www.django-rest-framework.org/)
- [Celery Documentation](https://docs.celeryproject.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🗺️ Roadmap

- [ ] Unit and integration tests
- [ ] API rate limiting
- [ ] File upload handling
- [ ] Email verification system
- [ ] Social authentication (OAuth)
- [ ] API versioning strategy
- [ ] Caching implementation
- [ ] WebSocket support
- [ ] Background job monitoring
- [ ] Multi-tenancy support

---

Built with ❤️ using Django and Django REST Framework