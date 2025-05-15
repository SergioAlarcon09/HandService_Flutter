--! TABLAS DE LA BASE DE DATOS

-- Tabla de niveles educativos
CREATE TABLE niveles_educativos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  estado BOOLEAN DEFAULT TRUE
);

-- Tabla de usuarios
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  num_documento VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  sexo CHAR(1) CHECK (sexo IN ('M', 'F', 'O')) -- M: Masculino, F: Femenino, O: Otro
);

-- Tabla de clientes
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  longitud DECIMAL(10, 6),
  latitud DECIMAL(10, 6),
  usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de servicios
CREATE TABLE servicios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  estado BOOLEAN DEFAULT TRUE,
  valor DECIMAL(10, 2) DEFAULT 0
);

-- Tabla de prestadores de servicios
CREATE TABLE prestadores_servicios (
  id SERIAL PRIMARY KEY,
  profesion VARCHAR(100) NOT NULL,
  nivel_educativo_id INTEGER REFERENCES niveles_educativos(id),
  usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de solicitudes de servicios
CREATE TABLE solicitudes_servicios (
  id SERIAL PRIMARY KEY,
  servicio_id INTEGER REFERENCES servicios(id),
  tiempo_estimado INTEGER, -- en minutos
  fecha_inicio TIMESTAMP,
  fecha_fin TIMESTAMP,
  cantidad INTEGER DEFAULT 1,
  valor DECIMAL(10, 2),
  cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE,
  prestador_servicio_id INTEGER REFERENCES prestadores_servicios(id),
  estado VARCHAR(20) CHECK (estado IN ('PENDIENTE', 'ACEPTADO', 'EN_PROCESO', 'COMPLETADO', 'CANCELADO'))
);

-- Tabla de puntuaciones
CREATE TABLE puntuaciones (
  id SERIAL PRIMARY KEY,
  puntuacion INTEGER CHECK (puntuacion BETWEEN 1 AND 5),
  solicitud_servicio_id INTEGER REFERENCES solicitudes_servicios(id) ON DELETE CASCADE,
  descripcion TEXT,
  evidencia TEXT -- podría ser una URL a una imagen
);

--! INSERT DE DATOS DE PRUEBA

-- Insertar niveles educativos
INSERT INTO niveles_educativos (nombre, descripcion) VALUES
('Secundaria', 'Educación secundaria completa'),
('Técnico', 'Formación técnica o tecnológica'),
('Universitario', 'Educación universitaria completa'),
('Posgrado', 'Especialización, maestría o doctorado');

-- Insertar usuarios (clientes y prestadores)
INSERT INTO usuarios (nombre, apellido, num_documento, email, password, telefono, sexo) VALUES
-- Clientes
('Juan', 'Pérez', '10000001', 'juan@example.com', 'password123', '3001111111', 'M'),
('María', 'Gómez', '10000002', 'maria@example.com', 'password123', '3002222222', 'F'),
('Carlos', 'López', '10000003', 'carlos@example.com', 'password123', '3003333333', 'M'),
-- Prestadores
('Pedro', 'Martínez', '20000001', 'pedro@example.com', 'password123', '3004444444', 'M'),
('Ana', 'Rodríguez', '20000002', 'ana@example.com', 'password123', '3005555555', 'F'),
('Luisa', 'Fernández', '20000003', 'luisa@example.com', 'password123', '3006666666', 'F');

-- Insertar clientes
INSERT INTO clientes (longitud, latitud, usuario_id) VALUES
(-74.08175, 4.60971, 1), -- Bogotá
(-75.56359, 6.25184, 2), -- Medellín
(-76.52197, 3.42158, 3); -- Cali

-- Insertar prestadores de servicios
INSERT INTO prestadores_servicios (profesion, nivel_educativo_id, usuario_id) VALUES
('Electricista', 2, 4),
('Plomero', 1, 5),
('Mecánico', 3, 6);

-- Insertar servicios
INSERT INTO servicios (nombre, descripcion, valor) VALUES
('Reparación eléctrica', 'Reparación de instalaciones eléctricas en hogar', 50000),
('Instalación de tuberías', 'Instalación y reparación de tuberías de agua', 45000),
('Cambio de aceite', 'Cambio de aceite y filtro para vehículo', 60000),
('Reparación de electrodomésticos', 'Reparación de neveras, lavadoras, etc.', 55000);

-- Insertar solicitudes de servicios
INSERT INTO solicitudes_servicios (servicio_id, tiempo_estimado, fecha_inicio, fecha_fin, cantidad, valor, cliente_id, prestador_servicio_id, estado) VALUES
(1, 120, '2023-11-15 10:00:00', '2023-11-15 12:00:00', 1, 50000, 1, 1, 'COMPLETADO'),
(2, 90, '2023-11-16 14:00:00', '2023-11-16 15:30:00', 1, 45000, 2, 2, 'COMPLETADO'),
(3, 60, '2023-11-17 09:00:00', '2023-11-17 10:00:00', 1, 60000, 3, 3, 'EN_PROCESO'),
(1, 120, '2023-11-18 11:00:00', NULL, 1, 50000, 1, NULL, 'PENDIENTE');

-- Insertar puntuaciones
INSERT INTO puntuaciones (puntuacion, solicitud_servicio_id, descripcion) VALUES
(5, 1, 'Excelente servicio, muy profesional'),
(4, 2, 'Buen trabajo, pero llegó un poco tarde');