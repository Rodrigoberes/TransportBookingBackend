# Transport Booking Backend

This is a Go-based backend for a transport booking system, built with the Gin framework, PostgreSQL (via Supabase), Docker, and Swagger/OpenAPI 3.0 for API documentation. The project follows a clean architecture with modular components for handling authentication, bookings, routes, and user management.

## Features

- ✅ Clean Architecture implementation
- ✅ PostgreSQL database with migrations
- ✅ JWT-based authentication
- ✅ RESTful API with Gin framework
- ✅ Docker containerization
- ✅ Automated testing with testify
- ✅ CI/CD with GitHub Actions
- ✅ Swagger/OpenAPI documentation
- ✅ Database seeding scripts

## Project Structure

```
transport-booking-backend/
├── cmd/server/             # Application entry point
├── internal/
│   ├── api/
│   │   ├── handlers/       # HTTP handlers
│   │   ├── middleware/     # Custom middleware
│   │   └── routes/         # Route definitions
│   ├── config/             # Configuration management
│   ├── models/             # Data models
│   ├── repository/         # Database layer
│   ├── services/           # Business logic
│   └── utils/              # Utility functions
├── pkg/database/           # Database connection
├── migrations/             # Database migrations
├── docs/                   # API documentation
├── tests/                  # Test files
├── docker/                 # Docker configuration
├── scripts/                # Utility scripts
├── .github/workflows/      # CI/CD pipelines
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

## Prerequisites

- **Go**: 1.21 or higher
- **Docker & Docker Compose**: For local development
- **PostgreSQL**: Hosted on Supabase
- **Swagger CLI**: For generating/validating API docs (`swag` for Go)
- **Make**: For running Makefile commands (optional)

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Rodrigoberes/TransportBookingBackend
   cd TransportBookingBackend
   ```

2. **Initialize Go Module** (if starting fresh):
   ```bash
   go mod init https://github.com/Rodrigoberes/TransportBookingBackend
   ```

3. **Install Dependencies**:
   ```bash
   go mod tidy
   ```

4. **Set Up Environment Variables**:
   Create a `.env` file in the root directory:
   ```env
   DATABASE_URL=postgresql://<user>:<password>@<host>:<port>/<dbname>?pgbouncer=true
   PORT=8080
   ENVIRONMENT=develop
   ```
   Replace placeholders with your Supabase PostgreSQL credentials.

5. **Run Database Migrations**:
   Ensure `golang-migrate` is installed:
   ```bash
   go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
   ```
   Apply migrations:
   ```bash
   ./scripts/migrate.sh
   ```

6. **Generate Swagger Documentation**:
   Install `swag`:
   ```bash
   go install github.com/swaggo/swag/cmd/swag@latest
   ```
   Generate docs:
   ```bash
   swag init -g cmd/server/main.go -o docs
   ```

## Running the Project

1. **Local Development**:
   Start the server:
   ```bash
   go run cmd/server/main.go
   ```

2. **Using Docker**:
   Build and run with Docker Compose:
   ```bash
   docker-compose up --build
   ```

3. **Using Makefile** (if configured):
   ```bash
   make run          # Run the server locally
   make test         # Run tests
   make migrate      # Apply migrations
   make docker       # Run with Docker
   ```

## Testing

Run unit and integration tests:
```bash
go test ./tests/...
```

## API Documentation

Access Swagger UI at:
```
http://localhost:8080/swagger/index.html
```

## Key Commands

- Initialize Go module: `go mod init https://github.com/Rodrigoberes/TransportBookingBackend`
- Install dependencies: `go mod tidy`
- Run migrations: `./scripts/migrate.sh`
- Generate Swagger docs: `swag init -g cmd/server/main.go -o docs`
- Run tests: `go test ./tests/...`
- Start server (local): `go run cmd/server/main.go`
- Start with Docker: `docker-compose up --build`
- Access Swagger UI: `http://localhost:8080/swagger/index.html`

## CI/CD

- **CI**: Configured in `.github/workflows/backend-ci.yml` for running tests on push/pull requests.
- **Deployment**: Configured in `.github/workflows/backend-deploy.yml` (customize for your deployment target).

## 🔒 Security Best Practices

### 🚨 Critical Security Warning

**Never commit real database credentials or secrets to version control!**

### Environment Variables Setup

#### For Production Deployment (Render/Railway/Heroku):
1. **Never hardcode credentials** in `render.yaml` or any config files
2. Set environment variables securely through your platform's dashboard:
   - **Render**: Dashboard → Service → Environment → Add Environment Variable
   - **Railway**: Dashboard → Project → Variables
   - **Heroku**: `heroku config:set KEY=value`

#### Required Environment Variables:
```bash
# Database (set via platform dashboard - NEVER in code)
DATABASE_URL=postgresql://[username]:[password]@[host]:[port]/[database]

# JWT Secret (generate securely)
JWT_SECRET=your-secure-random-jwt-secret-here

# Application
PORT=10000
ENVIRONMENT=production
```

#### For Supabase:
1. Go to **Supabase Dashboard → Settings → Database**
2. Copy the **Connection Pooling** URI (recommended for production)
3. Set as `DATABASE_URL` in your deployment platform

### Security Checklist:
- ✅ **Environment variables** for all secrets
- ✅ **No hardcoded credentials** in code or config files
- ✅ **SSL/TLS enabled** for database connections
- ✅ **Connection pooling** for production performance
- ✅ **Regular credential rotation**
- ✅ **Least-privilege database users**

### Local Development:
1. Copy `.env.example` to `.env` (create locally)
2. Fill with your development credentials
3. **Add `.env` to `.gitignore`**
4. **Never commit `.env` to version control**

## Notes

- **Supabase**: Ensure the `DATABASE_URL` matches your Supabase project's PostgreSQL connection string.
- **Swagger**: Update `docs/swagger.yaml` manually or regenerate with `swag init` as handlers change.
- **Testing**: Write unit tests for services (`internal/services/`) and integration tests for API endpoints (`internal/api/handlers/`).

For issues or contributions, please open a pull request or issue on the repository.