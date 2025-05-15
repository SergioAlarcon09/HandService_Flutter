import pg from "pg";
//import dotenv from "dotenv";

// Cargar variables de entorno
//dotenv.config();

//const { Pool } = pg;

// Configuración de la conexión a la base de datos
const pool = new pg.Pool({
  user: /*process.env.DB_USER ||*/ "postgres",
  host: /*process.env.DB_HOST ||*/ "localhost",
  password: /*process.env.DB_PASSWORD ||*/ "1034396905",
  database: /*process.env.DB_NAME ||*/ "HandService",
  port: /*process.env.DB_PORT ||*/ "5432",
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