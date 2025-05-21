import pg from "pg";
import dotenv from "dotenv";

// Cargar variables de entorno
dotenv.config();

const pool = new pg.Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
});

// Manejo de eventos de conexión
pool.on("connect", () => {
  console.log("Conexión establecida con la base de datos PostgreSQL");
});

pool.on("error", (err) => {
  console.error("Error inesperado en el cliente de PostgreSQL:", err);
  process.exit(-1);
});

// Exportar el pool de conexiones
export default pool;