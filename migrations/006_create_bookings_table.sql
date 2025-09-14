-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    schedule_id INTEGER REFERENCES schedules(id),
    booking_code VARCHAR(20) UNIQUE NOT NULL,
    travel_date DATE NOT NULL,
    departure_datetime TIMESTAMP NOT NULL,
    passenger_name VARCHAR(255) NOT NULL,
    passenger_document VARCHAR(20) NOT NULL,
    passenger_phone VARCHAR(20),
    total_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'paid', 'refunded'
    booking_status VARCHAR(20) DEFAULT 'active', -- 'active', 'cancelled', 'used'
    payment_method VARCHAR(20), -- 'credit_card', 'debit_card', 'cash'
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for bookings
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_schedule_id ON bookings(schedule_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_code ON bookings(booking_code);
CREATE INDEX IF NOT EXISTS idx_bookings_travel_date ON bookings(travel_date);
CREATE INDEX IF NOT EXISTS idx_bookings_payment_status ON bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_status ON bookings(booking_status);