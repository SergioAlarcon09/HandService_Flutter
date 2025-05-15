import pool from "../db.js";

// Obtener todos los servicios
export const getServices = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM servicios WHERE estado = true");
    res.json(rows);
  } catch (error) {
    return res.status(500).json({
      message: "Error interno del servidor",
    });
  }
};

// Obtener un servicio por ID
export const getService = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM servicios WHERE id = $1 AND estado = true", [
      req.params.id,
    ]);
    if (rows.length === 0)
      return res.status(404).json({
        message: "Servicio no encontrado",
      });
    res.json(rows[0]);
  } catch (error) {
    return res.status(500).json({
      message: "Error interno del servidor",
    });
  }
};

// Crear un nuevo servicio
export const createService = async (req, res) => {  
  const { nombre, descripcion, valor } = req.body;
  try {
    const { rows } = await pool.query(
      "INSERT INTO servicios (nombre, descripcion, valor) VALUES ($1, $2, $3) RETURNING *",
      [nombre, descripcion, valor]
    );
    res.status(201).json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Error al crear el servicio",
    });
  }
};

// Actualizar un servicio
export const updateService = async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion, valor, estado } = req.body;

  try {
    const { rowCount } = await pool.query(
      `UPDATE servicios SET 
        nombre = COALESCE($1, nombre), 
        descripcion = COALESCE($2, descripcion), 
        valor = COALESCE($3, valor), 
        estado = COALESCE($4, estado) 
      WHERE id = $5`,
      [nombre, descripcion, valor, estado, id]
    );

    if (rowCount === 0)
      return res.status(404).json({
        message: "Servicio no encontrado",
      });

    const { rows } = await pool.query("SELECT * FROM servicios WHERE id = $1", [id]);
    res.json(rows[0]);
  } catch (error) {
    return res.status(500).json({
      message: "Error al actualizar el servicio",
    });
  }
};

// Eliminar un servicio
export const deleteService = async (req, res) => {
  try {
    // En lugar de borrar, cambiamos el estado a false
    const { rowCount } = await pool.query(
      "DELETE FROM servicios WHERE id = $1",
      [req.params.id]
    );

    if (rowCount === 0)
      return res.status(404).json({
        message: "Servicio no encontrado",
      });

    res.sendStatus(204);
  } catch (error) {
    return res.status(500).json({
      message: "Error al eliminar el servicio",
    });
  }
};