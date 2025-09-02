import mysql from "mysql2/promise";

// Crée une connexion réutilisable
export async function connectDB() {
  return mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "0000", 
    database: "cours_db",
  });
}
