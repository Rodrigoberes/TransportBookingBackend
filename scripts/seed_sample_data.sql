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
INSERT INTO companies (id, name, email, phone, address, cuit, is_active, icon, created_at, updated_at) VALUES
(1, 'FlixBus Italia', 'info@flixbus.it', '+39 02 1234-5678', 'Via Roma 123, Milano', '12345678901', true, 'bus-icon-1.png', NOW(), NOW()),
(2, 'Itabus', 'prenotazioni@itabus.it', '+39 06 9876-5432', 'Piazza Venezia 456, Roma', '98765432109', true, 'bus-icon-2.png', NOW(), NOW()),
(3, 'Marino Autolinee', 'info@marinobus.it', '+39 081 555-1234', 'Via Toledo 789, Napoli', '55566677701', true, 'bus-icon-3.png', NOW(), NOW());

-- Insert sample routes (Italian cities network)
INSERT INTO routes (id, company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at) VALUES
-- FlixBus Italia routes
(1, 1, 'Roma', 'Stazione Tiburtina', 'Milano', 'Stazione Centrale', 570, 420, 45.00, true, NOW(), NOW()),
(2, 1, 'Roma', 'Stazione Tiburtina', 'Firenze', 'Stazione Santa Maria Novella', 310, 240, 25.00, true, NOW(), NOW()),
(3, 1, 'Roma', 'Stazione Tiburtina', 'Napoli', 'Stazione Centrale', 220, 180, 20.00, true, NOW(), NOW()),
(4, 1, 'Roma', 'Stazione Tiburtina', 'Venezia', 'Stazione Venezia Mestre', 530, 380, 40.00, true, NOW(), NOW()),
(5, 1, 'Milano', 'Stazione Centrale', 'Roma', 'Stazione Tiburtina', 570, 420, 45.00, true, NOW(), NOW()),
(6, 1, 'Firenze', 'Stazione Santa Maria Novella', 'Roma', 'Stazione Tiburtina', 310, 240, 25.00, true, NOW(), NOW()),

-- Itabus routes
(7, 2, 'Torino', 'Stazione Porta Susa', 'Milano', 'Stazione Centrale', 140, 120, 15.00, true, NOW(), NOW()),
(8, 2, 'Torino', 'Stazione Porta Susa', 'Genova', 'Stazione Principe', 170, 150, 18.00, true, NOW(), NOW()),
(9, 2, 'Torino', 'Stazione Porta Susa', 'Roma', 'Stazione Tiburtina', 670, 480, 50.00, true, NOW(), NOW()),
(10, 2, 'Milano', 'Stazione Centrale', 'Torino', 'Stazione Porta Susa', 140, 120, 15.00, true, NOW(), NOW()),
(11, 2, 'Genova', 'Stazione Principe', 'Torino', 'Stazione Porta Susa', 170, 150, 18.00, true, NOW(), NOW()),

-- Marino Autolinee routes
(12, 3, 'Napoli', 'Stazione Centrale', 'Roma', 'Stazione Tiburtina', 220, 180, 20.00, true, NOW(), NOW()),
(13, 3, 'Napoli', 'Stazione Centrale', 'Bari', 'Stazione Centrale', 260, 240, 22.00, true, NOW(), NOW()),
(14, 3, 'Napoli', 'Stazione Centrale', 'Salerno', 'Stazione Salerno', 50, 60, 8.00, true, NOW(), NOW()),
(15, 3, 'Roma', 'Stazione Tiburtina', 'Napoli', 'Stazione Centrale', 220, 180, 20.00, true, NOW(), NOW()),
(16, 3, 'Bari', 'Stazione Centrale', 'Napoli', 'Stazione Centrale', 260, 240, 22.00, true, NOW(), NOW()),

-- Additional cross-company routes
(17, 1, 'Milano', 'Stazione Centrale', 'Venezia', 'Stazione Venezia Mestre', 270, 180, 28.00, true, NOW(), NOW()),
(18, 2, 'Torino', 'Stazione Porta Susa', 'Venezia', 'Stazione Venezia Mestre', 360, 240, 32.00, true, NOW(), NOW()),
(19, 3, 'Napoli', 'Stazione Centrale', 'Milano', 'Stazione Centrale', 780, 540, 55.00, true, NOW(), NOW());

-- Insert sample vehicles
INSERT INTO vehicles (id, company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at) VALUES
(1, 1, 'ABC-123', 'Bus', 'Mercedes-Benz', 'O500R', 2020, 45, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "TV"]', true, NOW(), NOW()),
(2, 1, 'DEF-456', 'Bus', 'Scania', 'K360', 2019, 50, '{"rows": 17, "columns": 3}', '["WiFi", "AC", "Snacks"]', true, NOW(), NOW()),
(3, 2, 'GHI-789', 'Bus', 'Iveco', 'Cursor', 2021, 40, '{"rows": 13, "columns": 3}', '["WiFi", "AC"]', true, NOW(), NOW()),
(4, 2, 'JKL-012', 'Bus', 'Volvo', 'B8R', 2022, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW()),
(5, 3, 'MNO-345', 'Bus', 'Mercedes-Benz', 'O500R', 2018, 42, '{"rows": 14, "columns": 3}', '["AC", "TV"]', true, NOW(), NOW()),
(6, 3, 'PQR-678', 'Bus', 'Scania', 'K400', 2020, 46, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "Snacks", "TV"]', true, NOW(), NOW());

