-- Create routes table
CREATE TABLE IF NOT EXISTS routes (
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(id),
    origin_city VARCHAR(100) NOT NULL,
    origin_terminal VARCHAR(255),
    destination_city VARCHAR(100) NOT NULL,
    destination_terminal VARCHAR(255),
    distance_km INTEGER,
    estimated_duration_minutes INTEGER,
    base_price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for routes
CREATE INDEX IF NOT EXISTS idx_routes_company_id ON routes(company_id);
CREATE INDEX IF NOT EXISTS idx_routes_origin_city ON routes(origin_city);
CREATE INDEX IF NOT EXISTS idx_routes_destination_city ON routes(destination_city);