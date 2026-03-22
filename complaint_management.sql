CREATE DATABASE IF NOT EXISTS `complaint_management`;
USE `complaint_management`;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Complaints Table
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('Service', 'Product', 'Billing', 'Technical', 'Other') DEFAULT 'Other',
    status ENUM('Pending', 'In Progress', 'Resolved') DEFAULT 'Pending',
    reply TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert a default Admin User (Password: admin123)
-- Using PHP password_hash for 'admin123': $2y$10$tZ2.QZ...
INSERT INTO users (name, email, password, role) 
VALUES ('System Admin', 'admin@careconnect.com', '$2y$10$wOqZ0o3Uj5q1p4y2aHb5X.yM9D0yT24H0R5yC8E0W7Z8E0X2H4qLq', 'admin');
