import pool from "../db.js";

// Obtener todos los prestadores
export const getPrestadores = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM prestadores_servicios");
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener prestadores" });
  }
};

// Obtener uno por ID
export const getPrestador = async (req, res) => {
  try {
    const { rows } = await pool.query("SELECT * FROM prestadores_servicios WHERE id = $1", [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ message: "Prestador no encontrado" });
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener prestador" });
  }
};

// Crear uno nuevo
export const createPrestador = async (req, res) => {
  const { profesion, nivel_educativo_id, usuario_id } = req.body;
  try {
    const { rows } = await pool.query(
      "INSERT INTO prestadores_servicios (profesion, nivel_educativo_id, usuario_id) VALUES ($1, $2, $3) RETURNING *",
      [profesion, nivel_educativo_id, usuario_id]
    );
    res.status(201).json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: "Error al crear prestador" });
  }
};

// Actualizar uno
export const updatePrestador = async (req, res) => {
  const { id } = req.params;
  const { profesion, nivel_educativo_id, usuario_id } = req.body;
  try {
    const { rowCount } = await pool.query(
      "UPDATE prestadores_servicios SET profesion = COALESCE($1, profesion), nivel_educativo_id = COALESCE($2, nivel_educativo_id), usuario_id = COALESCE($3, usuario_id) WHERE id = $4",
      [profesion, nivel_educativo_id, usuario_id, id]
    );
    if (rowCount === 0) return res.status(404).json({ message: "Prestador no encontrado" });

    const { rows } = await pool.query("SELECT * FROM prestadores_servicios WHERE id = $1", [id]);
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: "Error al actualizar prestador" });
  }
};

// Eliminar uno
export const deletePrestador = async (req, res) => {
  try {
    const { rowCount } = await pool.query("DELETE FROM prestadores_servicios WHERE id = $1", [req.params.id]);
    if (rowCount === 0) return res.status(404).json({ message: "Prestador no encontrado" });
    res.sendStatus(204);
  } catch (error) {
    res.status(500).json({ message: "Error al eliminar prestador" });
  }
};
