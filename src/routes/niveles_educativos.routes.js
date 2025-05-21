import { Router } from "express";
import {
    getNivelesEducativos,
    createNivelEducativo,
    updateNivelEducativo,
    deleteNivelEducativo,
    getNivelEducativo,
} from "../controllers/niveles_educativos.controllers.js";

const router = Router();

router.get("/niveles-educativos", getNivelesEducativos);
router.get("/nivel-educativo/:id", getNivelEducativo);
router.post("/niveles-educativos", createNivelEducativo);
router.patch("/nivel-educativo/:id", updateNivelEducativo);
router.delete("/nivel-educativo/:id", deleteNivelEducativo);

export default router;