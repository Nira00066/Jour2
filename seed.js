import mysql from "mysql2/promise";
import { faker } from "@faker-js/faker";
import dotenv from "dotenv";
dotenv.config();

const categories = ["Dev", "Marketing", "Photo", "Design", "Economy"];

async function seed() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  });
  console.log("Connected to MySQL");

  await connection.query(`CREATE DATABASE IF NOT EXISTS cours_en_ligne`);
  await connection.changeUser({ database: "cours_en_ligne" });

  // efface et recréé les tables
  await connection.query(
    `DROP TABLE IF EXISTS reviews, enrollments, courses, users`
  );

  await connection.query(`
    CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  await connection.query(`
    CREATE TABLE courses (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(100) NOT NULL,
      category ENUM('Dev', 'Marketing', 'Photo', 'Design', 'Economy') NOT NULL,
      price DECIMAL(6,2) NOT NULL
    )
  `);

  await connection.query(`
    CREATE TABLE enrollments (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      course_id INT NOT NULL,
      enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      completed BOOLEAN DEFAULT FALSE,
      completed_at DATETIME,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
    )
  `);

  await connection.query(`
    CREATE TABLE reviews (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      course_id INT NOT NULL,
      rating TINYINT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
    )
  `);

  // Insert users
  for (let i = 0; i < 20; i++) {
    await connection.query(`INSERT INTO users (name, email) VALUES (?, ?)`, [
      faker.person.fullName(),
      faker.internet.email(),
    ]);
  }

  // Insert courses
  for (let i = 0; i < 12; i++) {
    await connection.query(
      `INSERT INTO courses (title, category, price) VALUES (?, ?, ?)`,
      [
        faker.lorem.words({ min: 2, max: 4 }),
        faker.helpers.arrayElement(categories),
        faker.number.float({ min: 10, max: 100, precision: 0.01 }),
      ]
    );
  }

  // Insert enrollments
  for (let i = 0; i < 50; i++) {
    const userId = faker.number.int({ min: 1, max: 20 });
    const courseId = faker.number.int({ min: 1, max: 12 });
    const enrolledAt = faker.date.past({ years: 1 });
    const completed = faker.datatype.boolean();
    const completedAt = completed
      ? faker.date.between({ from: enrolledAt, to: new Date() })
      : null;

    await connection.query(
      `INSERT INTO enrollments (user_id, course_id, enrolled_at, completed, completed_at)
       VALUES (?, ?, ?, ?, ?)`,
      [userId, courseId, enrolledAt, completed, completedAt]
    );
  }

  // Insert reviews
  for (let i = 0; i < 15; i++) {
    await connection.query(
      `INSERT INTO reviews (user_id, course_id, rating)
       VALUES (?, ?, ?)`,
      [
        faker.number.int({ min: 1, max: 20 }),
        faker.number.int({ min: 1, max: 12 }),
        faker.number.int({ min: 1, max: 5 }),
      ]
    );
  }

  console.log("Données insérées avec succès");
  await connection.end();
}

seed().catch((err) => console.error("Erreur :", err));
