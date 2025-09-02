import { connectDB } from "./../facker/db";

async function reset() {
  const connection = await connectDB();
  
  console.log("🔄 Réinitialisation de la base de données...");

  await connection.query("SET FOREIGN_KEY_CHECKS = 0");

  await connection.query("TRUNCATE TABLE reviews");
  await connection.query("TRUNCATE TABLE enrollments");
  await connection.query("TRUNCATE TABLE courses");
  await connection.query("TRUNCATE TABLE categories");
  await connection.query("TRUNCATE TABLE users");

  // Réactive les contraintes
  await connection.query("SET FOREIGN_KEY_CHECKS = 1");

  console.log(" Base de données vide !");
  await connection.end();
}

reset().catch((err) => {
  console.error("Erreur pendant le reset :", err);
});
