-- ============================================================================
-- MIGRACIÓN: Agregar columna health_goal a tabla patients
-- ============================================================================
-- Fecha: 25 de noviembre de 2025
-- Descripción: Agrega el campo health_goal para almacenar el objetivo de
--              salud del paciente (bajar peso, mantener, subir peso, etc.)
-- ============================================================================

-- Agregar columna health_goal a la tabla patients
ALTER TABLE patients 
ADD COLUMN health_goal VARCHAR(50) NULL;

-- Comentario sobre la columna
COMMENT ON COLUMN patients.health_goal IS 'Objetivo de salud del paciente: LOSE_WEIGHT, MAINTAIN_WEIGHT, GAIN_WEIGHT, GAIN_MUSCLE';

-- Verificar que la columna se agregó correctamente
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'PATIENTS' 
AND COLUMN_NAME = 'HEALTH_GOAL';
