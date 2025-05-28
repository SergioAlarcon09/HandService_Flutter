import { Router } from "express";
import { 
    registerUser, 
    loginUser, 
    getUserProfile,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser
} from "../controllers/auth.js";

const router = Router();

// Rutas públicas
router.post("/register", registerUser);
router.post("/login", loginUser);

// Rutas protegidas por autenticación
router.get("/profile", getUserProfile);

// Rutas para administración de usuarios
router.get("/users", getAllUsers);
router.get("/users/:id", getUserById);
router.patch("/users/:id", updateUser);
router.delete("/users/:id", deleteUser);

export default router;