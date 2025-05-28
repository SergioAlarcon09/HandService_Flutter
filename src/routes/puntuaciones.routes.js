import { Router } from "express";
import {
    getPuntuaciones,
    getPuntuacion,
    createPuntuacion,
    updatePuntuacion,
    deletePuntuacion,
} from "../controllers/puntuaciones.controllers.js";

const router = Router();

router.get("/puntuaciones", getPuntuaciones);
router.get("/puntuaciones/:id", getPuntuacion);
router.post("/puntuaciones", createPuntuacion);
router.put("/puntuaciones/:id", updatePuntuacion);
router.delete("/puntuaciones/:id", deletePuntuacion);

export default router;