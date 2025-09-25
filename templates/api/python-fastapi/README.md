# FastAPI Template

A production-ready FastAPI template with authentication, database integration, testing, and Docker support.

## Features

- **FastAPI** - Modern, fast web framework for building APIs
- **SQLAlchemy** - SQL toolkit and Object-Relational Mapping (ORM)
- **PostgreSQL** - Robust, production-ready database
- **Alembic** - Database migration tool
- **JWT Authentication** - Secure token-based authentication with OAuth2
- **Pydantic** - Data validation using Python type annotations
- **CORS** - Cross-Origin Resource Sharing support
- **Celery** - Distributed task queue for background jobs
- **Redis** - In-memory data store for caching and task queues
- **Pytest** - Comprehensive testing framework
- **Docker** - Containerization support with Docker Compose
- **Structured Logging** - JSON-based logging with structlog
- **Type Hints** - Full type annotation coverage
- **Modern Python** - Python 3.10+ features and best practices

## Project Structure

```
├── app/
│   ├── api/                    # API endpoints
│   │   ├── endpoints/          # Individual endpoint modules
│   │   │   ├── items.py        # Item CRUD endpoints
│   │   │   ├── login.py        # Authentication endpoints
│   │   │   └── users.py        # User management endpoints
│   │   └── api.py              # API router configuration
│   ├── core/                   # Core application components
│   │   ├── config.py           # Application settings
│   │   ├── deps.py             # Dependency injection
│   │   ├── logging_config.py   # Logging configuration
│   │   └── security.py         # Security utilities
│   ├── crud/                   # Database CRUD operations
│   │   ├── base.py             # Base CRUD class
│   │   ├── crud_item.py        # Item CRUD operations
│   │   └── crud_user.py        # User CRUD operations
│   ├── db/                     # Database configuration
│   │   ├── base.py             # Database base imports
│   │   ├── base_class.py       # SQLAlchemy base class
│   │   ├── init_db.py          # Database initialization
│   │   └── session.py          # Database session
│   ├── models/                 # SQLAlchemy models
│   │   ├── item.py             # Item model
│   │   └── user.py             # User model
│   ├── schemas/                # Pydantic schemas
│   │   ├── item.py             # Item schemas
│   │   ├── msg.py              # Message schemas
│   │   ├── token.py            # Token schemas
│   │   └── user.py             # User schemas
│   └── services/               # Background services
│       ├── celery_app.py       # Celery configuration
│       └── tasks.py            # Celery tasks
├── alembic/                    # Database migrations
│   ├── versions/               # Migration files
│   ├── env.py                  # Alembic environment
│   └── script.py.mako          # Migration template
├── tests/                      # Test suite
│   ├── utils/                  # Test utilities
│   ├── conftest.py             # Pytest configuration
│   ├── test_auth.py            # Authentication tests
│   ├── test_main.py            # Main app tests
│   └── test_users.py           # User endpoint tests
├── .env.example                # Environment variables template
├── .dockerignore               # Docker ignore file
├── alembic.ini                 # Alembic configuration
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Docker image definition
├── main.py                     # FastAPI application entry point
├── pytest.ini                 # Pytest configuration
├── requirements.txt            # Python dependencies
└── setup-template.sh           # Project setup script
```

## Quick Start

### Using the Setup Script (Recommended)

1. **Run the setup script:**
   ```bash
   ./setup-template.sh my-awesome-api /path/to/projects
   ```

2. **Navigate to your project:**
   ```bash
   cd /path/to/projects/my-awesome-api
   ```

3. **Activate the virtual environment:**
   ```bash
   source venv/bin/activate
   ```

4. **Update environment variables:**
   ```bash
   # Edit .env file with your database and other settings
   nano .env
   ```

5. **Set up the database:**
   ```bash
   # Create initial migration
   alembic revision --autogenerate -m "Initial migration"

   # Apply migrations
   alembic upgrade head
   ```

6. **Run the application:**
   ```bash
   uvicorn main:app --reload
   ```

7. **Visit the API documentation:**
   - Interactive docs: http://localhost:8000/docs
   - ReDoc: http://localhost:8000/redoc

### Manual Setup

1. **Clone and set up the project:**
   ```bash
   # Copy template files to your project directory
   cp -r /path/to/template my-project
   cd my-project
   ```

2. **Create virtual environment:**
   ```bash
   python3.10 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env file with your settings
   ```

5. **Set up the database:**
   ```bash
   # Make sure PostgreSQL is running
   # Update DATABASE_URL in .env
   alembic revision --autogenerate -m "Initial migration"
   alembic upgrade head
   ```

### Using Docker

1. **Run with Docker Compose:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - API: http://localhost:8000
   - API docs: http://localhost:8000/docs

## Configuration

The application uses environment variables for configuration. Copy `.env.example` to `.env` and update the values:

### Core Settings
```env
PROJECT_NAME=My Awesome API
VERSION=1.0.0
DEBUG=False
API_V1_STR=/api/v1
HOST=0.0.0.0
PORT=8000
```

