-- ============================================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS - SISTEMA NUTRITRACK
-- ============================================================================
-- Versión: 1.0
-- Fecha: Noviembre 2025
-- Autor: Carlos HR
-- Descripción: Script completo para la creación del esquema de base de datos
--              del sistema de gestión nutricional NutriTrack
-- Motor: H2 Database (compatible con sintaxis SQL estándar)
-- ============================================================================

-- ============================================================================
-- CONFIGURACIÓN INICIAL
-- ============================================================================

-- Configuración de modo de base de datos
SET MODE MySQL;

-- Habilitar integridad referencial
SET REFERENTIAL_INTEGRITY TRUE;

-- ============================================================================
-- ELIMINACIÓN DE TABLAS EXISTENTES (Si existen)
-- ============================================================================
-- Orden: Primero tablas dependientes, luego tablas principales

DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS diet_meals CASCADE;
DROP TABLE IF EXISTS diet_plans CASCADE;
DROP TABLE IF EXISTS weight_entries CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS foods CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================================================
-- TABLA: USERS
-- Descripción: Almacena información de todos los usuarios del sistema
--              (administradores, nutriólogos y pacientes)
-- ============================================================================

CREATE TABLE users (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Credenciales de Acceso
    username VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(120) NOT NULL,
    
    -- Información Personal
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    address VARCHAR(200),
    
    -- Información Profesional (Para Nutriólogos)
    degree VARCHAR(100),
    university VARCHAR(200),
    professional_license VARCHAR(50),
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Restricciones
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%'),
    CONSTRAINT chk_username_length CHECK (LENGTH(username) >= 3),
    CONSTRAINT chk_password_length CHECK (LENGTH(password) >= 6)
);

-- Índices para USERS
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_professional_license ON users(professional_license);

-- Comentarios de la tabla
COMMENT ON TABLE users IS 'Usuarios del sistema con información personal y profesional';
COMMENT ON COLUMN users.id IS 'Identificador único del usuario';
COMMENT ON COLUMN users.username IS 'Nombre de usuario para inicio de sesión (único)';
COMMENT ON COLUMN users.email IS 'Correo electrónico del usuario (único)';
COMMENT ON COLUMN users.password IS 'Contraseña encriptada con BCrypt';
COMMENT ON COLUMN users.professional_license IS 'Cédula profesional del nutriólogo';

-- ============================================================================
-- TABLA: ROLES
-- Descripción: Catálogo de roles del sistema para control de acceso basado en roles (RBAC)
-- ============================================================================

CREATE TABLE roles (
    -- Clave Primaria
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    
    -- Nombre del Rol
    name VARCHAR(20) NOT NULL UNIQUE,
    
    -- Restricciones
    CONSTRAINT chk_role_name CHECK (name IN ('ROLE_ADMIN', 'ROLE_NUTRIOLOGO', 'ROLE_PACIENTE'))
);

-- Índices para ROLES
CREATE INDEX idx_roles_name ON roles(name);

-- Comentarios
COMMENT ON TABLE roles IS 'Catálogo de roles del sistema (Admin, Nutriólogo, Paciente)';
COMMENT ON COLUMN roles.name IS 'Nombre del rol con prefijo ROLE_';

-- ============================================================================
-- TABLA: USER_ROLES (Tabla Intermedia)
-- Descripción: Relación N:M entre usuarios y roles
--              Un usuario puede tener múltiples roles
-- ============================================================================

