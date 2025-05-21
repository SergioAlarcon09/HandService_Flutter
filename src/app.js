import express from "express";
import cors from "cors";
import servicesRouter from "./routes/services.routes.js";
import usersRouter from "./routes/auth-users.routes.js";
import nivelesEducativosRouter from "./routes/niveles_educativos.routes.js"; 
//import solicitudesRouter from "./routes/solicitudes.routes.js"; // Futura implementación
//import prestadoresRouter from "./routes/prestadores.routes.js"; // Futura implementación

const app = express();
app.use(cors());
app.use(express.json());

// Rutas 
app.use("/api", servicesRouter);    //Ruta de servicios
app.use("/api/auth", usersRouter);   //Ruta de autenticación de usuario
app.use("/api", nivelesEducativosRouter);   //Ruta de niveles educativos
// app.use("/api/solicitudes", solicitudesRouter); // Descomentar cuando esté implementado
// app.use("/api/prestadores", prestadoresRouter); // Descomentar cuando esté implementado

// Manejo de errores 404
app.use((req, res, next) => {
  res.status(404).json({
    message: "Endpoint no encontrado",
  });
});

// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    message: "Error interno del servidor",
  });
});

export default app;