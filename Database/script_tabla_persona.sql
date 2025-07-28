-- ===============================================
-- Script de Base de Datos PostgreSQL
-- Proyecto: CleanArchPersona
-- Fecha: 27 de Julio, 2025
-- ===============================================

-- Crear la base de datos (opcional, si no existe)
-- CREATE DATABASE db_ejemplo;

-- Conectar a la base de datos
-- \c db_ejemplo;

-- ===============================================
-- TABLA: persona
-- ===============================================

-- Eliminar tabla si existe (para recrear)
DROP TABLE IF EXISTS persona CASCADE;

-- Crear tabla persona
CREATE TABLE persona (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    edad INTEGER NOT NULL,
    pais VARCHAR(50)
);

-- ===============================================
-- COMENTARIOS DE LA TABLA
-- ===============================================

COMMENT ON TABLE persona IS 'Tabla que almacena información de personas';
COMMENT ON COLUMN persona.id IS 'Identificador único de la persona (clave primaria)';
COMMENT ON COLUMN persona.nombre IS 'Nombre completo de la persona (máximo 100 caracteres)';
COMMENT ON COLUMN persona.edad IS 'Edad de la persona en años';
COMMENT ON COLUMN persona.pais IS 'País de origen de la persona (máximo 50 caracteres)';

-- ===============================================
-- ÍNDICES ADICIONALES (OPCIONAL)
-- ===============================================

-- Índice por país para consultas de filtrado eficientes
CREATE INDEX idx_persona_pais ON persona(pais);

-- Índice por edad para consultas de filtrado eficientes
CREATE INDEX idx_persona_edad ON persona(edad);

-- Índice compuesto para la consulta GetAgeAndCountry
CREATE INDEX idx_persona_edad_pais ON persona(edad, pais);

-- ===============================================
-- DATOS DE PRUEBA (OPCIONAL)
-- ===============================================

-- Insertar algunos registros de ejemplo
INSERT INTO persona (nombre, edad, pais) VALUES 
    ('Juan Pérez', 30, 'colombia'),
    ('María García', 25, 'españa'),
    ('Carlos López', 35, 'mexico'),
    ('Ana Martínez', 28, 'argentina'),
    ('Luis Rodríguez', 42, 'chile'),
    ('Carmen Fernández', 30, 'colombia'),
    ('Miguel Torres', 33, 'peru'),
    ('Laura Sánchez', 27, 'ecuador'),
    ('José Herrera', 38, 'venezuela'),
    ('Isabel Morales', 31, 'uruguay');

-- ===============================================
-- VERIFICACIÓN DE LA ESTRUCTURA
-- ===============================================

-- Mostrar estructura de la tabla
\d persona;

-- Contar registros insertados
SELECT COUNT(*) as total_personas FROM persona;

-- Mostrar algunos registros de ejemplo
SELECT id, nombre, edad, pais FROM persona LIMIT 5;

-- ===============================================
-- CONSULTAS DE EJEMPLO USADAS EN LA APLICACIÓN
-- ===============================================

-- 1. Obtener todas las personas
SELECT id, nombre, edad, pais FROM persona ORDER BY id;

-- 2. Obtener persona por ID
SELECT id, nombre, edad, pais FROM persona WHERE id = 1;

-- 3. Filtrar por edad y país (método GetAgeAndCountry)
SELECT id, nombre, edad, pais FROM persona WHERE edad = 30 AND pais = 'colombia';

-- 4. Contar personas por país
SELECT pais, COUNT(*) as cantidad 
FROM persona 
GROUP BY pais 
ORDER BY cantidad DESC;

-- 5. Promedio de edad por país
SELECT pais, ROUND(AVG(edad), 2) as edad_promedio
FROM persona 
GROUP BY pais 
ORDER BY edad_promedio DESC;

-- ===============================================
-- INFORMACIÓN DEL SISTEMA
-- ===============================================

-- Verificar versión de PostgreSQL
SELECT version();

-- Verificar configuración de conexión usada en la aplicación
-- Host: localhost
-- Port: 5432
-- Username: postgres
-- Password: postgres
-- Database: db_ejemplo

-- ===============================================
-- NOTAS IMPORTANTES
-- ===============================================

/*
1. La tabla usa SERIAL para el campo id (auto-incremento)
2. Los campos VARCHAR tienen límites según la configuración Fluent API
3. El campo edad es NOT NULL según la lógica de negocio
4. Los índices mejoran el rendimiento de las consultas frecuentes
5. Los datos de prueba son opcionales y pueden eliminarse

COMANDOS ÚTILES:
- Para conectar: psql -h localhost -p 5432 -U postgres -d db_ejemplo
- Para ejecutar script: \i script_tabla_persona.sql
- Para ver tablas: \dt
- Para salir: \q
*/
