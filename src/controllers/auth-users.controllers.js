import pool from "../db.js";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import dotenv from "dotenv";
dotenv.config();

// Obtener todos los usuarios (solo para administradores)
export const getAllUsers = async (_req, res) => {
    try {
        const { rows } = await pool.query(
            "SELECT id, nombre, apellido, num_documento, email, telefono, sexo FROM usuarios"
        );
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al obtener los usuarios" });
    }
};

// Obtener un usuario por ID
export const getUserById = async (req, res) => {
    try {
        const { rows } = await pool.query(
            "SELECT id, nombre, apellido, num_documento, email, telefono, sexo FROM usuarios WHERE id = $1",
            [req.params.id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al obtener el usuario" });
    }
};

// Registrar un nuevo usuario (ya existente)
export const registerUser = async (req, res) => {
    const { nombre, apellido, num_documento, email, password, telefono, sexo } = req.body;

    try {
        // Verificar si el usuario ya existe
        const userExists = await pool.query(
            "SELECT * FROM usuarios WHERE email = $1 OR num_documento = $2",
            [email, num_documento]
        );

        if (userExists.rows.length > 0) {
            return res.status(400).json({ message: "El usuario ya existe" });
        }

        // Encriptar contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        const { rows } = await pool.query(
            "INSERT INTO usuarios (nombre, apellido, num_documento, email, password, telefono, sexo) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id, nombre, apellido, email, telefono",
            [nombre, apellido, num_documento, email, hashedPassword, telefono, sexo]
        );

        res.status(201).json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al registrar el usuario" });
    }
};

// Actualizar un usuario
export const updateUser = async (req, res) => {
    const { id } = req.params;
    const { nombre, apellido, num_documento, email, telefono, sexo } = req.body;

    try {
        // Verificar si el usuario existe
        const userExists = await pool.query(
            "SELECT * FROM usuarios WHERE id = $1",
            [id]
        );

        if (userExists.rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Actualizar el usuario
        const { rows } = await pool.query(
            `UPDATE usuarios SET 
        nombre = COALESCE($1, nombre), 
        apellido = COALESCE($2, apellido), 
        num_documento = COALESCE($3, num_documento), 
        email = COALESCE($4, email), 
        telefono = COALESCE($5, telefono), 
        sexo = COALESCE($6, sexo) 
        WHERE id = $7 
        RETURNING id, nombre, apellido, email, telefono`,
            [nombre, apellido, num_documento, email, telefono, sexo, id]
        );

        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al actualizar el usuario" });
    }
};

// Eliminar un usuario (eliminación lógica)
export const deleteUser = async (req, res) => {
    try {
        // Verificar si el usuario existe
        const userExists = await pool.query(
            "SELECT * FROM usuarios WHERE id = $1",
            [req.params.id]
        );

        if (userExists.rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Eliminar el usuario (físicamente en este caso)
        await pool.query(
            "DELETE FROM usuarios WHERE id = $1",
            [req.params.id]
        );

        res.sendStatus(204);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al eliminar el usuario" });
    }
};

// Iniciar sesión (ya existente)
export const loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        // Verificar que JWT_SECRET esté configurado
        if (!process.env.JWT_SECRET) {
            throw new Error('JWT_SECRET no está configurado en las variables de entorno');
        }

        const { rows } = await pool.query(
            "SELECT * FROM usuarios WHERE email = $1",
            [email]
        );

        if (rows.length === 0) {
            return res.status(401).json({ 
                message: "Credenciales inválidas",
                details: "Usuario no encontrado" 
            });
        }

        const user = rows[0];
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (!passwordMatch) {
            return res.status(401).json({ 
                message: "Credenciales inválidas",
                details: "Contraseña incorrecta" 
            });
        }

        const token = jwt.sign(
            { userId: user.id, email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );

        res.json({
            token,
            user: {
                id: user.id,
                nombre: user.nombre,
                apellido: user.apellido,
                email: user.email
            }
        });
    } catch (error) {
        console.error('Error en login:', error.message);
        res.status(500).json({ 
            message: "Error al iniciar sesión",
            error: error.message 
        });
    }
};

// Obtener información del usuario (perfil) (ya existente)
export const getUserProfile = async (req, res) => {
    try {
        const { rows } = await pool.query(
            "SELECT id, nombre, apellido, email, telefono FROM usuarios WHERE id = $1",
            [req.userId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al obtener el perfil" });
    }
};