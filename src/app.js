import express from "express";
import cors from "cors";
import servicesRouter from "./routes/services.routes.js";
import usersRouter from "./routes/auth-users.routes.js";
import nivelesEducativosRouter from "./routes/niveles_educativos.routes.js"; 
import clientesRouter from "./routes/clientes.routes.js";
import solicitudesRouter from "./routes/solicitudes_servicios.routes.js";
import prestadoresRouter from "./routes/prestadores_servicios.routes.js"; 
import puntuacionesRouter from "./routes/puntuaciones.routes.js";

const app = express();
app.use(cors());
app.use(express.json());

// Rutas 
app.use("/api", servicesRouter);   
app.use("/api/auth", usersRouter);  
app.use("/api", nivelesEducativosRouter);
app.use("/api", clientesRouter);    
app.use("/api", solicitudesRouter); 
app.use("/api", prestadoresRouter); 
app.use("/api", puntuacionesRouter);

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