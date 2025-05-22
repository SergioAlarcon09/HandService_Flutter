import pool from "../db.js";

// Obtener todas las puntuaciones
export const getPuntuaciones = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM puntuaciones");
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener las puntuaciones" });
  }
};

// Obtener una puntuación por ID
export const getPuntuacion = async (req, res) => {
  try {
    const { rows } = await pool.query(
      "SELECT * FROM puntuaciones WHERE id = $1",
      [req.params.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ message: "Puntuación no encontrada" });
    }
    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener la puntuación" });
  }
};

// Crear una nueva puntuación
export const createPuntuacion = async (req, res) => {
  const { puntuacion, solicitud_servicio_id, descripcion, evidencia } = req.body;

  try {
    const { rows } = await pool.query(
      `INSERT INTO puntuaciones (puntuacion, solicitud_servicio_id, descripcion, evidencia)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [puntuacion, solicitud_servicio_id, descripcion, evidencia]
    );
    res.status(201).json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al crear la puntuación" });
  }
};

// Actualizar una puntuación
export const updatePuntuacion = async (req, res) => {
  const { id } = req.params;
  const { puntuacion, solicitud_servicio_id, descripcion, evidencia } = req.body;

  try {
    const { rowCount } = await pool.query(
      `UPDATE puntuaciones SET 
         puntuacion = COALESCE($1, puntuacion), 
         solicitud_servicio_id = COALESCE($2, solicitud_servicio_id), 
         descripcion = COALESCE($3, descripcion), 
         evidencia = COALESCE($4, evidencia) 
       WHERE id = $5`,
      [puntuacion, solicitud_servicio_id, descripcion, evidencia, id]
    );

    if (rowCount === 0)
      return res.status(404).json({ message: "Puntuación no encontrada" });

    const { rows } = await pool.query("SELECT * FROM puntuaciones WHERE id = $1", [id]);
    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al actualizar la puntuación" });
  }
};

// Eliminar una puntuación
export const deletePuntuacion = async (req, res) => {
  try {
    const { rowCount } = await pool.query(
      "DELETE FROM puntuaciones WHERE id = $1",
      [req.params.id]
    );

    if (rowCount === 0)
      return res.status(404).json({ message: "Puntuación no encontrada" });

    res.sendStatus(204);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al eliminar la puntuación" });
  }
};
