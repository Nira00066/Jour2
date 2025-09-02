CREATE DATABASE `cours_db`;
USE `cours_db`;

CREATE TABLE `users` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `courses` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category ENUM('DEV','Marketing','Photo') NOT NULL,
    price INT NOT NULL CHECK (price >= 5)
);

CREATE TABLE `enrollments` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE `reviews` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_review FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_course_review FOREIGN KEY (course_id) REFERENCES courses(id)
);
