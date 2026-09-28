-- ==================================================
-- RIDESHARELITE - MYSQL WORKBENCH SETUP SCRIPT
-- ==================================================
-- Open this file in MySQL Workbench (File -> Open SQL Script...)
-- and click the Lightning Bolt (⚡) icon to execute!

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS ridesharelite;
USE ridesharelite;

-- 2. Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL
);

-- 3. Create ride_offers table
CREATE TABLE IF NOT EXISTS ride_offers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    driver_id BIGINT NOT NULL,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    departure_time DATETIME NOT NULL,
    available_seats INT NOT NULL,
    CONSTRAINT fk_ride_driver FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Create ride_requests table
CREATE TABLE IF NOT EXISTS ride_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rider_id BIGINT NOT NULL,
    ride_id BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_request_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_request_ride FOREIGN KEY (ride_id) REFERENCES ride_offers(id) ON DELETE CASCADE
);

-- 5. Insert Sample College/Office Carpool Data
INSERT INTO users (name, email, phone) VALUES 
('Arun', 'arun@gmail.com', '9876543210'),
('Bala', 'bala@gmail.com', '9876543211'),
('Chitra', 'chitra@gmail.com', '9876543212')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO ride_offers (driver_id, origin, destination, departure_time, available_seats) VALUES
(1, 'Thanjavur', 'College', '2026-09-29 08:30:00', 3),
(2, 'Trichy', 'College Main Campus', '2026-09-29 09:00:00', 2);

INSERT INTO ride_requests (rider_id, ride_id, status) VALUES
(2, 1, 'PENDING');

-- 6. Quick Verification Queries
SELECT * FROM users;
SELECT * FROM ride_offers;
SELECT * FROM ride_requests;
