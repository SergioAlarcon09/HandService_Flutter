import pool from "../db.js";

// Obtener todos los niveles educativos
export const getNivelesEducativos = async (req, res) => {
    try {
        const { rows } = await pool.query("SELECT * FROM niveles_educativos WHERE estado = true");
        res.json(rows);
    } catch (error) {
        return res.status(500).json({
            message: "Error interno del servidor",
        });
    }
};

// Obtener un nivel educativo por ID
export const getNivelEducativo = async (req, res) => {
    try {
        const { rows } = await pool.query("SELECT * FROM niveles_educativos WHERE id = $1 AND estado = true", [
            req.params.id,
        ]);
        if (rows.length === 0)
            return res.status(404).json({
                message: "Nivel educativo no encontrado",
            });
        res.json(rows[0]);
    } catch (error) {
        return res.status(500).json({
            message: "Error interno del servidor",
        });
    }
};

// Crear un nuevo nivel educativo
export const createNivelEducativo = async (req, res) => {
    const { nombre, descripcion } = req.body;
    try {
        const { rows } = await pool.query(
            "INSERT INTO niveles_educativos (nombre, descripcion) VALUES ($1, $2) RETURNING *",
            [nombre, descripcion]
        );
        res.status(201).json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({
            message: "Error al crear el nivel educativo",
        });
    }
};

// Actualizar un nivel educativo
export const updateNivelEducativo = async (req, res) => {
    const { id } = req.params;
    const { nombre, descripcion, estado } = req.body;

    try {
        const { rowCount } = await pool.query(
            `UPDATE niveles_educativos SET 
        nombre = COALESCE($1, nombre), 
        descripcion = COALESCE($2, descripcion), 
        estado = COALESCE($3, estado) 
      WHERE id = $4`,
            [nombre, descripcion, estado, id]
        );

        if (rowCount === 0)
            return res.status(404).json({
                message: "Nivel educativo no encontrado",
            });

        const { rows } = await pool.query("SELECT * FROM niveles_educativos WHERE id = $1", [id]);
        res.json(rows[0]);
    } catch (error) {
        return res.status(500).json({
            message: "Error al actualizar el nivel educativo",
        });
    }
};

// Eliminar un nivel educativo
export const deleteNivelEducativo = async (req, res) => {
    try {
        const { rowCount } = await pool.query(
            "DELETE FROM niveles_educativos WHERE id = $1",
            [req.params.id]
        );

        if (rowCount === 0)
            return res.status(404).json({
                message: "Nivel educativo no encontrado",
            });

        res.sendStatus(204);
    } catch (error) {
        return res.status(500).json({
            message: "Error al eliminar el nivel educativo",
        });
    }
};