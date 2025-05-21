import { Router } from "express";
import { 
    registerUser, 
    loginUser, 
    getUserProfile,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser
} from "../controllers/auth-users.controllers.js";
import { authenticateToken } from "../middlewares/auth.middleware.js";

const router = Router();

// Rutas públicas
router.post("/register", registerUser);
router.post("/login", loginUser);

// Rutas protegidas por autenticación
router.get("/profile", authenticateToken, getUserProfile);

// Rutas para administración de usuarios
router.get("/users", authenticateToken, getAllUsers);
router.get("/users/:id", authenticateToken, getUserById);
router.patch("/users/:id", authenticateToken, updateUser);
router.delete("/users/:id", authenticateToken, deleteUser);

export default router;