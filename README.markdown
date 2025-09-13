# Transport Booking Backend

This is a Go-based backend for a transport booking system, built with the Gin framework, PostgreSQL (via Supabase), Docker, and Swagger/OpenAPI 3.0 for API documentation. The project follows a clean architecture with modular components for handling authentication, bookings, routes, and user management.

## Project Structure

```
transport-booking-backend/
├── cmd/                    # Entry point for the application
├── internal/               # Core application logic
│   ├── api/                # HTTP handlers, middleware, and routes
│   ├── config/             # Configuration loading
│   ├── models/             # Data models
│   ├── repository/         # Database operations
│   ├── services/           # Business logic
│   └── utils/              # Utility functions (JWT, password, validation)
├── pkg/                    # External package integrations
├── migrations/             # Database migration scripts
├── docs/                   # API documentation (Swagger, architecture)
├── tests/                  # Unit and integration tests
├── docker/                 # Docker configuration
├── scripts/                # Utility scripts for migrations and seeding
├── .github/workflows/      # CI/CD pipelines
├── go.mod                  # Go module dependencies
├── go.sum                  # Dependency checksums
├── Makefile                # Build and run commands
└── README.md               # Project documentation
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

## Notes

- **Supabase**: Ensure the `DATABASE_URL` matches your Supabase project's PostgreSQL connection string.
- **Swagger**: Update `docs/swagger.yaml` manually or regenerate with `swag init` as handlers change.
- **Testing**: Write unit tests for services (`internal/services/`) and integration tests for API endpoints (`internal/api/handlers/`).

For issues or contributions, please open a pull request or issue on the repository.