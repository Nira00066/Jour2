import { faker } from "@faker-js/faker";
import { connectDB } from "./../facker/db.js";

async function seed() {
  const connection = await connectDB();

  // ************** USERS **************
  console.log("Insertion des utilisateurs...");
  const userIds = [];
  for (let i = 0; i < 20; i++) {
    const username = faker.internet.userName();
    const email = faker.internet.email();
    const password = faker.internet.password();

    const [result] = await connection.query(
      "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
      [username, email, password]
    );
    userIds.push(result.insertId);
  }

  // ************** COURSES **************
  console.log("Insertion des cours...");
  const courseIds = [];
  const numCourses = faker.number.int({ min: 10, max: 15 });
  const categories = ["DEV", "Marketing", "Photo"]; // correspond à l'ENUM de la table
  for (let i = 0; i < numCourses; i++) {
    const title = faker.company.catchPhrase();
    const price = faker.number.int({ min: 5, max: 200 });
    const category = categories[faker.number.int({ min: 0, max: categories.length - 1 })];

    const [result] = await connection.query(
      "INSERT INTO courses (title, category, price) VALUES (?, ?, ?)",
      [title, category, price]
    );
    courseIds.push(result.insertId);
  }

  // ************** ENROLLMENTS **************
  console.log("Insertion des inscriptions...");
  for (let i = 0; i < 50; i++) {
    const userId = userIds[faker.number.int({ min: 0, max: userIds.length - 1 })];
    const courseId = courseIds[faker.number.int({ min: 0, max: courseIds.length - 1 })];
    const completed = faker.datatype.boolean();
    const completedAt = completed ? faker.date.recent() : null;

    await connection.query(
      "INSERT INTO enrollments (user_id, course_id, completed, completed_at) VALUES (?, ?, ?, ?)",
      [userId, courseId, completed, completedAt]
    );
  }

  // ************** REVIEWS **************
  console.log("Insertion des avis...");
  const numReviews = faker.number.int({ min: 10, max: 20 });
  for (let i = 0; i < numReviews; i++) {
    const userId = userIds[faker.number.int({ min: 0, max: userIds.length - 1 })];
    const courseId = courseIds[faker.number.int({ min: 0, max: courseIds.length - 1 })];
    const rating = faker.number.int({ min: 1, max: 5 });
    const comment = faker.lorem.sentence();

    await connection.query(
      "INSERT INTO reviews (user_id, course_id, rating, comment) VALUES (?, ?, ?, ?)",
      [userId, courseId, rating, comment]
    );
  }

  console.log("Données insérées !");
  await connection.end();
}

seed().catch((err) => {
  console.error("Erreur pendant le seed :", err);
});
