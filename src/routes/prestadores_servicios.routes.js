import { Router } from "express";
import {
  getPrestadores,
  getPrestador,
  createPrestador,
  updatePrestador,
  deletePrestador,
} from "../controllers/prestadores_servicios.controllers.js";

const router = Router();

router.get("/prestadores-servicios", getPrestadores);
router.get("/prestadores-servicios/:id", getPrestador);
router.post("/prestadores-servicios", createPrestador);
router.patch("/prestadores-servicios/:id", updatePrestador);
router.delete("/prestadores-servicios/:id", deletePrestador);

export default router;
