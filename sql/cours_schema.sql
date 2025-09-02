-- TP SQL – Plateforme de cours en ligne
-- Script de init (DDL + INSERTS)
DROP DATABASE IF EXISTS cours;

CREATE DATABASE cours;

USE cours;

/* ---------- Utilisateurs ---------- */
CREATE TABLE
    users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

/* ---------- Cours ---------- */
CREATE TABLE
    courses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(200) NOT NULL,
        category VARCHAR(50) NOT NULL,
        price DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
        CONSTRAINT chk_courses_price CHECK (price >= 0)
    );

/* ---------- Inscriptions ---------- */
CREATE TABLE
    enrollments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        course_id INT NOT NULL,
        enrolled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        completed BOOLEAN NOT NULL DEFAULT FALSE,
        completed_at DATETIME NULL,
        CONSTRAINT fk_enr_user FOREIGN KEY (user_id) REFERENCES users (id),
        CONSTRAINT fk_enr_course FOREIGN KEY (course_id) REFERENCES courses (id),
        -- Règle simple : si "completed" = 1 alors completed_at non NULL et >= enrolled_at
        CONSTRAINT chk_completion CHECK (
            (
                completed = 0
                AND completed_at IS NULL
            )
            OR (
                completed = 1
                AND completed_at IS NOT NULL
                AND completed_at >= enrolled_at
            )
        )
    );

/* ---------- Avis ---------- */
CREATE TABLE
    reviews (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        course_id INT NOT NULL,
        rating TINYINT NOT NULL, -- 1 à 5
        comment TEXT NULL,
        CONSTRAINT fk_rev_user FOREIGN KEY (user_id) REFERENCES users (id),
        CONSTRAINT fk_rev_course FOREIGN KEY (course_id) REFERENCES courses (id),
        CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
    );