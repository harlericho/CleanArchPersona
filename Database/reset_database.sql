-- ===============================================
-- Script de Limpieza y Reinicio
-- Proyecto: CleanArchPersona
-- Fecha: 27 de Julio, 2025
-- ===============================================

-- ADVERTENCIA: Este script eliminará todos los datos existentes
-- Úsalo solo en desarrollo o cuando necesites reiniciar completamente

\echo '⚠️  ADVERTENCIA: Este script eliminará todos los datos existentes'
\echo '👉 Presiona Ctrl+C para cancelar o cualquier tecla para continuar...'
\prompt 'Continuar? (s/N): ' confirm

-- ===============================================
-- LIMPIEZA COMPLETA
-- ===============================================

-- Eliminar tabla existente (CASCADE elimina dependencias)
DROP TABLE IF EXISTS persona CASCADE;

-- Reiniciar secuencias (auto-increment)
DROP SEQUENCE IF EXISTS persona_id_seq CASCADE;

-- ===============================================
-- RECREAR ESTRUCTURA
-- ===============================================

\echo '🔄 Recreando tabla persona...'

-- Crear tabla persona
CREATE TABLE persona (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    edad INTEGER NOT NULL,
    pais VARCHAR(50)
);

-- ===============================================
-- RECREAR ÍNDICES
-- ===============================================

\echo '📊 Creando índices...'

-- Índice por país
CREATE INDEX idx_persona_pais ON persona(pais);

-- Índice por edad
CREATE INDEX idx_persona_edad ON persona(edad);

-- Índice compuesto para consultas optimizadas
CREATE INDEX idx_persona_edad_pais ON persona(edad, pais);

-- ===============================================
-- DATOS DE DESARROLLO
-- ===============================================

\echo '💾 Insertando datos de prueba...'

-- Insertar datos de desarrollo
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
    ('Isabel Morales', 31, 'uruguay'),
    ('Pedro Jiménez', 45, 'bolivia'),
    ('Sofia Vargas', 29, 'paraguay'),
    ('Diego Castillo', 36, 'costa_rica'),
    ('Valentina Cruz', 24, 'panama'),
    ('Roberto Silva', 41, 'guatemala');

-- ===============================================
-- VERIFICACIÓN FINAL
-- ===============================================

\echo '✅ Verificando resultado...'

-- Mostrar estructura
\d persona

-- Mostrar conteo
SELECT COUNT(*) as total_registros FROM persona;

-- Mostrar algunos registros
SELECT id, nombre, edad, pais FROM persona ORDER BY id LIMIT 10;

-- Estadísticas por país
SELECT pais, COUNT(*) as cantidad 
FROM persona 
GROUP BY pais 
ORDER BY cantidad DESC, pais;

\echo '🎉 Base de datos reiniciada exitosamente!'
\echo '📊 Total de registros insertados:' 
SELECT COUNT(*) FROM persona;

-- ===============================================
-- INFORMACIÓN DE CONEXIÓN
-- ===============================================

\echo '🔗 Información de conexión para la aplicación:'
\echo 'Host: localhost'
\echo 'Port: 5432'
\echo 'Database: db_ejemplo'
\echo 'Username: postgres'
\echo 'Connection String: Host=localhost;Port=5432;Username=postgres;Password=postgres;Database=db_ejemplo'