### Database
```env
DATABASE_URL=postgresql://user:password@localhost:5432/myapp_db
TEST_DATABASE_URL=postgresql://user:password@localhost:5432/myapp_test_db
```

### Security
```env
SECRET_KEY=your-super-secret-key-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### CORS
```env
BACKEND_CORS_ORIGINS=["http://localhost:3000", "http://localhost:8080"]
```

### Background Tasks
```env
REDIS_URL=redis://localhost:6379/0
```

### First User
```env
FIRST_SUPERUSER_EMAIL=admin@example.com
FIRST_SUPERUSER_PASSWORD=changethis
```

## API Endpoints

### Authentication
- `POST /api/v1/login/access-token` - Get access token
- `POST /api/v1/login/test-token` - Test access token

### Users
- `GET /api/v1/users/` - List users (admin only)
- `POST /api/v1/users/` - Create user (admin only)
- `GET /api/v1/users/me` - Get current user
- `PUT /api/v1/users/me` - Update current user
- `GET /api/v1/users/{user_id}` - Get user by ID
- `PUT /api/v1/users/{user_id}` - Update user (admin only)

### Items
- `GET /api/v1/items/` - List items
- `POST /api/v1/items/` - Create item
- `GET /api/v1/items/{item_id}` - Get item by ID
- `PUT /api/v1/items/{item_id}` - Update item
- `DELETE /api/v1/items/{item_id}` - Delete item

### System
- `GET /` - Root endpoint
- `GET /health` - Health check

## Authentication Flow

1. **Create user account** (admin only or through registration endpoint)
2. **Get access token:**
   ```bash
   curl -X POST "http://localhost:8000/api/v1/login/access-token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=admin@example.com&password=changethis"
   ```
3. **Use token in requests:**
   ```bash
   curl -X GET "http://localhost:8000/api/v1/users/me" \
        -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
   ```

## Database Migrations

### Create Migration
```bash
alembic revision --autogenerate -m "Description of changes"
```

### Apply Migrations
```bash
alembic upgrade head
```

### Rollback Migration
```bash
alembic downgrade -1
```

### View Migration History
```bash
alembic history
```

## Testing

### Run All Tests
```bash
pytest
```

### Run with Coverage
```bash
pytest --cov=app --cov-report=html
```

### Run Specific Test File
```bash
pytest tests/test_users.py
```

### Run Tests in Parallel
```bash
pytest -n auto
```

## Background Tasks

The template includes Celery for background task processing:

### Start Celery Worker
```bash
celery -A app.services.celery_app worker --loglevel=info
```

### Start Celery Beat (Scheduler)
```bash
celery -A app.services.celery_app beat --loglevel=info
```

### Monitor Tasks
```bash
celery -A app.services.celery_app flower
```

### Example Task Usage
```python
from app.services.tasks import example_task

# Queue a task
task = example_task.delay("John Doe")
result = task.get()  # Wait for result
```

## Logging

The application uses structured logging with JSON output in production:

```python
import structlog

logger = structlog.get_logger(__name__)
logger.info("User created", user_id=123, email="user@example.com")
```

## Deployment

### Production Checklist

1. **Update environment variables:**
   - Set `DEBUG=False`
   - Use strong `SECRET_KEY`
   - Configure production database
   - Set appropriate CORS origins

2. **Database:**
   - Run migrations: `alembic upgrade head`
   - Create database backups

3. **Security:**
   - Use HTTPS
   - Set up firewall rules
   - Review CORS settings
   - Update default superuser credentials

4. **Performance:**
   - Use production WSGI server (Gunicorn)
   - Set up reverse proxy (Nginx)
   - Configure database connection pooling
   - Enable caching

### Docker Deployment
```bash
# Build production image
docker build -t my-app .

# Run container
docker run -p 8000:8000 --env-file .env my-app
```

### Using Gunicorn
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
```

## Development

### Code Quality
```bash
# Format code
black .
isort .

# Type checking
mypy app/

# Linting
flake8 app/
```

### Pre-commit Hooks
```bash
pip install pre-commit
pre-commit install
```

### Adding Dependencies
```bash
pip install new-package
pip freeze > requirements.txt
```

## Troubleshooting

### Common Issues

1. **Database connection errors:**
   - Check DATABASE_URL in .env
   - Ensure PostgreSQL is running
   - Verify database exists

2. **Import errors:**
   - Check Python path
   - Ensure virtual environment is activated

3. **Authentication issues:**
   - Verify SECRET_KEY is set
   - Check token expiration
   - Ensure user exists and is active

4. **Migration errors:**
   - Check database permissions
   - Verify Alembic configuration
   - Review migration files

### Logs
```bash
# View application logs
docker-compose logs web

# View database logs
docker-compose logs db

# View Celery logs
docker-compose logs celery
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run the test suite
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the FastAPI documentation: https://fastapi.tiangolo.com/
- Review SQLAlchemy docs: https://docs.sqlalchemy.org/

---

**Happy coding!** 🚀