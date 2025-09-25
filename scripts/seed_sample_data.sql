-- =============================================================================
-- SAMPLE DATA FOR TRANSPORT BOOKING SYSTEM (ITALIAN CONTEXT)
-- =============================================================================
--
-- This file creates comprehensive sample data for testing the Flutter app.
-- It demonstrates the complete LINKED relationship structure with SHARED IDs:
--
-- COMPANIES (3 companies) [ID único]
--   ↓ owns (company_id)
-- ROUTES (12 routes between cities) [ID único + company_id]
--   ↓ operated by (route_id)
-- SCHEDULES (25+ schedules with different times) [ID único + route_id + vehicle_id]
--   ↓ uses (vehicle_id)
-- VEHICLES (6 vehicles with complete seat layouts) [ID único + company_id]
--   ↓ has (vehicle_id)
-- SEATS (200+ seats across all vehicles) [ID único + vehicle_id]
--
-- USERS (3 sample users) [ID único]
--   ↓ makes (user_id)
-- BOOKINGS (8 bookings with different statuses) [ID único + user_id + schedule_id]
--   ↓ links to (booking_id + seat_id)
-- BOOKING_SEATS (seat assignments) [booking_id + seat_id]
--   ↓ and
-- PAYMENTS (payment records) [booking_id]
--
-- 🔗 RELATIONSHIPS CLAVE:
-- • Route.company_id → Company.id
-- • Schedule.route_id → Route.id
-- • Schedule.vehicle_id → Vehicle.id
-- • Vehicle.company_id → Company.id
-- • Seat.vehicle_id → Vehicle.id
-- • Booking.schedule_id → Schedule.id
-- • BookingSeat.booking_id → Booking.id
-- • BookingSeat.seat_id → Seat.id
--
-- For Flutter App Usage:
-- 1. Search travels: GET /api/v1/travels/search?origin=Roma
--    → Returns ALL linked IDs and relationship data
-- 2. View details: Each result shows complete hierarchy
-- 3. Get seats: GET /api/v1/travels/seats?schedule_id=X&travel_date=Y
-- 4. Book: POST /api/v1/bookings with seat_ids array
-- 5. View bookings: GET /api/v1/bookings (shows user's bookings)
--
-- Run this after creating the database schema with migrations.
-- =============================================================================

-- Insert sample companies (Italian bus companies)
INSERT INTO companies (name, email, phone, address, cuit, is_active, icon, created_at, updated_at) VALUES
('FlixBus Italia', 'info@flixbus.it', '+39 02 1234-5678', 'Via Roma 123, Milano', 'IT12345678901', true, 'bus-icon-1.png', NOW(), NOW()),
('Itabus', 'prenotazioni@itabus.it', '+39 06 9876-5432', 'Piazza Venezia 456, Roma', 'IT98765432109', true, 'bus-icon-2.png', NOW(), NOW()),
('Marino Autolinee', 'info@marinobus.it', '+39 081 555-1234', 'Via Toledo 789, Napoli', 'IT55566677701', true, 'bus-icon-3.png', NOW(), NOW());

-- Insert sample routes (Italian cities network)
INSERT INTO routes (company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at) VALUES
-- FlixBus Italia routes
(1, 'Roma', 'Stazione Tiburtina', 'Milano', 'Stazione Centrale', 570, 420, 45.00, true, NOW(), NOW()),
(1, 'Roma', 'Stazione Tiburtina', 'Firenze', 'Stazione Santa Maria Novella', 310, 240, 25.00, true, NOW(), NOW()),
(1, 'Roma', 'Stazione Tiburtina', 'Napoli', 'Stazione Centrale', 220, 180, 20.00, true, NOW(), NOW()),
(1, 'Roma', 'Stazione Tiburtina', 'Venezia', 'Stazione Venezia Mestre', 530, 380, 40.00, true, NOW(), NOW()),
(1, 'Milano', 'Stazione Centrale', 'Roma', 'Stazione Tiburtina', 570, 420, 45.00, true, NOW(), NOW()),
(1, 'Firenze', 'Stazione Santa Maria Novella', 'Roma', 'Stazione Tiburtina', 310, 240, 25.00, true, NOW(), NOW()),

-- Itabus routes
(2, 'Torino', 'Stazione Porta Susa', 'Milano', 'Stazione Centrale', 140, 120, 15.00, true, NOW(), NOW()),
(2, 'Torino', 'Stazione Porta Susa', 'Genova', 'Stazione Principe', 170, 150, 18.00, true, NOW(), NOW()),
(2, 'Torino', 'Stazione Porta Susa', 'Roma', 'Stazione Tiburtina', 670, 480, 50.00, true, NOW(), NOW()),
(2, 'Milano', 'Stazione Centrale', 'Torino', 'Stazione Porta Susa', 140, 120, 15.00, true, NOW(), NOW()),
(2, 'Genova', 'Stazione Principe', 'Torino', 'Stazione Porta Susa', 170, 150, 18.00, true, NOW(), NOW()),

-- Marino Autolinee routes
(3, 'Napoli', 'Stazione Centrale', 'Roma', 'Stazione Tiburtina', 220, 180, 20.00, true, NOW(), NOW()),
(3, 'Napoli', 'Stazione Centrale', 'Bari', 'Stazione Centrale', 260, 240, 22.00, true, NOW(), NOW()),
(3, 'Napoli', 'Stazione Centrale', 'Salerno', 'Stazione Salerno', 50, 60, 8.00, true, NOW(), NOW()),
(3, 'Roma', 'Stazione Tiburtina', 'Napoli', 'Stazione Centrale', 220, 180, 20.00, true, NOW(), NOW()),
(3, 'Bari', 'Stazione Centrale', 'Napoli', 'Stazione Centrale', 260, 240, 22.00, true, NOW(), NOW()),

-- Additional cross-company routes
(1, 'Milano', 'Stazione Centrale', 'Venezia', 'Stazione Venezia Mestre', 270, 180, 28.00, true, NOW(), NOW()),
(2, 'Torino', 'Stazione Porta Susa', 'Venezia', 'Stazione Venezia Mestre', 360, 240, 32.00, true, NOW(), NOW()),
(3, 'Napoli', 'Stazione Centrale', 'Milano', 'Stazione Centrale', 780, 540, 55.00, true, NOW(), NOW());

-- Insert sample vehicles
INSERT INTO vehicles (company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at) VALUES
(1, 'ABC-123', 'Bus', 'Mercedes-Benz', 'O500R', 2020, 45, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "TV"]', true, NOW(), NOW()),
(1, 'DEF-456', 'Bus', 'Scania', 'K360', 2019, 50, '{"rows": 17, "columns": 3}', '["WiFi", "AC", "Snacks"]', true, NOW(), NOW()),
(2, 'GHI-789', 'Bus', 'Iveco', 'Cursor', 2021, 40, '{"rows": 13, "columns": 3}', '["WiFi", "AC"]', true, NOW(), NOW()),
(2, 'JKL-012', 'Bus', 'Volvo', 'B8R', 2022, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW()),
(3, 'MNO-345', 'Bus', 'Mercedes-Benz', 'O500R', 2018, 42, '{"rows": 14, "columns": 3}', '["AC", "TV"]', true, NOW(), NOW()),
(3, 'PQR-678', 'Bus', 'Scania', 'K400', 2020, 46, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "Snacks", "TV"]', true, NOW(), NOW());

-- Insert sample seats for all vehicles (complete seat layouts)
-- Function to generate seats for a vehicle
CREATE OR REPLACE FUNCTION generate_seats(vehicle_id_param INT, total_seats_param INT)
RETURNS VOID AS $$
DECLARE
    seat_num INT := 1;
    row_num INT := 1;
    col_pos TEXT;
    seat_type TEXT;
    price_mod FLOAT;
BEGIN
    WHILE seat_num <= total_seats_param LOOP
        -- Determine column position (A, B, C, D)
        col_pos := CHR(65 + ((seat_num - 1) % 4));

        -- Determine seat type and price modifier
        IF col_pos = 'A' OR col_pos = 'D' THEN
            seat_type := 'Window';
            price_mod := 1.0;
        ELSIF col_pos = 'B' THEN
            seat_type := 'Middle';
            price_mod := 0.9;
        ELSE
            seat_type := 'Aisle';
            price_mod := 1.0;
        END IF;

        -- Calculate row number
        row_num := ((seat_num - 1) / 4) + 1;

        -- Format seat number (e.g., 01A, 15C)
        INSERT INTO seats (vehicle_id, seat_number, seat_type, row_number, column_position, price_modifier, is_available, created_at)
        VALUES (vehicle_id_param, LPAD(row_num::TEXT, 2, '0') || col_pos, seat_type, row_num, col_pos, price_mod, true, NOW());

        seat_num := seat_num + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Generate seats for all vehicles
SELECT generate_seats(1, 45); -- Mercedes-Benz O500R
SELECT generate_seats(2, 50); -- Scania K360
SELECT generate_seats(3, 40); -- Iveco Cursor
SELECT generate_seats(4, 48); -- Volvo B8R
SELECT generate_seats(5, 42); -- Mercedes-Benz O500R
SELECT generate_seats(6, 46); -- Scania K400

-- Insert sample schedules (multiple times per route for variety)
INSERT INTO schedules (route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at) VALUES
-- Roma to Milano (Route 1)
(1, 1, '06:00:00', '16:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early morning
(1, 1, '08:30:00', '19:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(1, 2, '14:00:00', '00:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(1, 2, '22:30:00', '09:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night

-- Roma to Firenze (Route 2)
(2, 1, '05:45:00', '10:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(2, 1, '07:30:00', '12:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(2, 2, '15:15:00', '19:45:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(2, 2, '19:00:00', '23:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Evening

-- Roma to Napoli (Route 3)
(3, 1, '07:00:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(3, 2, '14:30:00', '18:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Torino to Milano (Route 7)
(7, 3, '06:00:00', '08:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(7, 3, '22:00:00', '00:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night
(7, 4, '08:30:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning

-- Torino to Genova (Route 8)
(8, 3, '09:00:00', '11:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(8, 4, '16:30:00', '19:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Napoli to Roma (Route 10)
(10, 5, '08:45:00', '11:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(10, 5, '15:30:00', '18:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(10, 6, '21:00:00', '23:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night

-- Napoli to Bari (Route 11)
(11, 5, '10:30:00', '13:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(11, 6, '17:15:00', '20:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Milano to Roma (Route 4)
(4, 6, '05:00:00', '15:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(4, 1, '12:30:00', '23:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Milano to Torino (Route 7)
(7, 4, '23:00:00', '01:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night bus
(7, 3, '07:30:00', '09:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning

-- Firenze to Roma (Route 5)
(5, 2, '06:30:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(5, 1, '18:45:00', '22:45:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Evening

-- Bari to Napoli (Route 12)
(12, 5, '08:00:00', '11:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(12, 6, '16:00:00', '19:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()); -- Afternoon

-- Insert sample users (expanded for comprehensive CRUD testing)
INSERT INTO users (first_name, last_name, email, phone, document_type, document_number, is_active, created_at, updated_at) VALUES
-- Original users
('Marco', 'Rossi', 'marco.rossi@email.com', '+39 333 123-4567', 'CI', 'CA12345678', true, NOW(), NOW()),
('Giulia', 'Bianchi', 'giulia.bianchi@email.com', '+39 347 987-6543', 'CI', 'CB87654321', true, NOW(), NOW()),
('Luca', 'Verdi', 'luca.verdi@email.com', '+39 320 555-1234', 'CI', 'CV11223344', true, NOW(), NOW()),

-- Additional users for testing CRUD operations
('Sofia', 'Romano', 'sofia.romano@email.com', '+39 331 456-7890', 'CI', 'CR56789012', true, NOW(), NOW()),
('Alessandro', 'Gallo', 'alessandro.gallo@email.com', '+39 334 321-0987', 'CI', 'CG34567890', true, NOW(), NOW()),
('Francesca', 'Martini', 'francesca.martini@email.com', '+39 335 654-3210', 'CI', 'CM45678901', true, NOW(), NOW()),
('Matteo', 'Barbieri', 'matteo.barbieri@email.com', '+39 336 987-0123', 'CI', 'CB56789023', true, NOW(), NOW()),
('Elena', 'Ferrari', 'elena.ferrari@email.com', '+39 337 210-3456', 'CI', 'CF67890134', true, NOW(), NOW()),
('Davide', 'Rizzo', 'davide.rizzo@email.com', '+39 338 543-6789', 'CI', 'CR78901245', true, NOW(), NOW()),
('Chiara', 'Moretti', 'chiara.moretti@email.com', '+39 339 876-9012', 'CI', 'CM89012356', true, NOW(), NOW()),
('Andrea', 'Conti', 'andrea.conti@email.com', '+39 340 109-2345', 'CI', 'CC90123467', true, NOW(), NOW()),
('Valentina', 'Greco', 'valentina.greco@email.com', '+39 341 432-5678', 'CI', 'CG01234578', true, NOW(), NOW()),
('Simone', 'Bruno', 'simone.bruno@email.com', '+39 342 765-8901', 'CI', 'CB12345689', true, NOW(), NOW()),
('Martina', 'Costa', 'martina.costa@email.com', '+39 343 098-1234', 'CI', 'CC23456790', true, NOW(), NOW()),
('Federico', 'Giordano', 'federico.giordano@email.com', '+39 344 321-4567', 'CI', 'CG34567801', true, NOW(), NOW()),
('Sara', 'Mancini', 'sara.mancini@email.com', '+39 345 654-7890', 'CI', 'CM45678912', true, NOW(), NOW()),
('Lorenzo', 'Longo', 'lorenzo.longo@email.com', '+39 346 987-0123', 'CI', 'CL56789023', true, NOW(), NOW()),
('Alice', 'Riva', 'alice.riva@email.com', '+39 347 210-3456', 'CI', 'CR67890134', true, NOW(), NOW()),
('Roberto', 'Villa', 'roberto.villa@email.com', '+39 348 543-6789', 'CI', 'CV78901245', true, NOW(), NOW()),
('Caterina', 'Lombardi', 'caterina.lombardi@email.com', '+39 349 876-9012', 'CI', 'CL89012356', true, NOW(), NOW()),
('Giovanni', 'Sala', 'giovanni.sala@email.com', '+39 350 109-2345', 'CI', 'CS90123467', true, NOW(), NOW()),
('Beatrice', 'Sanna', 'beatrice.sanna@email.com', '+39 351 432-5678', 'CI', 'CS01234578', true, NOW(), NOW()),
('Filippo', 'Basile', 'filippo.basile@email.com', '+39 352 765-8901', 'CI', 'CB12345689', true, NOW(), NOW()),
('Elisa', 'Pellegrini', 'elisa.pellegrini@email.com', '+39 353 098-1234', 'CI', 'CP23456790', true, NOW(), NOW());

-- Hash the passwords (bcrypt hash of 'password123' for all users)
-- In production, each user would have their own unique hashed password
UPDATE users SET password = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

-- Insert sample bookings (showing different statuses and relationships)
-- Note: Each booking links to a schedule, which links to route + vehicle
-- The schedule determines the travel details (route, vehicle, times)
INSERT INTO bookings (user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at) VALUES
-- Confirmed and paid bookings
(1, 1, 'BK001', CURRENT_DATE + INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days' + INTERVAL '6 hours', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 45.00, 'paid', 'confirmed', 'credit_card', 'Window seat preferred', NOW(), NOW()),
(1, 4, 'BK002', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days' + INTERVAL '22 hours 30 minutes', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 45.00, 'paid', 'confirmed', 'debit_card', 'Night bus - extra comfort', NOW(), NOW()),
(2, 6, 'BK003', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '5 days' + INTERVAL '7 hours 30 minutes', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 50.00, 'paid', 'confirmed', 'credit_card', 'First class service', NOW(), NOW()),
(2, 8, 'BK004', CURRENT_DATE + INTERVAL '14 days', CURRENT_DATE + INTERVAL '14 days' + INTERVAL '15 hours 15 minutes', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 15.00, 'paid', 'confirmed', 'paypal', NULL, NOW(), NOW()),
(3, 10, 'BK005', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days' + INTERVAL '8 hours 45 minutes', 'Luca Verdi', 'CV11223344', '+39 320 555-1234', 20.00, 'paid', 'confirmed', 'credit_card', 'Express service', NOW(), NOW()),

-- Pending bookings (payment in process)
(1, 15, 'BK006', CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '20 days' + INTERVAL '19 hours', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 18.00, 'pending', 'pending', 'bank_transfer', 'Awaiting payment confirmation', NOW(), NOW()),
(3, 22, 'BK007', CURRENT_DATE + INTERVAL '8 days', CURRENT_DATE + INTERVAL '8 days' + INTERVAL '16 hours', 'Luca Verdi', 'CV11223344', '+39 320 555-1234', 8.00, 'pending', 'pending', 'cash', 'Will pay at terminal', NOW(), NOW()),

-- Cancelled booking
(2, 12, 'BK008', CURRENT_DATE + INTERVAL '2 days', CURRENT_DATE + INTERVAL '2 days' + INTERVAL '14 hours', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 22.00, 'refunded', 'cancelled', 'credit_card', 'Trip cancelled - refunded', NOW(), NOW());

-- Insert booking_seats (linking bookings to specific seats)
INSERT INTO booking_seats (booking_id, seat_id, created_at) VALUES
(1, 1, NOW()), -- Juan gets seat 01A on vehicle 1
(2, 45, NOW()), -- María gets seat 15C on vehicle 1
(3, 89, NOW()); -- Carlos gets a seat on vehicle 5

-- Insert sample payments
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_id, created_at, updated_at) VALUES
(1, 2500.00, 'credit_card', 'completed', 'txn_001', NOW(), NOW()),
(2, 1200.00, 'debit_card', 'completed', 'txn_002', NOW(), NOW()),
(3, 1900.00, 'cash', 'pending', 'txn_003', NOW(), NOW());