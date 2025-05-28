import pool from "../db.js";

// Obtener todas las solicitudes
export const getSolicitudesServicios = async (req, res) => {
    try {
        const { rows } = await pool.query("SELECT * FROM solicitudes_servicios");
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener solicitudes" });
    }
};

// Obtener una solicitud por ID
export const getSolicitudServicio = async (req, res) => {
    try {
        const { id } = req.params;
        const { rows } = await pool.query(
            "SELECT * FROM solicitudes_servicios WHERE id = $1",
            [id]
        );

        if (rows.length === 0) return res.status(404).json({ message: "No encontrada" });
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ message: "Error interno" });
    }
};

// Crear nueva solicitud
export const createSolicitudServicio = async (req, res) => {
    const {
        servicio_id,
        tiempo_estimado,
        fecha_inicio,
        fecha_fin,
        cantidad,
        valor,
        cliente_id,
        prestador_servicio_id,
        estado,
    } = req.body;

    try {
        const { rows } = await pool.query(
            `INSERT INTO solicitudes_servicios
        (servicio_id, tiempo_estimado, fecha_inicio, fecha_fin, cantidad, valor, cliente_id, prestador_servicio_id, estado)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *`,
            [
                servicio_id,
                tiempo_estimado,
                fecha_inicio,
                fecha_fin,
                cantidad,
                valor,
                cliente_id,
                prestador_servicio_id,
                estado,
            ]
        );
        res.status(201).json(rows[0]);
    } catch (error) {
        res.status(500).json({ message: "Error al crear la solicitud" });
    }
};

// Actualizar solicitud
export const updateSolicitudServicio = async (req, res) => {
    const { id } = req.params;
    const {
        servicio_id,
        tiempo_estimado,
        fecha_inicio,
        fecha_fin,
        cantidad,
        valor,
        cliente_id,
        prestador_servicio_id,
        estado,
    } = req.body;

    try {
        const { rowCount } = await pool.query(
            `UPDATE solicitudes_servicios SET
        servicio_id = COALESCE($1, servicio_id),
        tiempo_estimado = COALESCE($2, tiempo_estimado),
        fecha_inicio = COALESCE($3, fecha_inicio),
        fecha_fin = COALESCE($4, fecha_fin),
        cantidad = COALESCE($5, cantidad),
        valor = COALESCE($6, valor),
        cliente_id = COALESCE($7, cliente_id),
        prestador_servicio_id = COALESCE($8, prestador_servicio_id),
        estado = COALESCE($9, estado)
        WHERE id = $10`,
            [
                servicio_id,
                tiempo_estimado,
                fecha_inicio,
                fecha_fin,
                cantidad,
                valor,
                cliente_id,
                prestador_servicio_id,
                estado,
                id,
            ]
        );

        if (rowCount === 0) return res.status(404).json({ message: "No encontrada" });

        const { rows } = await pool.query("SELECT * FROM solicitudes_servicios WHERE id = $1", [id]);
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ message: "Error al actualizar" });
    }
};

// Eliminar solicitud
export const deleteSolicitudServicio = async (req, res) => {
    try {
        const { id } = req.params;
        const { rowCount } = await pool.query("DELETE FROM solicitudes_servicios WHERE id = $1", [id]);

        if (rowCount === 0) return res.status(404).json({ message: "No encontrada" });

        res.sendStatus(204);
    } catch (error) {
        res.status(500).json({ message: "Error al eliminar" });
    }
};