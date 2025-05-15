import { Router } from "express";
import { registerUser, loginUser, getUserProfile } from "../controllers/users.controllers.js";
import { authenticateToken } from "../middlewares/auth.middleware.js";

const router = Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/profile", authenticateToken, getUserProfile);

export default router;