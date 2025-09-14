.PHONY: build run test clean docker docker-up docker-down migrate seed

# Build the application
build:
	go build -o bin/server ./cmd/server

# Run the application locally
run:
	go run ./cmd/server/main.go

# Run tests
test:
	go test ./tests/...

# Clean build artifacts
clean:
	rm -rf bin/

# Build Docker image
docker:
	docker build -f docker/Dockerfile -t transport-booking-backend .

# Start Docker Compose services
docker-up:
	docker-compose -f docker/docker-compose.yml up --build

# Stop Docker Compose services
docker-down:
	docker-compose -f docker/docker-compose.yml down

# Run database migrations
migrate:
	./scripts/migrate.sh

# Seed database with initial data
seed:
	./scripts/seed_data.sh

# Generate Swagger documentation
swagger:
	swag init -g cmd/server/main.go -o docs

# Install dependencies
deps:
	go mod tidy
	go mod download

# Format code
fmt:
	go fmt ./...

# Lint code
lint:
	golangci-lint run

# Development setup
dev-setup: deps migrate seed
	@echo "Development environment setup complete"