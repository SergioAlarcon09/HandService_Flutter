import { Router } from "express";
import {
  getServices,
  createService,
  updateService,
  deleteService,
  getService,
} from "../controllers/services.controllers.js";

const router = Router();

router.get("/services", getServices);
router.get("/service/:id", getService);
router.post("/services", createService);
router.patch("/service/:id", updateService);
router.delete("/service/:id", deleteService);

export default router;