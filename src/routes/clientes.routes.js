import { Router } from "express";
import {
    getAllClientes,
    getClienteById,
    createCliente,
    updateCliente,
    deleteCliente
} from "../controllers/clientes.controllers.js";
import { authenticateToken } from "../middlewares/auth.middleware.js";

const router = Router();

router.get("/clientes", authenticateToken, getAllClientes);
router.get("/clientes/:id", authenticateToken, getClienteById);
router.post("/clientes", authenticateToken, createCliente);
router.patch("/clientes/:id", authenticateToken, updateCliente);
router.delete("/clientes/:id", authenticateToken, deleteCliente);

export default router;