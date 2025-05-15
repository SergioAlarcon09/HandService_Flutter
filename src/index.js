import app from "./app.js";

let PORT = 3001;
app.listen(PORT);
console.log("Servidor ejecutando en el puerto", PORT);


//! Cambios cuando se implementen las variables de entorno
/*import app from "./app.js";
import dotenv from "dotenv";

// Cargar variables de entorno
dotenv.config();

const PORT = process.env.PORT || 3001;

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor ejecutándose en el puerto ${PORT}`);
  console.log(`Entorno: ${process.env.NODE_ENV || 'development'}`);
});

Instalar dependencias con: //! npm install express pg cors dotenv bcrypt jsonwebtoken
*/