import pool from "../db.js";

// Obtener todos los clientes
export const getAllClientes = async (req, res) => {
    try {
        const { rows } = await pool.query(`
    SELECT c.id, c.longitud, c.latitud, 
    u.id as usuario_id, u.nombre, u.apellido, u.email, u.telefono
    FROM clientes c
    JOIN usuarios u ON c.usuario_id = u.id
    `);
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al obtener los clientes" });
    }
};

// Obtener un cliente por ID
export const getClienteById = async (req, res) => {
    try {
        const { rows } = await pool.query(`
        SELECT c.id, c.longitud, c.latitud, 
        u.id as usuario_id, u.nombre, u.apellido, u.email, u.telefono
        FROM clientes c
        JOIN usuarios u ON c.usuario_id = u.id
        WHERE c.id = $1
    `, [req.params.id]);

        if (rows.length === 0) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al obtener el cliente" });
    }
};

// Crear un nuevo cliente
export const createCliente = async (req, res) => {
    const { longitud, latitud, usuario_id } = req.body;

    try {
        // Verificar si el usuario existe
        const usuarioExists = await pool.query(
            "SELECT * FROM usuarios WHERE id = $1",
            [usuario_id]
        );

        if (usuarioExists.rows.length === 0) {
            return res.status(400).json({ message: "El usuario no existe" });
        }

        // Verificar si el usuario ya es cliente
        const clienteExists = await pool.query(
            "SELECT * FROM clientes WHERE usuario_id = $1",
            [usuario_id]
        );

        if (clienteExists.rows.length > 0) {
            return res.status(400).json({ message: "Este usuario ya es cliente" });
        }

        const { rows } = await pool.query(
            "INSERT INTO clientes (longitud, latitud, usuario_id) VALUES ($1, $2, $3) RETURNING *",
            [longitud, latitud, usuario_id]
        );

        res.status(201).json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al crear el cliente" });
    }
};

// Actualizar un cliente
export const updateCliente = async (req, res) => {
    const { id } = req.params;
    const { longitud, latitud } = req.body;

    try {
        const { rowCount } = await pool.query(
            "UPDATE clientes SET longitud = $1, latitud = $2 WHERE id = $3",
            [longitud, latitud, id]
        );

        if (rowCount === 0) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        const { rows } = await pool.query("SELECT * FROM clientes WHERE id = $1", [id]);
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al actualizar el cliente" });
    }
};

// Eliminar un cliente
export const deleteCliente = async (req, res) => {
    try {
        const { rowCount } = await pool.query(
            "DELETE FROM clientes WHERE id = $1",
            [req.params.id]
        );

        if (rowCount === 0) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        res.sendStatus(204);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al eliminar el cliente" });
    }
};