CREATE TABLE user_roles (
    -- Claves Foráneas (Clave Primaria Compuesta)
    user_id BIGINT NOT NULL,
    role_id INTEGER NOT NULL,
    
    -- Clave Primaria Compuesta
    PRIMARY KEY (user_id, role_id),
    
    -- Claves Foráneas con CASCADE
    CONSTRAINT fk_user_roles_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_user_roles_role 
        FOREIGN KEY (role_id) 
        REFERENCES roles(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Índices para USER_ROLES
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role_id);

-- Comentarios
COMMENT ON TABLE user_roles IS 'Tabla de relación N:M entre usuarios y roles';
COMMENT ON COLUMN user_roles.user_id IS 'Referencia al usuario';
COMMENT ON COLUMN user_roles.role_id IS 'Referencia al rol asignado';

-- ============================================================================
-- TABLA: PATIENTS
-- Descripción: Información médica y personal de pacientes registrados en el sistema
-- ============================================================================

CREATE TABLE patients (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relación 1:1 con USERS
    user_id BIGINT UNIQUE,
    
    -- Información Personal
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    
    -- Datos Antropométricos
    height DECIMAL(5,2),
    current_weight DECIMAL(5,2),
    activity_level VARCHAR(50),
    
    -- Información Médica
    medical_conditions VARCHAR(1000),
    allergies VARCHAR(500),
    dietary_restrictions VARCHAR(500),
    
    -- Información de Contacto
    email VARCHAR(100),
    phone VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Clave Foránea
    CONSTRAINT fk_patients_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Restricciones de Validación
    CONSTRAINT chk_height CHECK (height IS NULL OR (height > 0 AND height <= 300)),
    CONSTRAINT chk_weight CHECK (current_weight IS NULL OR (current_weight > 0 AND current_weight <= 500)),
    CONSTRAINT chk_gender CHECK (gender IS NULL OR gender IN ('M', 'F', 'Masculino', 'Femenino', 'Otro')),
    CONSTRAINT chk_dob CHECK (date_of_birth IS NULL OR date_of_birth < CURRENT_DATE)
);

-- Índices para PATIENTS
CREATE INDEX idx_patients_user ON patients(user_id);
CREATE INDEX idx_patients_email ON patients(email);
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_patients_created ON patients(created_at);

-- Comentarios
COMMENT ON TABLE patients IS 'Información médica y personal de los pacientes';
COMMENT ON COLUMN patients.height IS 'Altura en centímetros';
COMMENT ON COLUMN patients.current_weight IS 'Peso actual en kilogramos';
COMMENT ON COLUMN patients.activity_level IS 'Nivel de actividad física (Sedentario, Moderado, Activo)';

-- ============================================================================
-- TABLA: FOODS
-- Descripción: Catálogo de alimentos con información nutricional
-- ============================================================================

CREATE TABLE foods (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Información del Alimento
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    serving_size VARCHAR(50),
    description VARCHAR(500),
    
    -- Información Nutricional
    calories INTEGER,
    protein_grams DOUBLE,
    carbs_grams DOUBLE,
    fat_grams DOUBLE,
    fiber_grams DOUBLE,
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Restricciones de Validación
    CONSTRAINT chk_calories CHECK (calories IS NULL OR calories >= 0),
    CONSTRAINT chk_protein CHECK (protein_grams IS NULL OR protein_grams >= 0),
    CONSTRAINT chk_carbs CHECK (carbs_grams IS NULL OR carbs_grams >= 0),
    CONSTRAINT chk_fat CHECK (fat_grams IS NULL OR fat_grams >= 0),
    CONSTRAINT chk_fiber CHECK (fiber_grams IS NULL OR fiber_grams >= 0)
);

-- Índices para FOODS
CREATE INDEX idx_foods_name ON foods(name);
CREATE INDEX idx_foods_category ON foods(category);
CREATE INDEX idx_foods_calories ON foods(calories);

-- Comentarios
COMMENT ON TABLE foods IS 'Catálogo de alimentos con información nutricional';
COMMENT ON COLUMN foods.serving_size IS 'Tamaño de la porción (ej: 100g, 1 taza, 1 pieza)';
COMMENT ON COLUMN foods.calories IS 'Calorías por porción';

-- ============================================================================
-- TABLA: DIET_PLANS
-- Descripción: Planes dietéticos personalizados creados por nutriólogos
-- ============================================================================

CREATE TABLE diet_plans (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relaciones
    patient_id BIGINT NOT NULL,
    nutritionist_id BIGINT NOT NULL,
    
    -- Información del Plan
    plan_name VARCHAR(200),
    start_date DATE,
    end_date DATE,
    daily_calories INTEGER,
    description VARCHAR(1000),
    goals VARCHAR(500),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Claves Foráneas
    CONSTRAINT fk_diet_plans_patient 
        FOREIGN KEY (patient_id) 
        REFERENCES patients(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_diet_plans_nutritionist 
        FOREIGN KEY (nutritionist_id) 
        REFERENCES users(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Restricciones de Validación
    CONSTRAINT chk_status CHECK (status IN ('ACTIVE', 'COMPLETED', 'PAUSED', 'CANCELLED')),
    CONSTRAINT chk_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT chk_daily_calories CHECK (daily_calories IS NULL OR (daily_calories >= 1000 AND daily_calories <= 5000))
);

-- Índices para DIET_PLANS
CREATE INDEX idx_diet_plans_patient ON diet_plans(patient_id);
CREATE INDEX idx_diet_plans_nutritionist ON diet_plans(nutritionist_id);
CREATE INDEX idx_diet_plans_status ON diet_plans(status);
CREATE INDEX idx_diet_plans_dates ON diet_plans(start_date, end_date);
CREATE INDEX idx_diet_plans_created ON diet_plans(created_at DESC);

-- Comentarios
COMMENT ON TABLE diet_plans IS 'Planes dietéticos personalizados para pacientes';
COMMENT ON COLUMN diet_plans.status IS 'Estado del plan: ACTIVE, COMPLETED, PAUSED, CANCELLED';
COMMENT ON COLUMN diet_plans.daily_calories IS 'Meta de calorías diarias';

-- ============================================================================
-- TABLA: DIET_MEALS
-- Descripción: Comidas individuales que componen un plan dietético
-- ============================================================================

CREATE TABLE diet_meals (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relación con Plan Dietético
    diet_plan_id BIGINT NOT NULL,
    
    -- Información de la Comida
    meal_type VARCHAR(50),
    meal_name VARCHAR(200),
    servings INTEGER DEFAULT 1,
    description VARCHAR(1000),
    
    -- Información Nutricional
    calories INTEGER,
    protein_grams DOUBLE,
    carbs_grams DOUBLE,
    fat_grams DOUBLE,
    fiber_grams DOUBLE,
    
    -- Preparación
    preparation_time INTEGER,
    ingredients VARCHAR(2000),
    instructions VARCHAR(2000),
    notes VARCHAR(500),
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Clave Foránea
    CONSTRAINT fk_diet_meals_plan 
        FOREIGN KEY (diet_plan_id) 
        REFERENCES diet_plans(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Restricciones de Validación
    CONSTRAINT chk_meal_type CHECK (meal_type IN ('BREAKFAST', 'SNACK', 'LUNCH', 'DINNER')),
    CONSTRAINT chk_servings CHECK (servings >= 1),
    CONSTRAINT chk_meal_calories CHECK (calories IS NULL OR calories >= 0),
    CONSTRAINT chk_prep_time CHECK (preparation_time IS NULL OR (preparation_time >= 0 AND preparation_time <= 240))
);

-- Índices para DIET_MEALS
CREATE INDEX idx_diet_meals_plan ON diet_meals(diet_plan_id);
CREATE INDEX idx_diet_meals_type ON diet_meals(meal_type);
CREATE INDEX idx_diet_meals_name ON diet_meals(meal_name);

-- Comentarios
COMMENT ON TABLE diet_meals IS 'Comidas individuales de los planes dietéticos';
COMMENT ON COLUMN diet_meals.meal_type IS 'Tipo de comida: BREAKFAST, SNACK, LUNCH, DINNER';
COMMENT ON COLUMN diet_meals.preparation_time IS 'Tiempo de preparación en minutos';

-- ============================================================================
-- TABLA: WEIGHT_ENTRIES
-- Descripción: Registros históricos de peso de los pacientes
-- ============================================================================

CREATE TABLE weight_entries (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relación con Paciente
    patient_id BIGINT NOT NULL,
    
    -- Datos del Registro
    weight DECIMAL(5,2) NOT NULL,
    entry_date DATE NOT NULL,
    notes VARCHAR(500),
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Clave Foránea
    CONSTRAINT fk_weight_entries_patient 
        FOREIGN KEY (patient_id) 
        REFERENCES patients(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Restricciones de Validación
    CONSTRAINT chk_weight_value CHECK (weight > 0 AND weight <= 500),
    CONSTRAINT chk_entry_date CHECK (entry_date <= CURRENT_DATE),
    
    -- Restricción de Unicidad (Un registro por paciente por día)
    CONSTRAINT uk_patient_date UNIQUE (patient_id, entry_date)
);

-- Índices para WEIGHT_ENTRIES
CREATE INDEX idx_weight_entries_patient ON weight_entries(patient_id);
CREATE INDEX idx_weight_entries_date ON weight_entries(entry_date DESC);
CREATE INDEX idx_weight_entries_patient_date ON weight_entries(patient_id, entry_date DESC);

-- Comentarios
COMMENT ON TABLE weight_entries IS 'Historial de mediciones de peso de pacientes';
COMMENT ON COLUMN weight_entries.weight IS 'Peso en kilogramos';
COMMENT ON COLUMN weight_entries.entry_date IS 'Fecha del registro de peso';

-- ============================================================================
-- TABLA: APPOINTMENTS
-- Descripción: Citas programadas entre pacientes y nutriólogos
-- ============================================================================

CREATE TABLE appointments (
    -- Clave Primaria
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relaciones
    patient_id BIGINT NOT NULL,
    nutritionist_id BIGINT NOT NULL,
    
    -- Información de la Cita
    appointment_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    appointment_type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PROGRAMADA',
    
    -- Notas
    notes VARCHAR(1000),
    patient_notes VARCHAR(1000),
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Claves Foráneas
    CONSTRAINT fk_appointments_patient 
        FOREIGN KEY (patient_id) 
        REFERENCES patients(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_appointments_nutritionist 
        FOREIGN KEY (nutritionist_id) 
        REFERENCES users(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Restricciones de Validación
    CONSTRAINT chk_appointment_type CHECK (appointment_type IN ('CONSULTA', 'SEGUIMIENTO', 'EMERGENCIA')),
    CONSTRAINT chk_appointment_status CHECK (status IN ('PROGRAMADA', 'COMPLETADA', 'CANCELADA', 'NO_ASISTIO', 'ATENDIDO')),
    CONSTRAINT chk_duration CHECK (duration_minutes >= 15 AND duration_minutes <= 240),
    
    -- Restricción de Unicidad (Evitar citas duplicadas)
    CONSTRAINT uk_nutritionist_datetime UNIQUE (nutritionist_id, appointment_date)
);

-- Índices para APPOINTMENTS
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_nutritionist ON appointments(nutritionist_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_nutri_date ON appointments(nutritionist_id, appointment_date);

-- Comentarios
COMMENT ON TABLE appointments IS 'Citas programadas entre pacientes y nutriólogos';
COMMENT ON COLUMN appointments.appointment_type IS 'Tipo: CONSULTA, SEGUIMIENTO, EMERGENCIA';
COMMENT ON COLUMN appointments.status IS 'Estado: PROGRAMADA, COMPLETADA, CANCELADA, NO_ASISTIO, ATENDIDO';
COMMENT ON COLUMN appointments.duration_minutes IS 'Duración de la cita en minutos (por defecto 60)';

-- ============================================================================
-- DATOS INICIALES - ROLES DEL SISTEMA
-- ============================================================================

INSERT INTO roles (name) VALUES 
    ('ROLE_ADMIN'),
    ('ROLE_NUTRIOLOGO'),
    ('ROLE_PACIENTE');

-- ============================================================================
-- DATOS INICIALES - USUARIOS DE PRUEBA
-- ============================================================================

-- Usuario Administrador
-- Password: admin123 (encriptado con BCrypt)
INSERT INTO users (username, email, password, first_name, last_name, created_at, updated_at) 
VALUES (
    'admin',
    'admin@nutritrack.com',
    '$2a$10$nLtb1k0rCwZ5VEp8oqGJUuKdY6gYdHB8wYTqx1WGZz8qQqEWLqN7W',
    'Administrador',
    'Sistema',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Usuario Nutriólogo
-- Password: nutri123 (encriptado con BCrypt)
INSERT INTO users (username, email, password, first_name, last_name, phone, address, degree, university, professional_license, created_at, updated_at) 
VALUES (
    'nutriologo',
    'nutriologo@nutritrack.com',
    '$2a$10$2ZqZsrU5LQAZdpXqRUJXneS8X.NvqG6yGjEJG5TpV8ZnP7F9B1Y7m',
    'María',
    'González',
    '5512345678',
    'Av. Reforma 123, CDMX',
    'Licenciatura en Nutrición',
    'Universidad Nacional Autónoma de México',
    '1234567',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Usuario Paciente
-- Password: paciente123 (encriptado con BCrypt)
INSERT INTO users (username, email, password, first_name, last_name, created_at, updated_at) 
VALUES (
    'paciente',
    'paciente@nutritrack.com',
    '$2a$10$EWvQf8wI5YzLqZ3RkDKYkeG6OUFrXwZGqYPtZMQx8F5PnHzZ9BgNS',
    'Juan',
    'Pérez',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- DATOS INICIALES - ASIGNACIÓN DE ROLES
-- ============================================================================

-- Rol de Administrador
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';

-- Rol de Nutriólogo
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'nutriologo' AND r.name = 'ROLE_NUTRIOLOGO';

-- Rol de Paciente
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'paciente' AND r.name = 'ROLE_PACIENTE';

-- ============================================================================
-- DATOS INICIALES - PACIENTE DE EJEMPLO
-- ============================================================================

INSERT INTO patients (
    user_id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender, 
    height, 
    current_weight, 
    activity_level,
    email,
    phone,
    created_at,
    updated_at
) 
SELECT 
    u.id,
    'Juan',
    'Pérez',
    '1990-05-15',
    'Masculino',
    175.00,
    80.00,
    'Moderado',
    'paciente@nutritrack.com',
    '5598765432',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM users u 
WHERE u.username = 'paciente';

-- ============================================================================
-- DATOS INICIALES - ALIMENTOS DE EJEMPLO
-- ============================================================================

INSERT INTO foods (name, category, serving_size, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, description) VALUES
    ('Pechuga de pollo', 'Carnes', '100g', 165, 31.0, 0.0, 3.6, 0.0, 'Pechuga de pollo sin piel cocida'),
    ('Arroz integral', 'Cereales', '100g', 111, 2.6, 23.0, 0.9, 1.8, 'Arroz integral cocido'),
    ('Brócoli', 'Verduras', '100g', 34, 2.8, 7.0, 0.4, 2.6, 'Brócoli cocido al vapor'),
    ('Aguacate', 'Frutas', '100g', 160, 2.0, 8.5, 14.7, 6.7, 'Aguacate fresco tipo Hass'),
    ('Huevo', 'Proteínas', '1 pieza', 78, 6.3, 0.6, 5.3, 0.0, 'Huevo entero cocido'),
    ('Avena', 'Cereales', '1 taza', 307, 10.7, 54.8, 5.3, 8.2, 'Avena en hojuelas cruda'),
    ('Plátano', 'Frutas', '1 pieza', 105, 1.3, 27.0, 0.4, 3.1, 'Plátano mediano fresco'),
    ('Almendras', 'Frutos secos', '30g', 164, 6.0, 6.1, 14.2, 3.5, 'Almendras naturales'),
    ('Salmón', 'Pescados', '100g', 208, 20.4, 0.0, 13.4, 0.0, 'Salmón cocido al horno'),
    ('Espinaca', 'Verduras', '100g', 23, 2.9, 3.6, 0.4, 2.2, 'Espinaca fresca'),
    ('Yogurt natural', 'Lácteos', '1 taza', 149, 8.5, 11.4, 8.0, 0.0, 'Yogurt natural sin azúcar'),
    ('Lentejas', 'Legumbres', '100g', 116, 9.0, 20.1, 0.4, 7.9, 'Lentejas cocidas'),
    ('Manzana', 'Frutas', '1 pieza', 95, 0.5, 25.0, 0.3, 4.4, 'Manzana mediana con cáscara'),
    ('Pasta integral', 'Cereales', '100g', 124, 5.3, 26.5, 0.5, 3.5, 'Pasta integral cocida'),
    ('Pechuga de pavo', 'Carnes', '100g', 135, 30.0, 0.0, 0.7, 0.0, 'Pechuga de pavo sin piel');

-- ============================================================================
-- VISTAS ÚTILES DEL SISTEMA
-- ============================================================================

-- Vista: Información completa de pacientes con sus usuarios
CREATE OR REPLACE VIEW v_patients_full AS
SELECT 
    p.id AS patient_id,
    p.first_name,
    p.last_name,
    p.date_of_birth,
    p.gender,
    p.height,
    p.current_weight,
    p.activity_level,
    p.email,
    p.phone,
    u.username,
    u.email AS user_email,
    p.created_at
FROM patients p
LEFT JOIN users u ON p.user_id = u.id;

-- Vista: Planes dietéticos activos con información del paciente y nutriólogo
CREATE OR REPLACE VIEW v_active_diet_plans AS
SELECT 
    dp.id AS plan_id,
    dp.plan_name,
    dp.start_date,
    dp.end_date,
    dp.daily_calories,
    dp.status,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    n.first_name AS nutritionist_first_name,
    n.last_name AS nutritionist_last_name,
    dp.created_at
FROM diet_plans dp
INNER JOIN patients p ON dp.patient_id = p.id
INNER JOIN users n ON dp.nutritionist_id = n.id
WHERE dp.status = 'ACTIVE';

-- Vista: Citas programadas próximas (siguientes 7 días)
CREATE OR REPLACE VIEW v_upcoming_appointments AS
SELECT 
    a.id AS appointment_id,
    a.appointment_date,
    a.duration_minutes,
    a.appointment_type,
    a.status,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    n.first_name AS nutritionist_first_name,
    n.last_name AS nutritionist_last_name
FROM appointments a
INNER JOIN patients p ON a.patient_id = p.id
INNER JOIN users n ON a.nutritionist_id = n.id
WHERE a.appointment_date >= CURRENT_TIMESTAMP 
  AND a.appointment_date <= DATEADD('DAY', 7, CURRENT_TIMESTAMP)
  AND a.status = 'PROGRAMADA'
ORDER BY a.appointment_date;

-- Vista: Historial de peso de pacientes (últimos 30 días)
CREATE OR REPLACE VIEW v_recent_weight_entries AS
SELECT 
    we.id AS entry_id,
    we.patient_id,
    p.first_name,
    p.last_name,
    we.weight,
    we.entry_date,
    we.notes,
    we.created_at
FROM weight_entries we
INNER JOIN patients p ON we.patient_id = p.id
WHERE we.entry_date >= DATEADD('DAY', -30, CURRENT_DATE)
ORDER BY we.entry_date DESC;

-- ============================================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================================

-- Función: Calcular IMC (Índice de Masa Corporal)
CREATE ALIAS IF NOT EXISTS calculate_bmi AS $$
    double calculateBMI(double weight, double height) {
        if (height <= 0) return 0;
        double heightInMeters = height / 100.0;
        return weight / (heightInMeters * heightInMeters);
    }
$$;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Trigger: Actualizar peso actual del paciente al registrar nuevo peso
CREATE TRIGGER trg_update_patient_weight
AFTER INSERT ON weight_entries
FOR EACH ROW
CALL "UPDATE patients SET current_weight = NEW.weight WHERE id = NEW.patient_id";

-- ============================================================================
-- ESTADÍSTICAS Y VERIFICACIÓN
-- ============================================================================

-- Mostrar conteo de registros en cada tabla
SELECT 'users' AS tabla, COUNT(*) AS registros FROM users
UNION ALL
SELECT 'roles' AS tabla, COUNT(*) AS registros FROM roles
UNION ALL
SELECT 'user_roles' AS tabla, COUNT(*) AS registros FROM user_roles
UNION ALL
SELECT 'patients' AS tabla, COUNT(*) AS registros FROM patients
UNION ALL
SELECT 'foods' AS tabla, COUNT(*) AS registros FROM foods
UNION ALL
SELECT 'diet_plans' AS tabla, COUNT(*) AS registros FROM diet_plans
UNION ALL
SELECT 'diet_meals' AS tabla, COUNT(*) AS registros FROM diet_meals
UNION ALL
SELECT 'weight_entries' AS tabla, COUNT(*) AS registros FROM weight_entries
UNION ALL
SELECT 'appointments' AS tabla, COUNT(*) AS registros FROM appointments;

-- ============================================================================
-- PERMISOS Y SEGURIDAD (Opcional - Si se usa autenticación de BD)
-- ============================================================================

-- Crear usuario de aplicación (solo si H2 permite gestión de usuarios)
-- CREATE USER IF NOT EXISTS nutritrack_app PASSWORD 'nutritrack_secure_2024';

-- Otorgar permisos
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO nutritrack_app;
-- GRANT EXECUTE ON ALL FUNCTIONS TO nutritrack_app;

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

-- Mensaje de confirmación
SELECT 'Script de creación de base de datos ejecutado exitosamente' AS mensaje,
       CURRENT_TIMESTAMP AS fecha_ejecucion;
