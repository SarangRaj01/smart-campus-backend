-- 1. CREATE DATABASE
DROP DATABASE IF EXISTS smart_campus_db;
CREATE DATABASE smart_campus_db;
USE smart_campus_db;

-- 2. USERS TABLE
CREATE TABLE USERS (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    reg_emp_no VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role ENUM('STUDENT', 'FACULTY', 'SECURITY', 'ADMIN') NOT NULL,
    department VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. CATEGORIES TABLE
CREATE TABLE CATEGORIES (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    subcategory_name VARCHAR(50) NOT NULL,
    UNIQUE(category_name, subcategory_name)
);

-- 4. LOCATIONS TABLE
CREATE TABLE LOCATIONS (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    campus_zone VARCHAR(50) NOT NULL,
    building_name VARCHAR(100) NOT NULL,
    specific_area VARCHAR(100) NOT NULL,
    security_desk_contact VARCHAR(15)
);

-- 5. LOST_ITEMS TABLE
CREATE TABLE LOST_ITEMS (
    lost_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    location_id INT NOT NULL,
    brand VARCHAR(50),
    primary_color VARCHAR(30) NOT NULL,
    date_lost DATE NOT NULL,
    time_lost TIME,
    serial_number VARCHAR(100),
    description TEXT,
    status ENUM('ACTIVE', 'MATCHED', 'CLAIMED', 'CLOSED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id),
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
);

-- 6. FOUND_ITEMS TABLE
CREATE TABLE FOUND_ITEMS (
    found_id INT PRIMARY KEY AUTO_INCREMENT,
    finder_user_id INT NOT NULL,
    category_id INT NOT NULL,
    location_id INT NOT NULL,
    brand VARCHAR(50),
    primary_color VARCHAR(30) NOT NULL,
    date_found DATE NOT NULL,
    storage_location VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100),
    description TEXT,
    status ENUM('UNCLAIMED', 'PENDING_VERIFICATION', 'CLAIMED', 'EXPIRED') DEFAULT 'UNCLAIMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (finder_user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id),
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
);

-- 7. MATCH_RECORDS TABLE
CREATE TABLE MATCH_RECORDS (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    lost_id INT NOT NULL,
    found_id INT NOT NULL,
    confidence_score DECIMAL(5,2) NOT NULL,
    match_status ENUM('GENERATED', 'NOTIFIED', 'DISCARDED') DEFAULT 'GENERATED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lost_id) REFERENCES LOST_ITEMS(lost_id) ON DELETE CASCADE,
    FOREIGN KEY (found_id) REFERENCES FOUND_ITEMS(found_id) ON DELETE CASCADE
);

-- 8. CLAIM_VERIFICATIONS TABLE
CREATE TABLE CLAIM_VERIFICATIONS (
    claim_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT NOT NULL UNIQUE,
    claimant_user_id INT NOT NULL,
    proof_description TEXT NOT NULL,
    proof_document_url VARCHAR(255),
    verified_by_security_id INT,
    verification_status ENUM('PENDING', 'VERIFIED', 'REJECTED', 'HANDOVER_COMPLETE') DEFAULT 'PENDING',
    verification_date TIMESTAMP NULL,
    remarks TEXT,
    FOREIGN KEY (match_id) REFERENCES MATCH_RECORDS(match_id) ON DELETE CASCADE,
    FOREIGN KEY (claimant_user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (verified_by_security_id) REFERENCES USERS(user_id)
);

-- 9. SYSTEM_AUDIT_LOGS TABLE
CREATE TABLE SYSTEM_AUDIT_LOGS (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    entity_type ENUM('LOST', 'FOUND', 'MATCH', 'CLAIM') NOT NULL,
    entity_id INT NOT NULL,
    action_performed VARCHAR(100) NOT NULL,
    performed_by INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (performed_by) REFERENCES USERS(user_id)
);
USE smart_campus_db;

-- Seed Categories
INSERT INTO CATEGORIES (category_name, subcategory_name) VALUES
('Electronics', 'Laptop'),
('Electronics', 'Earphones'),
('Personal Belongings', 'Wallet'),
('Documents', 'ID Card');

-- Seed Locations
INSERT INTO LOCATIONS (campus_zone, building_name, specific_area, security_desk_contact) VALUES
('Academic Zone', 'Central Library', '2nd Floor Reading Hall', '044-2211001'),
('Academic Zone', 'Technology Tower', 'Ground Floor Atrium', '044-2211002'),
('Student Zone', 'Food Court', 'Outdoor Seating Area', '044-2211003');

-- Seed Users
INSERT INTO USERS (reg_emp_no, full_name, email, phone, role, department) VALUES
('21BCE0001', 'Rahul Sharma', 'rahul.s@campus.edu', '9876543210', 'STUDENT', 'CSE'),
('21BCE0002', 'Priya Patel', 'priya.p@campus.edu', '9876543211', 'STUDENT', 'ECE'),
('SEC1001', 'Guard Suresh', 'suresh.sec@campus.edu', '9876543212', 'SECURITY', 'Campus Security'),
('ADM1001', 'Admin Vikram', 'vikram.adm@campus.edu', '9876543213', 'ADMIN', 'IT Operations');

-- Seed Lost Item
INSERT INTO LOST_ITEMS (user_id, category_id, location_id, brand, primary_color, date_lost, time_lost, serial_number, description) VALUES
(1, 1, 1, 'Lenovo', 'Black', '2026-10-01', '14:30:00', 'LNV-99213', 'Black ThinkPad with sticker on lid');

-- Seed Found Item
INSERT INTO FOUND_ITEMS (finder_user_id, category_id, location_id, brand, primary_color, date_found, storage_location, serial_number, description) VALUES
(2, 1, 1, 'Lenovo', 'Black', '2026-10-01', 'Library Security Desk', 'LNV-99213', 'Black Lenovo laptop found on table 4');
