import { Router } from "express";
import {
  getSolicitudesServicios,
  getSolicitudServicio,
  createSolicitudServicio,
  updateSolicitudServicio,
  deleteSolicitudServicio,
} from "../controllers/solicitudes_servicios.controllers.js";

const router = Router();

router.get("/solicitudes-servicios", getSolicitudesServicios);
router.get("/solicitudes-servicios/:id", getSolicitudServicio);
router.post("/solicitudes-servicios", createSolicitudServicio);
router.patch("/solicitudes-servicios/:id", updateSolicitudServicio);
router.delete("/solicitudes-servicios/:id", deleteSolicitudServicio);

export default router;
