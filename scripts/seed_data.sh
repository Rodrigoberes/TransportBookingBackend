#!/bin/bash

# Seed data script for Transport Booking Backend
# This script populates the database with initial data

set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Set default database URL if not provided
DATABASE_URL=${DATABASE_URL:-"postgresql://user:password@localhost:5432/transport_booking?sslmode=disable"}

echo "Seeding database with initial data..."
echo "Database URL: $DATABASE_URL"

# Seed companies
echo "Seeding companies..."
psql "$DATABASE_URL" << 'EOF'
INSERT INTO companies (name, email, phone, address) VALUES
('Transport Corp', 'contact@transportcorp.com', '+1234567890', '123 Main St, City, State'),
('Fast Travel Ltd', 'info@fasttravel.com', '+0987654321', '456 Oak Ave, City, State')
ON CONFLICT (email) DO NOTHING;
EOF

# Seed users
echo "Seeding users..."
psql "$DATABASE_URL" << 'EOF'
INSERT INTO users (email, password_hash, name, company_id) VALUES
('admin@transportcorp.com', '$2a$10$example.hash.here', 'Admin User', 1),
('user@fasttravel.com', '$2a$10$example.hash.here', 'Regular User', 2)
ON CONFLICT (email) DO NOTHING;
EOF

# Seed routes
echo "Seeding routes..."
psql "$DATABASE_URL" << 'EOF'
INSERT INTO routes (origin, destination, distance_km, estimated_duration_hours, price) VALUES
('New York', 'Boston', 350.0, 4.5, 45.00),
('Los Angeles', 'San Francisco', 615.0, 6.0, 75.00),
('Chicago', 'Detroit', 430.0, 5.0, 55.00)
ON CONFLICT DO NOTHING;
EOF

# Seed vehicles
echo "Seeding vehicles..."
psql "$DATABASE_URL" << 'EOF'
INSERT INTO vehicles (company_id, license_plate, model, capacity, status) VALUES
(1, 'ABC-123', 'Bus Model A', 50, 'active'),
(1, 'DEF-456', 'Bus Model B', 40, 'active'),
(2, 'GHI-789', 'Coach Model X', 45, 'active')
ON CONFLICT (license_plate) DO NOTHING;
EOF

# Seed seats
echo "Seeding seats..."
psql "$DATABASE_URL" << 'EOF'
INSERT INTO seats (vehicle_id, seat_number, seat_class, price_modifier) VALUES
(1, '1A', 'premium', 1.5),
(1, '1B', 'premium', 1.5),
(1, '2A', 'standard', 1.0),
(1, '2B', 'standard', 1.0)
ON CONFLICT (vehicle_id, seat_number) DO NOTHING;
EOF

echo "Database seeding completed successfully!"