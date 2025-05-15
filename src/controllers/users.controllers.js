import pool from "../db.js";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// Registrar un nuevo usuario
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

// Iniciar sesión
export const loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        const { rows } = await pool.query(
            "SELECT * FROM usuarios WHERE email = $1",
            [email]
        );

        if (rows.length === 0) {
            return res.status(401).json({ message: "Credenciales inválidas" });
        }

        const user = rows[0];
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (!passwordMatch) {
            return res.status(401).json({ message: "Credenciales inválidas" });
        }

        // Crear token JWT
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
        console.error(error);
        res.status(500).json({ message: "Error al iniciar sesión" });
    }
};

// Obtener información del usuario
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