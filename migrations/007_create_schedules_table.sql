-- Create schedules table
CREATE TABLE IF NOT EXISTS schedules (
    id SERIAL PRIMARY KEY,
    route_id INTEGER REFERENCES routes(id),
    vehicle_id INTEGER REFERENCES vehicles(id),
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    days_of_week INTEGER[] NOT NULL, -- [1,2,3,4,5,6,7] para días de la semana
    valid_from DATE NOT NULL,
    valid_until DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for schedules
CREATE INDEX IF NOT EXISTS idx_schedules_route_id ON schedules(route_id);
CREATE INDEX IF NOT EXISTS idx_schedules_vehicle_id ON schedules(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_schedules_valid_from ON schedules(valid_from);
CREATE INDEX IF NOT EXISTS idx_schedules_valid_until ON schedules(valid_until);