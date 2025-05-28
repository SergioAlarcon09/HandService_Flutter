import { Router } from "express";
import {
    getAllClientes,
    getClienteById,
    createCliente,
    updateCliente,
    deleteCliente
} from "../controllers/clientes.controllers.js";

const router = Router();

router.get("/clientes", getAllClientes);
router.get("/clientes/:id",getClienteById);
router.post("/clientes", createCliente);
router.patch("/clientes/:id", updateCliente);
router.delete("/clientes/:id", deleteCliente);

export default router;