-- Create seats table
CREATE TABLE IF NOT EXISTS seats (
    id SERIAL PRIMARY KEY,
    vehicle_id INTEGER REFERENCES vehicles(id),
    seat_number VARCHAR(10) NOT NULL,
    seat_type VARCHAR(20) DEFAULT 'standard', -- 'standard', 'premium', 'disabled'
    row_number INTEGER NOT NULL,
    column_position CHAR(1) NOT NULL, -- A, B, C, D
    price_modifier DECIMAL(5,2) DEFAULT 1.00, -- Multiplicador del precio base
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(vehicle_id, seat_number)
);

-- Create indexes for seats
CREATE INDEX IF NOT EXISTS idx_seats_vehicle_id ON seats(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_seats_seat_type ON seats(seat_type);