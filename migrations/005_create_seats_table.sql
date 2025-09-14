-- Create seats table
CREATE TABLE IF NOT EXISTS seats (
    id SERIAL PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_class VARCHAR(20) DEFAULT 'standard' CHECK (seat_class IN ('standard', 'premium', 'vip')),
    price_modifier DECIMAL(3,2) DEFAULT 1.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    UNIQUE(vehicle_id, seat_number)
);

-- Create indexes for seats
CREATE INDEX IF NOT EXISTS idx_seats_vehicle_id ON seats(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_seats_seat_class ON seats(seat_class);