-- ============================================================================
-- SCRIPT PARA INSERTAR 10 PACIENTES CON DATOS COMPLETOS
-- ============================================================================
-- Genera 10 pacientes con toda su información:
-- - Usuarios y roles
-- - Datos personales y médicos
-- - Registros de peso
-- - Citas programadas
-- - Planes de dieta
-- ============================================================================

-- USUARIOS Y PACIENTES (IDs: 4-13)
-- Contraseña para todos: paciente123 ($2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2)

-- Paciente 1: Ana Martínez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('ana.martinez', 'ana.martinez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Ana', 'Martínez');
INSERT INTO user_roles (user_id, role_id) VALUES (4, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(4, 'Ana', 'Martínez', '1995-03-22', 'Femenino', 165.00, 68.00, 'Moderado', 'ana.martinez@email.com', '5512345001', 'Carlos Martínez', '5598765001', 'LOSE_WEIGHT', 'Ninguna', 'Ninguna', 'Vegetariana', '2024-09-15 10:30:00');

-- Paciente 2: Roberto Sánchez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('roberto.sanchez', 'roberto.sanchez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Roberto', 'Sánchez');
INSERT INTO user_roles (user_id, role_id) VALUES (5, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(5, 'Roberto', 'Sánchez', '1988-07-10', 'Masculino', 178.00, 95.00, 'Sedentario', 'roberto.sanchez@email.com', '5512345002', 'Laura Sánchez', '5598765002', 'LOSE_WEIGHT', 'Hipertensión', 'Ninguna', 'Bajo en sodio', '2024-08-20 14:15:00');

-- Paciente 3: María López
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('maria.lopez', 'maria.lopez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'María', 'López');
INSERT INTO user_roles (user_id, role_id) VALUES (6, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(6, 'María', 'López', '1992-11-05', 'Femenino', 160.00, 55.00, 'Activo', 'maria.lopez@email.com', '5512345003', 'José López', '5598765003', 'GAIN_WEIGHT', 'Ninguna', 'Lactosa', 'Sin lactosa', '2024-10-01 09:00:00');

-- Paciente 4: Carlos Ramírez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('carlos.ramirez', 'carlos.ramirez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Carlos', 'Ramírez');
INSERT INTO user_roles (user_id, role_id) VALUES (7, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(7, 'Carlos', 'Ramírez', '1985-01-18', 'Masculino', 182.00, 88.00, 'Muy activo', 'carlos.ramirez@email.com', '5512345004', 'Ana Ramírez', '5598765004', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2024-09-05 11:20:00');

-- Paciente 5: Laura Hernández
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('laura.hernandez', 'laura.hernandez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Laura', 'Hernández');
INSERT INTO user_roles (user_id, role_id) VALUES (8, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(8, 'Laura', 'Hernández', '1990-06-30', 'Femenino', 168.00, 72.00, 'Moderado', 'laura.hernandez@email.com', '5512345005', 'Pedro Hernández', '5598765005', 'LOSE_WEIGHT', 'Diabetes tipo 2', 'Ninguna', 'Bajo en azúcares', '2024-07-12 16:45:00');

-- Paciente 6: Diego Torres
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('diego.torres', 'diego.torres@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Diego', 'Torres');
INSERT INTO user_roles (user_id, role_id) VALUES (9, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(9, 'Diego', 'Torres', '1993-04-12', 'Masculino', 175.00, 70.00, 'Moderado', 'diego.torres@email.com', '5512345006', 'Sofia Torres', '5598765006', 'MAINTAIN_WEIGHT', 'Ninguna', 'Mariscos', 'Sin mariscos', '2024-10-15 13:30:00');

-- Paciente 7: Sofía Flores
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('sofia.flores', 'sofia.flores@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Sofía', 'Flores');
INSERT INTO user_roles (user_id, role_id) VALUES (10, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(10, 'Sofía', 'Flores', '1997-09-28', 'Femenino', 162.00, 58.00, 'Activo', 'sofia.flores@email.com', '5512345007', 'Miguel Flores', '5598765007', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2024-11-01 10:00:00');

-- Paciente 8: Fernando Vargas
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('fernando.vargas', 'fernando.vargas@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Fernando', 'Vargas');
INSERT INTO user_roles (user_id, role_id) VALUES (11, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(11, 'Fernando', 'Vargas', '1987-12-03', 'Masculino', 180.00, 102.00, 'Sedentario', 'fernando.vargas@email.com', '5512345008', 'Patricia Vargas', '5598765008', 'LOSE_WEIGHT', 'Obesidad, Colesterol alto', 'Ninguna', 'Bajo en grasas', '2024-08-08 15:20:00');

-- Paciente 9: Patricia Castro
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('patricia.castro', 'patricia.castro@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Patricia', 'Castro');
INSERT INTO user_roles (user_id, role_id) VALUES (12, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(12, 'Patricia', 'Castro', '1991-02-14', 'Femenino', 158.00, 62.00, 'Moderado', 'patricia.castro@email.com', '5512345009', 'Jorge Castro', '5598765009', 'MAINTAIN_WEIGHT', 'Ninguna', 'Gluten', 'Sin gluten', '2024-10-20 12:00:00');

-- Paciente 10: Miguel Ángel Reyes
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('miguel.reyes', 'miguel.reyes@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Miguel Ángel', 'Reyes');
INSERT INTO user_roles (user_id, role_id) VALUES (13, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(13, 'Miguel Ángel', 'Reyes', '1994-08-25', 'Masculino', 172.00, 65.00, 'Muy activo', 'miguel.reyes@email.com', '5512345010', 'Carmen Reyes', '5598765010', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2024-11-10 14:30:00');

-- ============================================================================
-- REGISTROS DE PESO HISTÓRICOS
-- ============================================================================

-- Ana Martínez (Paciente ID: 1) - Progreso de pérdida de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(1, 72.50, '2024-09-15', 'Peso inicial', '2024-09-15 10:30:00'),
(1, 71.20, '2024-09-30', 'Buena adherencia al plan', '2024-09-30 10:00:00'),
(1, 70.00, '2024-10-15', 'Perdiendo peso consistentemente', '2024-10-15 10:30:00'),
(1, 69.00, '2024-10-30', 'Excelente progreso', '2024-10-30 10:15:00'),
(1, 68.00, '2024-11-15', 'Peso actual', '2024-11-15 10:45:00');

-- Roberto Sánchez (Paciente ID: 2) - Progreso de pérdida de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(2, 98.50, '2024-08-20', 'Peso inicial', '2024-08-20 14:15:00'),
(2, 97.00, '2024-09-05', 'Iniciando cambios de hábitos', '2024-09-05 14:00:00'),
(2, 96.20, '2024-09-20', 'Buena respuesta', '2024-09-20 14:30:00'),
(2, 95.50, '2024-10-05', 'Progreso constante', '2024-10-05 14:15:00'),
(2, 95.00, '2024-11-01', 'Peso actual', '2024-11-01 14:00:00');

-- María López (Paciente ID: 3) - Progreso de ganancia de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(3, 52.00, '2024-10-01', 'Peso inicial, necesita ganar masa', '2024-10-01 09:00:00'),
(3, 53.00, '2024-10-15', 'Aumentando calorías', '2024-10-15 09:30:00'),
(3, 54.00, '2024-11-01', 'Buen progreso', '2024-11-01 09:15:00'),
(3, 55.00, '2024-11-15', 'Peso actual', '2024-11-15 09:00:00');

-- Carlos Ramírez (Paciente ID: 4) - Ganancia muscular
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(4, 85.00, '2024-09-05', 'Inicio entrenamiento fuerza', '2024-09-05 11:20:00'),
(4, 86.00, '2024-09-20', 'Aumentando masa muscular', '2024-09-20 11:00:00'),
(4, 87.00, '2024-10-10', 'Progreso notable', '2024-10-10 11:30:00'),
(4, 88.00, '2024-11-05', 'Peso actual', '2024-11-05 11:15:00');

-- Laura Hernández (Paciente ID: 5) - Control de diabetes
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(5, 75.00, '2024-07-12', 'Peso inicial, control glicémico', '2024-07-12 16:45:00'),
(5, 74.00, '2024-08-01', 'Mejorando control', '2024-08-01 16:30:00'),
(5, 73.00, '2024-09-01', 'Progreso estable', '2024-09-01 16:15:00'),
(5, 72.00, '2024-10-15', 'Peso actual', '2024-10-15 16:00:00');

-- ============================================================================
-- PLANES DE DIETA
-- ============================================================================

-- Plan para Ana Martínez - Pérdida de peso vegetariano
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(1, 2, 'Plan Vegetariano Balanceado', 'Plan enfocado en pérdida de peso saludable con opciones vegetarianas', 'Perder 5kg de forma saludable manteniendo nutrientes esenciales', 1600, '2024-09-15', '2024-12-15', 'ACTIVO', '2024-09-15 10:30:00');

-- Plan para Roberto Sánchez - Pérdida de peso y control de hipertensión
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(2, 2, 'Plan DASH Modificado', 'Plan bajo en sodio para controlar hipertensión y perder peso', 'Reducir peso y controlar presión arterial', 1800, '2024-08-20', '2024-11-20', 'ACTIVO', '2024-08-20 14:15:00');

-- Plan para María López - Ganancia de peso sin lactosa
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(3, 2, 'Plan Hipercalórico sin Lactosa', 'Plan para aumentar peso de forma saludable sin productos lácteos', 'Ganar 3kg de masa magra', 2200, '2024-10-01', '2025-01-01', 'ACTIVO', '2024-10-01 09:00:00');

-- Plan para Carlos Ramírez - Ganancia muscular
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(4, 2, 'Plan Alto en Proteínas', 'Plan deportivo para aumentar masa muscular', 'Ganar 5kg de músculo', 2800, '2024-09-05', '2024-12-05', 'ACTIVO', '2024-09-05 11:20:00');

-- Plan para Laura Hernández - Control de diabetes
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(5, 2, 'Plan para Diabetes Tipo 2', 'Plan bajo en azúcares simples y carbohidratos controlados', 'Control glicémico y pérdida de peso gradual', 1700, '2024-07-12', '2024-10-12', 'COMPLETADO', '2024-07-12 16:45:00');

-- Plan para Diego Torres - Mantenimiento
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(6, 2, 'Plan de Mantenimiento', 'Mantener peso saludable con alimentación balanceada', 'Mantener peso y buena salud', 2000, '2024-10-15', '2025-01-15', 'ACTIVO', '2024-10-15 13:30:00');

-- Plan para Sofía Flores - Ganancia muscular
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(7, 2, 'Plan Fitness Mujer', 'Plan para tonificación y ganancia de masa magra', 'Aumentar masa muscular y definición', 2100, '2024-11-01', '2025-02-01', 'ACTIVO', '2024-11-01 10:00:00');

-- Plan para Fernando Vargas - Pérdida de peso significativa
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(8, 2, 'Plan de Pérdida Intensiva', 'Plan bajo en grasas para pérdida de peso significativa', 'Perder 15kg en 4 meses de forma saludable', 1500, '2024-08-08', '2024-12-08', 'ACTIVO', '2024-08-08 15:20:00');

-- Plan para Patricia Castro - Mantenimiento sin gluten
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(9, 2, 'Plan sin Gluten', 'Plan de mantenimiento libre de gluten', 'Mantener peso y evitar síntomas de intolerancia', 1900, '2024-10-20', '2025-01-20', 'ACTIVO', '2024-10-20 12:00:00');

-- Plan para Miguel Ángel Reyes - Rendimiento deportivo
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(10, 2, 'Plan Deportivo Avanzado', 'Plan para optimizar rendimiento y ganancia muscular', 'Aumentar fuerza y masa muscular', 2700, '2024-11-10', '2025-02-10', 'ACTIVO', '2024-11-10 14:30:00');

-- ============================================================================
-- CITAS PROGRAMADAS
-- ============================================================================

-- Citas pasadas (completadas)
INSERT INTO appointments (patient_id, nutritionist_id, appointment_date, appointment_type, status, duration_minutes, notes, created_at) VALUES
-- Ana Martínez
(1, 2, '2024-09-15 10:30:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación inicial, medidas antropométricas', '2024-09-10 10:00:00'),
(1, 2, '2024-10-15 10:30:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Revisión de progreso, ajuste de plan', '2024-10-10 09:00:00'),
(1, 2, '2024-11-15 10:30:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Excelente adherencia, continuar plan', '2024-11-10 08:30:00'),

-- Roberto Sánchez
(2, 2, '2024-08-20 14:00:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación inicial, análisis de presión arterial', '2024-08-15 11:00:00'),
(2, 2, '2024-09-20 14:00:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Buena respuesta al plan DASH', '2024-09-15 10:30:00'),
(2, 2, '2024-10-20 14:00:00', 'CONTROL', 'COMPLETADA', 30, 'Control de presión, ajuste de sodio', '2024-10-15 09:00:00'),

-- María López
(3, 2, '2024-10-01 09:00:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación nutricional, plan hipercalórico', '2024-09-25 14:00:00'),
(3, 2, '2024-11-01 09:00:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Ganancia progresiva de peso', '2024-10-28 10:00:00');

-- Citas próximas (confirmadas y pendientes)
INSERT INTO appointments (patient_id, nutritionist_id, appointment_date, appointment_type, status, duration_minutes, notes, created_at) VALUES
-- Citas para diciembre 2024
(1, 2, '2024-12-15 10:30:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Evaluación final del plan', '2024-11-20 10:00:00'),
(2, 2, '2024-12-05 14:00:00', 'CONTROL', 'CONFIRMADA', 30, 'Control de presión arterial', '2024-11-25 09:00:00'),
(3, 2, '2024-12-01 09:00:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Revisión de progreso', '2024-11-20 11:00:00'),
(4, 2, '2024-12-10 11:00:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Evaluación de masa muscular', '2024-11-22 14:00:00'),
(5, 2, '2024-12-08 16:00:00', 'CONTROL', 'CONFIRMADA', 45, 'Revisión de glucosa', '2024-11-23 10:30:00'),
(6, 2, '2024-12-12 13:30:00', 'SEGUIMIENTO', 'PENDIENTE', 30, 'Control de mantenimiento', '2024-11-24 09:00:00'),
(7, 2, '2024-12-03 10:00:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Evaluación de progreso fitness', '2024-11-26 11:00:00'),
(8, 2, '2024-12-06 15:00:00', 'CONTROL', 'CONFIRMADA', 45, 'Control de peso y colesterol', '2024-11-27 10:00:00'),
(9, 2, '2024-12-14 12:00:00', 'SEGUIMIENTO', 'PENDIENTE', 30, 'Revisión plan sin gluten', '2024-11-28 14:00:00'),
(10, 2, '2024-12-04 14:30:00', 'PRIMERA_CONSULTA', 'CONFIRMADA', 60, 'Evaluación inicial deportiva', '2024-11-29 09:00:00');

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
-- Total insertado:
-- - 10 usuarios nuevos (IDs 4-13)
-- - 10 pacientes con información completa
-- - 24 registros de peso históricos
-- - 10 planes de dieta (9 activos, 1 completado)
-- - 18 citas (8 completadas, 10 próximas: 6 confirmadas, 4 pendientes)
-- ============================================================================