-- Insert sample seats for vehicles (simplified version)
INSERT INTO seats (id, vehicle_id, seat_number, seat_type, row_number, column_position, price_modifier, is_available, created_at) VALUES
-- Vehicle 1 (Mercedes-Benz O500R - 45 seats)
(1, 1, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(2, 1, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(3, 1, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),
(4, 1, '02A', 'Window', 2, 'A', 1.0, true, NOW()),
(5, 1, '02B', 'Middle', 2, 'B', 0.9, true, NOW()),
(6, 1, '02C', 'Aisle', 2, 'C', 1.0, true, NOW()),
(7, 1, '03A', 'Window', 3, 'A', 1.0, true, NOW()),
(8, 1, '03B', 'Middle', 3, 'B', 0.9, true, NOW()),
(9, 1, '03C', 'Aisle', 3, 'C', 1.0, true, NOW()),
(10, 1, '04A', 'Window', 4, 'A', 1.0, true, NOW()),
(11, 1, '04B', 'Middle', 4, 'B', 0.9, true, NOW()),
(12, 1, '04C', 'Aisle', 4, 'C', 1.0, true, NOW()),
(13, 1, '05A', 'Window', 5, 'A', 1.0, true, NOW()),
(14, 1, '05B', 'Middle', 5, 'B', 0.9, true, NOW()),
(15, 1, '05C', 'Aisle', 5, 'C', 1.0, true, NOW()),

-- Vehicle 2 (Scania K360 - 50 seats)
(16, 2, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(17, 2, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(18, 2, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),
(19, 2, '01D', 'Window', 1, 'D', 1.0, true, NOW()),
(20, 2, '02A', 'Window', 2, 'A', 1.0, true, NOW()),
(21, 2, '02B', 'Middle', 2, 'B', 0.9, true, NOW()),
(22, 2, '02C', 'Aisle', 2, 'C', 1.0, true, NOW()),
(23, 2, '02D', 'Window', 2, 'D', 1.0, true, NOW()),

-- Vehicle 3 (Iveco Cursor - 40 seats)
(24, 3, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(25, 3, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(26, 3, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),
(27, 3, '02A', 'Window', 2, 'A', 1.0, true, NOW()),
(28, 3, '02B', 'Middle', 2, 'B', 0.9, true, NOW()),
(29, 3, '02C', 'Aisle', 2, 'C', 1.0, true, NOW()),

-- Vehicle 4 (Volvo B8R - 48 seats)
(30, 4, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(31, 4, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(32, 4, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),
(33, 4, '01D', 'Window', 1, 'D', 1.0, true, NOW()),

-- Vehicle 5 (Mercedes-Benz O500R - 42 seats)
(34, 5, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(35, 5, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(36, 5, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),

-- Vehicle 6 (Scania K400 - 46 seats)
(37, 6, '01A', 'Window', 1, 'A', 1.0, true, NOW()),
(38, 6, '01B', 'Middle', 1, 'B', 0.9, true, NOW()),
(39, 6, '01C', 'Aisle', 1, 'C', 1.0, true, NOW()),
(40, 6, '01D', 'Window', 1, 'D', 1.0, true, NOW());

-- Insert sample schedules (multiple times per route for variety)
INSERT INTO schedules (id, route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at) VALUES
-- Roma to Milano (Route 1)
(1, 1, 1, '06:00:00', '16:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early morning
(2, 1, 1, '08:30:00', '19:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(3, 1, 2, '14:00:00', '00:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(4, 1, 2, '22:30:00', '09:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night

-- Roma to Firenze (Route 2)
(5, 2, 1, '05:45:00', '10:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(6, 2, 1, '07:30:00', '12:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(7, 2, 2, '15:15:00', '19:45:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(8, 2, 2, '19:00:00', '23:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Evening

-- Roma to Napoli (Route 3)
(9, 3, 1, '07:00:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(10, 3, 2, '14:30:00', '18:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Torino to Milano (Route 7)
(11, 7, 3, '06:00:00', '08:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(12, 7, 3, '22:00:00', '00:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night
(13, 7, 4, '08:30:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning

-- Torino to Genova (Route 8)
(14, 8, 3, '09:00:00', '11:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(15, 8, 4, '16:30:00', '19:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Napoli to Roma (Route 10)
(16, 10, 5, '08:45:00', '11:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(17, 10, 5, '15:30:00', '18:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon
(18, 10, 6, '21:00:00', '23:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night

-- Napoli to Bari (Route 11)
(19, 11, 5, '10:30:00', '13:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(20, 11, 6, '17:15:00', '20:15:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Milano to Roma (Route 4)
(21, 4, 6, '05:00:00', '15:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Early
(22, 4, 1, '12:30:00', '23:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Afternoon

-- Milano to Torino (Route 7)
(23, 7, 4, '23:00:00', '01:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Night bus
(24, 7, 3, '07:30:00', '09:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning

-- Firenze to Roma (Route 5)
(25, 5, 2, '06:30:00', '10:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()), -- Morning
(26, 5, 1, '18:45:00', '22:45:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()); -- Evening

-- Insert sample users (expanded for comprehensive CRUD testing)
INSERT INTO users (id, first_name, last_name, email, phone, document_type, document_number, password_hash, is_active, created_at, updated_at) VALUES
-- Original users
(1, 'Marco', 'Rossi', 'marco.rossi@email.com', '+39 333 123-4567', 'CI', 'CA12345678', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(2, 'Giulia', 'Bianchi', 'giulia.bianchi@email.com', '+39 347 987-6543', 'CI', 'CB87654321', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(3, 'Luca', 'Verdi', 'luca.verdi@email.com', '+39 320 555-1234', 'CI', 'CV11223344', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),

-- Additional users for testing CRUD operations
(4, 'Sofia', 'Romano', 'sofia.romano@email.com', '+39 331 456-7890', 'CI', 'CR56789012', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(5, 'Alessandro', 'Gallo', 'alessandro.gallo@email.com', '+39 334 321-0987', 'CI', 'CG34567890', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(6, 'Francesca', 'Martini', 'francesca.martini@email.com', '+39 335 654-3210', 'CI', 'CM45678901', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(7, 'Matteo', 'Barbieri', 'matteo.barbieri@email.com', '+39 336 987-0123', 'CI', 'CB56789023', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(8, 'Elena', 'Ferrari', 'elena.ferrari@email.com', '+39 337 210-3456', 'CI', 'CF67890134', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(9, 'Davide', 'Rizzo', 'davide.rizzo@email.com', '+39 338 543-6789', 'CI', 'CR78901245', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(10, 'Chiara', 'Moretti', 'chiara.moretti@email.com', '+39 339 876-9012', 'CI', 'CM89012356', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(11, 'Andrea', 'Conti', 'andrea.conti@email.com', '+39 340 109-2345', 'CI', 'CC90123467', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(12, 'Valentina', 'Greco', 'valentina.greco@email.com', '+39 341 432-5678', 'CI', 'CG01234578', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(13, 'Simone', 'Bruno', 'simone.bruno@email.com', '+39 342 765-8901', 'CI', 'CB12345689', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(14, 'Martina', 'Costa', 'martina.costa@email.com', '+39 343 098-1234', 'CI', 'CC23456790', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(15, 'Federico', 'Giordano', 'federico.giordano@email.com', '+39 344 321-4567', 'CI', 'CG34567801', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(16, 'Sara', 'Mancini', 'sara.mancini@email.com', '+39 345 654-7890', 'CI', 'CM45678912', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(17, 'Lorenzo', 'Longo', 'lorenzo.longo@email.com', '+39 346 987-0123', 'CI', 'CL56789023', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(18, 'Alice', 'Riva', 'alice.riva@email.com', '+39 347 210-3456', 'CI', 'CR67890134', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(19, 'Roberto', 'Villa', 'roberto.villa@email.com', '+39 348 543-6789', 'CI', 'CV78901245', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(20, 'Caterina', 'Lombardi', 'caterina.lombardi@email.com', '+39 349 876-9012', 'CI', 'CL89012356', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(21, 'Giovanni', 'Sala', 'giovanni.sala@email.com', '+39 350 109-2345', 'CI', 'CS90123467', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(22, 'Beatrice', 'Sanna', 'beatrice.sanna@email.com', '+39 351 432-5678', 'CI', 'CS01234578', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(23, 'Filippo', 'Basile', 'filippo.basile@email.com', '+39 352 765-8901', 'CI', 'CB12345689', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(24, 'Elisa', 'Pellegrini', 'elisa.pellegrini@email.com', '+39 353 098-1234', 'CI', 'CP23456790', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW());

-- Passwords are set in the INSERT statements above

-- Insert sample bookings (showing different statuses and relationships)
-- Note: Each booking links to a schedule, which links to route + vehicle
-- The schedule determines the travel details (route, vehicle, times)
INSERT INTO bookings (id, user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at) VALUES
-- Confirmed and paid bookings
(1, 1, 1, 'BK001', CURRENT_DATE + INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days' + INTERVAL '6 hours', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 45.00, 'paid', 'confirmed', 'credit_card', 'Window seat preferred', NOW(), NOW()),
(2, 1, 2, 'BK002', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days' + INTERVAL '8 hours 30 minutes', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 45.00, 'paid', 'confirmed', 'debit_card', 'Morning bus', NOW(), NOW()),
(3, 2, 3, 'BK003', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '5 days' + INTERVAL '14 hours', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 45.00, 'paid', 'confirmed', 'credit_card', 'Afternoon service', NOW(), NOW()),
(4, 2, 4, 'BK004', CURRENT_DATE + INTERVAL '14 days', CURRENT_DATE + INTERVAL '14 days' + INTERVAL '22 hours 30 minutes', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 45.00, 'paid', 'confirmed', 'paypal', 'Night bus', NOW(), NOW()),
(5, 3, 5, 'BK005', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days' + INTERVAL '5 hours 45 minutes', 'Luca Verdi', 'CV11223344', '+39 320 555-1234', 25.00, 'paid', 'confirmed', 'credit_card', 'Express service', NOW(), NOW()),

-- Pending bookings (payment in process)
(6, 1, 6, 'BK006', CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '20 days' + INTERVAL '7 hours 30 minutes', 'Marco Rossi', 'CA12345678', '+39 333 123-4567', 25.00, 'pending', 'pending', 'bank_transfer', 'Awaiting payment confirmation', NOW(), NOW()),
(7, 3, 7, 'BK007', CURRENT_DATE + INTERVAL '8 days', CURRENT_DATE + INTERVAL '8 days' + INTERVAL '15 hours 15 minutes', 'Luca Verdi', 'CV11223344', '+39 320 555-1234', 25.00, 'pending', 'pending', 'cash', 'Will pay at terminal', NOW(), NOW()),

-- Cancelled booking
(8, 2, 8, 'BK008', CURRENT_DATE + INTERVAL '2 days', CURRENT_DATE + INTERVAL '2 days' + INTERVAL '19 hours', 'Giulia Bianchi', 'CB87654321', '+39 347 987-6543', 25.00, 'refunded', 'cancelled', 'credit_card', 'Trip cancelled - refunded', NOW(), NOW());

-- Insert booking_seats (linking bookings to specific seats)
INSERT INTO booking_seats (booking_id, seat_id, created_at) VALUES
(1, 1, NOW()), -- Marco gets seat 01A on vehicle 1
(2, 2, NOW()), -- Marco gets seat 01B on vehicle 1
(3, 3, NOW()); -- Giulia gets seat 01C on vehicle 1

-- Insert sample payments
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_id, created_at, updated_at) VALUES
(1, 45.00, 'credit_card', 'completed', 'txn_001', NOW(), NOW()),
(2, 45.00, 'debit_card', 'completed', 'txn_002', NOW(), NOW()),
(3, 45.00, 'credit_card', 'completed', 'txn_003', NOW(), NOW()),
(4, 45.00, 'paypal', 'completed', 'txn_004', NOW(), NOW()),
(5, 25.00, 'credit_card', 'completed', 'txn_005', NOW(), NOW()),
(6, 25.00, 'bank_transfer', 'pending', 'txn_006', NOW(), NOW()),
(7, 25.00, 'cash', 'pending', 'txn_007', NOW(), NOW()),
(8, 25.00, 'credit_card', 'refunded', 'txn_008', NOW(), NOW());
-- Additional companies for expanded dataset
INSERT INTO companies (id, name, email, phone, address, cuit, is_active, icon, created_at, updated_at) VALUES
(4, 'SITA', 'info@sita.it', '+39 055 123-4567', 'Via Firenze 123, Firenze', '11122233301', true, 'bus-icon-4.png', NOW(), NOW()),
(5, 'Baltour', 'info@baltour.it', '+39 041 987-6543', 'Via Venezia 456, Venezia', '44455566602', true, 'bus-icon-5.png', NOW(), NOW()),
(6, 'Autostradale', 'info@autostradale.it', '+39 010 555-7890', 'Via Genova 789, Genova', '77788899903', true, 'bus-icon-6.png', NOW(), NOW()),
(7, 'Busitalia', 'info@busitalia.it', '+39 051 321-0987', 'Via Bologna 101, Bologna', '00011122204', true, 'bus-icon-7.png', NOW(), NOW()),
(8, 'Trenitalia Bus', 'info@trenitalia-bus.it', '+39 06 654-3210', 'Via Roma 202, Roma', '33344455505', true, 'bus-icon-8.png', NOW(), NOW()),
(9, 'SAF', 'info@saf.it', '+39 071 789-0123', 'Via Ancona 303, Ancona', '66677788806', true, 'bus-icon-9.png', NOW(), NOW()),
(10, 'Cotral', 'info@cotral.it', '+39 06 111-2222', 'Via Lazio 404, Latina', '99900011107', true, 'bus-icon-10.png', NOW(), NOW());

-- Additional routes for new companies
INSERT INTO routes (id, company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at) VALUES
-- SITA routes (company 4)
(20, 4, 'Firenze', 'Stazione Santa Maria Novella', 'Pisa', 'Stazione Pisa Centrale', 80, 90, 12.00, true, NOW(), NOW()),
(21, 4, 'Firenze', 'Stazione Santa Maria Novella', 'Siena', 'Stazione Siena', 70, 80, 10.00, true, NOW(), NOW()),
(22, 4, 'Firenze', 'Stazione Santa Maria Novella', 'Bologna', 'Stazione Bologna Centrale', 100, 120, 15.00, true, NOW(), NOW()),
(23, 4, 'Pisa', 'Stazione Pisa Centrale', 'Firenze', 'Stazione Santa Maria Novella', 80, 90, 12.00, true, NOW(), NOW()),
(24, 4, 'Siena', 'Stazione Siena', 'Firenze', 'Stazione Santa Maria Novella', 70, 80, 10.00, true, NOW(), NOW()),
(25, 4, 'Bologna', 'Stazione Bologna Centrale', 'Firenze', 'Stazione Santa Maria Novella', 100, 120, 15.00, true, NOW(), NOW()),

-- Baltour routes (company 5)
(26, 5, 'Venezia', 'Stazione Venezia Mestre', 'Padova', 'Stazione Padova', 40, 50, 8.00, true, NOW(), NOW()),
(27, 5, 'Venezia', 'Stazione Venezia Mestre', 'Verona', 'Stazione Verona Porta Nuova', 120, 140, 18.00, true, NOW(), NOW()),
(28, 5, 'Venezia', 'Stazione Venezia Mestre', 'Trieste', 'Stazione Trieste Centrale', 150, 160, 20.00, true, NOW(), NOW()),
(29, 5, 'Padova', 'Stazione Padova', 'Venezia', 'Stazione Venezia Mestre', 40, 50, 8.00, true, NOW(), NOW()),
(30, 5, 'Verona', 'Stazione Verona Porta Nuova', 'Venezia', 'Stazione Venezia Mestre', 120, 140, 18.00, true, NOW(), NOW()),
(31, 5, 'Trieste', 'Stazione Trieste Centrale', 'Venezia', 'Stazione Venezia Mestre', 150, 160, 20.00, true, NOW(), NOW()),

-- Autostradale routes (company 6)
(32, 6, 'Genova', 'Stazione Principe', 'Savona', 'Stazione Savona', 50, 60, 9.00, true, NOW(), NOW()),
(33, 6, 'Genova', 'Stazione Principe', 'La Spezia', 'Stazione La Spezia Centrale', 100, 110, 14.00, true, NOW(), NOW()),
(34, 6, 'Genova', 'Stazione Principe', 'Milano', 'Stazione Centrale', 150, 160, 22.00, true, NOW(), NOW()),
(35, 6, 'Savona', 'Stazione Savona', 'Genova', 'Stazione Principe', 50, 60, 9.00, true, NOW(), NOW()),
(36, 6, 'La Spezia', 'Stazione La Spezia Centrale', 'Genova', 'Stazione Principe', 100, 110, 14.00, true, NOW(), NOW()),
(37, 6, 'Milano', 'Stazione Centrale', 'Genova', 'Stazione Principe', 150, 160, 22.00, true, NOW(), NOW()),

-- Busitalia routes (company 7)
(38, 7, 'Bologna', 'Stazione Bologna Centrale', 'Modena', 'Stazione Modena', 80, 90, 12.00, true, NOW(), NOW()),
(39, 7, 'Bologna', 'Stazione Bologna Centrale', 'Parma', 'Stazione Parma', 100, 110, 15.00, true, NOW(), NOW()),
(40, 7, 'Bologna', 'Stazione Bologna Centrale', 'Ferrara', 'Stazione Ferrara', 50, 60, 9.00, true, NOW(), NOW()),
(41, 7, 'Modena', 'Stazione Modena', 'Bologna', 'Stazione Bologna Centrale', 80, 90, 12.00, true, NOW(), NOW()),
(42, 7, 'Parma', 'Stazione Parma', 'Bologna', 'Stazione Bologna Centrale', 100, 110, 15.00, true, NOW(), NOW()),
(43, 7, 'Ferrara', 'Stazione Ferrara', 'Bologna', 'Stazione Bologna Centrale', 50, 60, 9.00, true, NOW(), NOW()),

-- Trenitalia Bus routes (company 8)
(44, 8, 'Roma', 'Stazione Tiburtina', 'Lazio', 'Stazione Latina', 60, 70, 10.00, true, NOW(), NOW()),
(45, 8, 'Roma', 'Stazione Tiburtina', 'Frosinone', 'Stazione Frosinone', 80, 90, 12.00, true, NOW(), NOW()),
(46, 8, 'Roma', 'Stazione Tiburtina', 'Cassino', 'Stazione Cassino', 120, 130, 16.00, true, NOW(), NOW()),
(47, 8, 'Lazio', 'Stazione Latina', 'Roma', 'Stazione Tiburtina', 60, 70, 10.00, true, NOW(), NOW()),
(48, 8, 'Frosinone', 'Stazione Frosinone', 'Roma', 'Stazione Tiburtina', 80, 90, 12.00, true, NOW(), NOW()),
(49, 8, 'Cassino', 'Stazione Cassino', 'Roma', 'Stazione Tiburtina', 120, 130, 16.00, true, NOW(), NOW()),

-- SAF routes (company 9)
(50, 9, 'Ancona', 'Stazione Ancona', 'Pesaro', 'Stazione Pesaro', 40, 50, 8.00, true, NOW(), NOW()),
(51, 9, 'Ancona', 'Stazione Ancona', 'Macerata', 'Stazione Macerata', 60, 70, 10.00, true, NOW(), NOW()),
(52, 9, 'Ancona', 'Stazione Ancona', 'Ascoli Piceno', 'Stazione Ascoli Piceno', 100, 110, 14.00, true, NOW(), NOW()),
(53, 9, 'Pesaro', 'Stazione Pesaro', 'Ancona', 'Stazione Ancona', 40, 50, 8.00, true, NOW(), NOW()),
(54, 9, 'Macerata', 'Stazione Macerata', 'Ancona', 'Stazione Ancona', 60, 70, 10.00, true, NOW(), NOW()),
(55, 9, 'Ascoli Piceno', 'Stazione Ascoli Piceno', 'Ancona', 'Stazione Ancona', 100, 110, 14.00, true, NOW(), NOW()),

-- Cotral routes (company 10)
(56, 10, 'Latina', 'Stazione Latina', 'Roma', 'Stazione Tiburtina', 60, 70, 10.00, true, NOW(), NOW()),
(57, 10, 'Latina', 'Stazione Latina', 'Frosinone', 'Stazione Frosinone', 50, 60, 9.00, true, NOW(), NOW()),
(58, 10, 'Latina', 'Stazione Latina', 'Cassino', 'Stazione Cassino', 80, 90, 12.00, true, NOW(), NOW()),
(59, 10, 'Roma', 'Stazione Tiburtina', 'Latina', 'Stazione Latina', 60, 70, 10.00, true, NOW(), NOW()),
(60, 10, 'Frosinone', 'Stazione Frosinone', 'Latina', 'Stazione Latina', 50, 60, 9.00, true, NOW(), NOW()),
(61, 10, 'Cassino', 'Stazione Cassino', 'Latina', 'Stazione Latina', 80, 90, 12.00, true, NOW(), NOW());

-- Additional vehicles for new companies
INSERT INTO vehicles (id, company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at) VALUES
-- SITA vehicles (company 4)
(7, 4, 'STU-901', 'Bus', 'Mercedes-Benz', 'O500R', 2021, 44, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "TV"]', true, NOW(), NOW()),
(8, 4, 'VWX-234', 'Bus', 'Volvo', 'B8R', 2022, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW()),

-- Baltour vehicles (company 5)
(9, 5, 'YZA-567', 'Bus', 'Iveco', 'Cursor', 2020, 40, '{"rows": 13, "columns": 3}', '["WiFi", "AC"]', true, NOW(), NOW()),
(10, 5, 'BCD-890', 'Bus', 'Scania', 'K360', 2019, 50, '{"rows": 17, "columns": 3}', '["WiFi", "AC", "Snacks"]', true, NOW(), NOW()),

-- Autostradale vehicles (company 6)
(11, 6, 'EFG-123', 'Bus', 'Mercedes-Benz', 'O500R', 2021, 45, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "TV"]', true, NOW(), NOW()),
(12, 6, 'HIJ-456', 'Bus', 'Volvo', 'B8R', 2022, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW()),

-- Busitalia vehicles (company 7)
(13, 7, 'KLM-789', 'Bus', 'Iveco', 'Cursor', 2020, 40, '{"rows": 13, "columns": 3}', '["WiFi", "AC"]', true, NOW(), NOW()),
(14, 7, 'NOP-012', 'Bus', 'Scania', 'K400', 2020, 46, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "Snacks", "TV"]', true, NOW(), NOW()),

-- Trenitalia Bus vehicles (company 8)
(15, 8, 'QRS-345', 'Bus', 'Mercedes-Benz', 'O500R', 2018, 42, '{"rows": 14, "columns": 3}', '["AC", "TV"]', true, NOW(), NOW()),
(16, 8, 'TUV-678', 'Bus', 'Volvo', 'B8R', 2021, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW()),

-- SAF vehicles (company 9)
(17, 9, 'WXY-901', 'Bus', 'Iveco', 'Cursor', 2019, 40, '{"rows": 13, "columns": 3}', '["WiFi", "AC"]', true, NOW(), NOW()),
(18, 9, 'ZAB-234', 'Bus', 'Scania', 'K360', 2020, 50, '{"rows": 17, "columns": 3}', '["WiFi", "AC", "Snacks"]', true, NOW(), NOW()),

-- Cotral vehicles (company 10)
(19, 10, 'CDE-567', 'Bus', 'Mercedes-Benz', 'O500R', 2021, 44, '{"rows": 15, "columns": 3}', '["WiFi", "AC", "TV"]', true, NOW(), NOW()),
(20, 10, 'FGH-890', 'Bus', 'Volvo', 'B8R', 2022, 48, '{"rows": 16, "columns": 3}', '["WiFi", "AC", "USB"]', true, NOW(), NOW());


-- Additional schedules for new routes
INSERT INTO schedules (id, route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at) VALUES
-- SITA routes (routes 20-25)
(26, 20, 7, '07:00:00', '08:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(27, 20, 7, '12:00:00', '13:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(28, 21, 7, '08:00:00', '09:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(29, 22, 8, '09:00:00', '11:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(30, 23, 8, '14:00:00', '15:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(31, 24, 8, '16:00:00', '17:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(32, 25, 7, '10:00:00', '12:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- Baltour routes (routes 26-31)
(33, 26, 9, '06:30:00', '07:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(34, 27, 9, '11:00:00', '13:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(35, 28, 10, '15:00:00', '17:40:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(36, 29, 10, '18:00:00', '18:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(37, 30, 9, '09:00:00', '11:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(38, 31, 10, '13:00:00', '15:20:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- Autostradale routes (routes 32-37)
(39, 32, 11, '07:00:00', '08:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(40, 33, 11, '12:00:00', '13:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(41, 34, 12, '14:00:00', '16:40:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(42, 35, 12, '17:00:00', '18:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(43, 36, 11, '09:00:00', '10:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(44, 37, 12, '19:00:00', '21:40:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- Busitalia routes (routes 38-43)
(45, 38, 13, '08:00:00', '09:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(46, 39, 13, '13:00:00', '14:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(47, 40, 14, '10:00:00', '11:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(48, 41, 14, '15:00:00', '16:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(49, 42, 13, '11:00:00', '12:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(50, 43, 14, '16:00:00', '17:00:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- Trenitalia Bus routes (routes 44-49)
(51, 44, 15, '06:00:00', '07:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(52, 45, 15, '12:00:00', '13:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(53, 46, 16, '14:00:00', '15:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(54, 47, 16, '16:00:00', '17:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(55, 48, 15, '08:00:00', '09:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(56, 49, 16, '18:00:00', '19:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- SAF routes (routes 50-55)
(57, 50, 17, '07:00:00', '07:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(58, 51, 17, '12:00:00', '13:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(59, 52, 18, '15:00:00', '16:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(60, 53, 18, '17:00:00', '17:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(61, 54, 17, '09:00:00', '10:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(62, 55, 18, '14:00:00', '15:50:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),

-- Cotral routes (routes 56-61)
(63, 56, 19, '08:00:00', '09:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(64, 57, 19, '13:00:00', '14:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(65, 58, 20, '15:00:00', '16:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(66, 59, 20, '17:00:00', '18:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(67, 60, 19, '10:00:00', '11:10:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW()),
(68, 61, 20, '19:00:00', '20:30:00', '{1,2,3,4,5,6,7}', '2024-01-01', NULL, true, NOW(), NOW());

-- Additional users for expanded dataset
INSERT INTO users (id, first_name, last_name, email, phone, document_type, document_number, password_hash, is_active, created_at, updated_at) VALUES
(25, 'Pietro', 'Esposito', 'pietro.esposito@email.com', '+39 354 567-8901', 'CI', 'CE12345678', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(26, 'Giorgia', 'De Luca', 'giorgia.deluca@email.com', '+39 355 890-1234', 'CI', 'CD87654321', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(27, 'Antonio', 'Marino', 'antonio.marino@email.com', '+39 356 123-4567', 'CI', 'CM11223344', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(28, 'Valeria', 'Conte', 'valeria.conte@email.com', '+39 357 456-7890', 'CI', 'CC34567890', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(29, 'Riccardo', 'Gatti', 'riccardo.gatti@email.com', '+39 358 789-0123', 'CI', 'CG45678901', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(30, 'Camilla', 'Ferraro', 'camilla.ferraro@email.com', '+39 359 012-3456', 'CI', 'CF56789012', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(31, 'Daniele', 'Villa', 'daniele.villa@email.com', '+39 360 345-6789', 'CI', 'CV67890123', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(32, 'Ilaria', 'Santoro', 'ilaria.santoro@email.com', '+39 361 678-9012', 'CI', 'CS78901234', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(33, 'Tommaso', 'Lombardo', 'tommaso.lombardo@email.com', '+39 362 901-2345', 'CI', 'CL89012345', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW()),
(34, 'Rebecca', 'Russo', 'rebecca.russo@email.com', '+39 363 234-5678', 'CI', 'CR90123456', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true, NOW(), NOW());

-- Passwords are set in the INSERT statements above

-- Additional bookings for expanded dataset
INSERT INTO bookings (id, user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at) VALUES
(9, 26, 25, 'BK009', CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '15 days' + INTERVAL '7 hours', 'Pietro Esposito', 'CE12345678', '+39 354 567-8901', 9.00, 'paid', 'confirmed', 'credit_card', 'Morning service', NOW(), NOW()),
(10, 27, 30, 'BK010', CURRENT_DATE + INTERVAL '18 days', CURRENT_DATE + INTERVAL '18 days' + INTERVAL '14 hours', 'Giorgia De Luca', 'CD87654321', '+39 355 890-1234', 22.00, 'paid', 'confirmed', 'debit_card', 'Afternoon bus', NOW(), NOW()),
(11, 28, 35, 'BK011', CURRENT_DATE + INTERVAL '12 days', CURRENT_DATE + INTERVAL '12 days' + INTERVAL '8 hours', 'Antonio Marino', 'CM11223344', '+39 356 123-4567', 12.00, 'paid', 'confirmed', 'paypal', 'Express route', NOW(), NOW()),
(12, 29, 40, 'BK012', CURRENT_DATE + INTERVAL '22 days', CURRENT_DATE + INTERVAL '22 days' + INTERVAL '12 hours', 'Valeria Conte', 'CC34567890', '+39 357 456-7890', 16.00, 'pending', 'pending', 'bank_transfer', 'Awaiting confirmation', NOW(), NOW()),
(13, 30, 45, 'BK013', CURRENT_DATE + INTERVAL '9 days', CURRENT_DATE + INTERVAL '9 days' + INTERVAL '15 hours', 'Riccardo Gatti', 'CG45678901', '+39 358 789-0123', 14.00, 'paid', 'confirmed', 'credit_card', 'Evening service', NOW(), NOW()),
(14, 31, 50, 'BK014', CURRENT_DATE + INTERVAL '25 days', CURRENT_DATE + INTERVAL '25 days' + INTERVAL '8 hours', 'Camilla Ferraro', 'CF56789012', '+39 359 012-3456', 10.00, 'paid', 'confirmed', 'debit_card', 'Morning bus', NOW(), NOW()),
(15, 32, 55, 'BK015', CURRENT_DATE + INTERVAL '16 days', CURRENT_DATE + INTERVAL '16 days' + INTERVAL '13 hours', 'Daniele Villa', 'CV67890123', '+39 360 345-6789', 9.00, 'pending', 'pending', 'cash', 'Pay at terminal', NOW(), NOW()),
(16, 33, 60, 'BK016', CURRENT_DATE + INTERVAL '19 days', CURRENT_DATE + INTERVAL '19 days' + INTERVAL '7 hours', 'Ilaria Santoro', 'CS78901234', '+39 361 678-9012', 8.00, 'paid', 'confirmed', 'credit_card', 'Early service', NOW(), NOW()),
(17, 34, 65, 'BK017', CURRENT_DATE + INTERVAL '11 days', CURRENT_DATE + INTERVAL '11 days' + INTERVAL '15 hours', 'Tommaso Lombardo', 'CL89012345', '+39 362 901-2345', 20.00, 'paid', 'confirmed', 'paypal', 'Night bus', NOW(), NOW()),
(18, 35, 70, 'BK018', CURRENT_DATE + INTERVAL '28 days', CURRENT_DATE + INTERVAL '28 days' + INTERVAL '6 hours 30 minutes', 'Rebecca Russo', 'CR90123456', '+39 363 234-5678', 18.00, 'pending', 'pending', 'bank_transfer', 'Business trip', NOW(), NOW());

-- Additional booking_seats
INSERT INTO booking_seats (booking_id, seat_id, created_at) VALUES
(9, 1, NOW()), -- Pietro gets seat from existing
(10, 2, NOW()),
(11, 3, NOW()),
(12, 4, NOW()),
(13, 5, NOW()),
(14, 6, NOW()),
(15, 7, NOW()),
(16, 8, NOW()),
(17, 9, NOW()),
(18, 10, NOW());

-- Additional payments
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_id, created_at, updated_at) VALUES
(9, 9.00, 'credit_card', 'completed', 'txn_009', NOW(), NOW()),
(10, 22.00, 'debit_card', 'completed', 'txn_010', NOW(), NOW()),
(11, 12.00, 'paypal', 'completed', 'txn_011', NOW(), NOW()),
(12, 16.00, 'bank_transfer', 'pending', 'txn_012', NOW(), NOW()),
(13, 14.00, 'credit_card', 'completed', 'txn_013', NOW(), NOW()),
(14, 10.00, 'debit_card', 'completed', 'txn_014', NOW(), NOW()),
(15, 9.00, 'cash', 'pending', 'txn_015', NOW(), NOW()),
(16, 8.00, 'credit_card', 'completed', 'txn_016', NOW(), NOW()),
(17, 20.00, 'paypal', 'completed', 'txn_017', NOW(), NOW()),
(18, 18.00, 'bank_transfer', 'pending', 'txn_018', NOW(), NOW());
-- Reset sequence for companies table
ALTER SEQUENCE companies_id_seq RESTART WITH 11;
-- Reset sequence for vehicles table
ALTER SEQUENCE vehicles_id_seq RESTART WITH 21;
-- Reset sequence for routes table
ALTER SEQUENCE routes_id_seq RESTART WITH 62;
-- Reset sequence for users table
ALTER SEQUENCE users_id_seq RESTART WITH 35;
-- Reset sequence for schedules table
ALTER SEQUENCE schedules_id_seq RESTART WITH 69;
-- Reset sequence for bookings table
ALTER SEQUENCE bookings_id_seq RESTART WITH 19;