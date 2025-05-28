import express from 'express';
import pool from "../db.js";
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const router = express.Router();
const JWT_SECRET = 'your_jwt_secret';

/*//! Registro de usuarios
router.post('/auth/register', async (req, res) => {
    const {name, email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    try {
        await pool.execute('INSERT INTO usuarios (nombre, email, password) VALUES (?, ?, ?)',
            [name, email, hashedPassword]);
            res.status(201).send('Usuario registrado');
    } catch (error) {
        res.status(500).send('Error al registrar usuario');
    }
});
*/
export const registerUser = async (req, res) => {
    const { nombre, apellido, num_documento, email, password, telefono, sexo } = req.body;

    try {
        const userExists = await pool.query(
            "SELECT * FROM usuarios WHERE email = $1 OR num_documento = $2",
            [email, num_documento]
        );

        if (userExists.rows.length > 0) {
            return res.status(400).json({ message: "El usuario ya existe" });
        }

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

//! Login de usuarios
/*router.post('/auth/login', async (req, res) => {
    const { email, password } = req.body;

    try{
        const [rows] = await pool.execute('SELECT * FROM usuarios WHERE email = ?', [email]);
        if (rows.lenght === 0){
            return res.status(401).send('Usuario no encontrado');
        }

        const user = rows[0];
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if(!isPasswordValid){
            return res.status(401).send('Contraseña inválida');
        }

        const token = jwt.sign({ id: user.id, username: user.name }, JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    }catch (error){
        res.status(500).send('Error al iniciar sesión');
    }
});

export default router;
*/
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

        const token = jwt.sign(
            { userId: user.id, email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );

        res.json({ token, user: { id: user.id, nombre: user.nombre, email: user.email } });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al iniciar sesión" });
    }
};

export const deleteUser = async (req, res) => {
    try {
        const { rowCount } = await pool.query(
            "DELETE FROM usuarios WHERE id = $1",
            [req.params.id]
        );

        if (rowCount === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.sendStatus(204);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error al eliminar el usuario" });
    }
};

export const getUserProfile = async (req, res) => {
    try {
        const { rows } = await pool.query(
            `SELECT id, nombre, apellido, email, telefono, sexo, num_documento 
            FROM usuarios 
            WHERE id = $1`,
            [req.userId] // Usamos el ID del token JWT
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error('Error en getUserProfile:', error);
        res.status(500).json({ 
            message: "Error al obtener el perfil",
            error: error.message 
        });
    }
};

export const getAllUsers = async (req, res) => {
    try {
        
        const { rows } = await pool.query(
            `SELECT id, nombre, apellido, email, telefono, sexo, num_documento 
            FROM usuarios 
            ORDER BY nombre ASC`
        );

        res.json(rows);
    } catch (error) {
        console.error('Error en getAllUsers:', error);
        res.status(500).json({ 
            message: "Error al obtener los usuarios",
            error: error.message 
        });
    }
};

export const getUserById = async (req, res) => {
    try {
        const { rows } = await pool.query(
            `SELECT id, nombre, apellido, email, telefono, sexo, num_documento 
            FROM usuarios 
            WHERE id = $1`,
            [req.params.id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error('Error en getUserById:', error);
        res.status(500).json({ 
            message: "Error al obtener el usuario",
            error: error.message 
        });
    }
};

export const updateUser = async (req, res) => {
    const { id } = req.params;
    const { nombre, apellido, email, telefono, sexo } = req.body;

    try {
        // Verificar que el usuario exista
        const userExists = await pool.query(
            "SELECT id FROM usuarios WHERE id = $1",
            [id]
        );

        if (userExists.rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Actualizar solo los campos proporcionados
        const { rows } = await pool.query(
            `UPDATE usuarios SET
                nombre = COALESCE($1, nombre),
                apellido = COALESCE($2, apellido),
                email = COALESCE($3, email),
                telefono = COALESCE($4, telefono),
                sexo = COALESCE($5, sexo)
                WHERE id = $6
                RETURNING id, nombre, apellido, email, telefono`,
            [nombre, apellido, email, telefono, sexo, id]
        );

        res.json(rows[0]);
    } catch (error) {
        console.error('Error en updateUser:', error);
        
        if (error.code === '23505') { // Violación de unique constraint
            return res.status(400).json({ 
                message: "El email ya está en uso por otro usuario" 
            });
        }

        res.status(500).json({ 
            message: "Error al actualizar el usuario",
            error: error.message 
        });
    }
};