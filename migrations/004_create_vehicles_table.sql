-- Create vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(id),
    license_plate VARCHAR(10) UNIQUE NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL, -- 'bus', 'train'
    brand VARCHAR(50),
    model VARCHAR(50),
    year INTEGER,
    total_seats INTEGER NOT NULL,
    seat_layout JSONB NOT NULL, -- Configuración de asientos
    amenities JSONB, -- WiFi, AC, etc.
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for vehicles
CREATE INDEX IF NOT EXISTS idx_vehicles_company_id ON vehicles(company_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_is_active ON vehicles(is_active);