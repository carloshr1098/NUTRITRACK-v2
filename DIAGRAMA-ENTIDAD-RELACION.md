# Diagrama Entidad-Relación (DER) - Sistema NutriTrack

## Modelo Conceptual del Sistema de Gestión Nutricional

### Notación Utilizada
- **PK**: Primary Key (Clave Primaria)
- **FK**: Foreign Key (Clave Foránea)
- **UQ**: Unique Constraint (Restricción de Unicidad)
- **NN**: Not Null (No Nulo)
- **1:1**: Relación Uno a Uno
- **1:N**: Relación Uno a Muchos
- **N:M**: Relación Muchos a Muchos

---

## Entidades del Sistema

### 1. USERS (Usuarios)
Almacena la información de todos los usuarios del sistema (administradores, nutriólogos y pacientes).

```
USERS
├── id (PK, NN, AUTO_INCREMENT)
├── username (UQ, NN, VARCHAR(20))
├── email (UQ, NN, VARCHAR(50))
├── password (NN, VARCHAR(120))
├── first_name (VARCHAR(50))
├── last_name (VARCHAR(50))
├── phone (VARCHAR(20))
├── address (VARCHAR(200))
├── degree (VARCHAR(100))
├── university (VARCHAR(200))
├── professional_license (VARCHAR(50))
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- username: Único en el sistema
- email: Único, formato de correo electrónico válido
- password: Encriptado con BCrypt

**Índices:**
- idx_users_username ON username
- idx_users_email ON email

---

### 2. ROLES (Roles de Usuario)
Define los roles disponibles en el sistema para control de acceso.

```
ROLES
├── id (PK, NN, AUTO_INCREMENT)
└── name (NN, VARCHAR(20), CHECK: 'ROLE_ADMIN', 'ROLE_NUTRIOLOGO', 'ROLE_PACIENTE')
```

**Restricciones:**
- name: Solo puede contener valores del enum ERole

**Índices:**
- idx_roles_name ON name

---

### 3. USER_ROLES (Tabla Intermedia - Relación N:M)
Relaciona usuarios con sus roles asignados.

```
USER_ROLES
├── user_id (PK, FK → USERS.id)
└── role_id (PK, FK → ROLES.id)
```

**Clave Primaria Compuesta:** (user_id, role_id)

**Relaciones:**
- user_id → USERS.id (ON DELETE CASCADE)
- role_id → ROLES.id (ON DELETE CASCADE)

**Índices:**
- idx_user_roles_user ON user_id
- idx_user_roles_role ON role_id

---

### 4. PATIENTS (Pacientes)
Información médica y personal de los pacientes del sistema.

```
PATIENTS
├── id (PK, NN, AUTO_INCREMENT)
├── user_id (FK → USERS.id, UQ)
├── first_name (NN, VARCHAR(50))
├── last_name (NN, VARCHAR(50))
├── date_of_birth (DATE)
├── gender (VARCHAR(20))
├── height (DECIMAL(5,2), CHECK > 0)
├── current_weight (DECIMAL(5,2), CHECK > 0)
├── activity_level (VARCHAR(50))
├── medical_conditions (VARCHAR(1000))
├── allergies (VARCHAR(500))
├── dietary_restrictions (VARCHAR(500))
├── email (VARCHAR(100))
├── phone (VARCHAR(20))
├── emergency_contact_name (VARCHAR(100))
├── emergency_contact_phone (VARCHAR(20))
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- height: Debe ser mayor a 0
- current_weight: Debe ser mayor a 0
- gender: Valores típicos ('M', 'F', 'Otro')

**Índices:**
- idx_patients_user ON user_id
- idx_patients_email ON email

**Dependencias Funcionales:**
- id → {todos los atributos}
- user_id → {todos los atributos excepto id}

---

### 5. FOODS (Alimentos)
Catálogo de alimentos con información nutricional.

```
FOODS
├── id (PK, NN, AUTO_INCREMENT)
├── name (NN, VARCHAR(100))
├── category (VARCHAR(50))
├── serving_size (VARCHAR(50))
├── calories (INTEGER)
├── protein_grams (DOUBLE)
├── carbs_grams (DOUBLE)
├── fat_grams (DOUBLE)
├── fiber_grams (DOUBLE)
├── description (VARCHAR(500))
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- calories: Debe ser >= 0
- Todos los valores nutricionales en gramos deben ser >= 0

**Índices:**
- idx_foods_name ON name
- idx_foods_category ON category

---

### 6. DIET_PLANS (Planes Dietéticos)
Planes alimenticios personalizados creados por nutriólogos para pacientes.

```
DIET_PLANS
├── id (PK, NN, AUTO_INCREMENT)
├── patient_id (FK → PATIENTS.id, NN)
├── nutritionist_id (FK → USERS.id, NN)
├── plan_name (VARCHAR(200))
├── start_date (DATE)
├── end_date (DATE)
├── daily_calories (INTEGER)
├── description (VARCHAR(1000))
├── goals (VARCHAR(500))
├── status (VARCHAR(20), CHECK: 'ACTIVE', 'COMPLETED', 'PAUSED', 'CANCELLED')
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- patient_id: Debe existir en PATIENTS
- nutritionist_id: Debe existir en USERS (con rol NUTRIOLOGO)
- end_date: Debe ser mayor o igual a start_date
- status: Solo valores permitidos

**Índices:**
- idx_diet_plans_patient ON patient_id
- idx_diet_plans_nutritionist ON nutritionist_id
- idx_diet_plans_status ON status
- idx_diet_plans_dates ON (start_date, end_date)

**Dependencias Funcionales:**
- id → {todos los atributos}
- (patient_id, nutritionist_id, start_date) → {plan específico}

---

### 7. DIET_MEALS (Comidas del Plan)
Comidas individuales que componen un plan dietético.

```
DIET_MEALS
├── id (PK, NN, AUTO_INCREMENT)
├── diet_plan_id (FK → DIET_PLANS.id, NN)
├── meal_type (VARCHAR(50), CHECK: 'BREAKFAST', 'SNACK', 'LUNCH', 'DINNER')
├── meal_name (VARCHAR(200))
├── servings (INTEGER)
├── description (VARCHAR(1000))
├── calories (INTEGER)
├── protein_grams (DOUBLE)
├── carbs_grams (DOUBLE)
├── fat_grams (DOUBLE)
├── fiber_grams (DOUBLE)
├── preparation_time (INTEGER)
├── ingredients (VARCHAR(2000))
├── instructions (VARCHAR(2000))
├── notes (VARCHAR(500))
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- diet_plan_id: Debe existir en DIET_PLANS
- meal_type: Solo valores permitidos
- servings: Debe ser >= 1

**Índices:**
- idx_diet_meals_plan ON diet_plan_id
- idx_diet_meals_type ON meal_type

**Dependencias Funcionales:**
- id → {todos los atributos}
- diet_plan_id puede tener múltiples comidas

---

### 8. WEIGHT_ENTRIES (Registros de Peso)
Historial de mediciones de peso de los pacientes.

```
WEIGHT_ENTRIES
├── id (PK, NN, AUTO_INCREMENT)
├── patient_id (FK → PATIENTS.id, NN)
├── weight (DECIMAL(5,2), NN, CHECK > 0)
├── entry_date (DATE, NN)
├── notes (VARCHAR(500))
└── created_at (TIMESTAMP)
```

**Restricciones:**
- patient_id: Debe existir en PATIENTS
- weight: Debe ser mayor a 0
- entry_date: No puede ser fecha futura

**Índices:**
- idx_weight_entries_patient ON patient_id
- idx_weight_entries_date ON entry_date
- idx_weight_entries_patient_date ON (patient_id, entry_date)

**Dependencias Funcionales:**
- id → {todos los atributos}
- (patient_id, entry_date) → {registro específico del día}

---

### 9. APPOINTMENTS (Citas)
Citas programadas entre pacientes y nutriólogos.

```
APPOINTMENTS
├── id (PK, NN, AUTO_INCREMENT)
├── patient_id (FK → PATIENTS.id, NN)
├── nutritionist_id (FK → USERS.id, NN)
├── appointment_date (TIMESTAMP, NN)
├── duration_minutes (INTEGER, DEFAULT 60)
├── appointment_type (VARCHAR(50), CHECK: 'CONSULTA', 'SEGUIMIENTO', 'EMERGENCIA')
├── status (VARCHAR(20), CHECK: 'PROGRAMADA', 'COMPLETADA', 'CANCELADA', 'NO_ASISTIO', 'ATENDIDO')
├── notes (VARCHAR(1000))
├── patient_notes (VARCHAR(1000))
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Restricciones:**
- patient_id: Debe existir en PATIENTS
- nutritionist_id: Debe existir en USERS (con rol NUTRIOLOGO)
- appointment_date: No puede ser fecha pasada al momento de creación
- duration_minutes: Debe ser >= 15 y <= 240
- appointment_type, status: Solo valores permitidos

**Índices:**
- idx_appointments_patient ON patient_id
- idx_appointments_nutritionist ON nutritionist_id
- idx_appointments_date ON appointment_date
- idx_appointments_status ON status
- idx_appointments_nutri_date ON (nutritionist_id, appointment_date)

**Dependencias Funcionales:**
- id → {todos los atributos}
- (nutritionist_id, appointment_date) debe ser único (no puede tener dos citas a la misma hora)

---

## Relaciones del Sistema

### Relación N:M - USERS ↔ ROLES
**Cardinalidad:** Un usuario puede tener múltiples roles, un rol puede ser asignado a múltiples usuarios.

```
USERS (1) ←→ (N) USER_ROLES (N) ←→ (1) ROLES
```

**Implementación:**
- Tabla intermedia: USER_ROLES
- Clave primaria compuesta: (user_id, role_id)
- ON DELETE CASCADE en ambas FK

---

### Relación 1:1 - USERS → PATIENTS
**Cardinalidad:** Un usuario puede ser un paciente (o ninguno). Un paciente corresponde a exactamente un usuario.

```
USERS (1) ←→ (0..1) PATIENTS
```

**Implementación:**
- FK en PATIENTS: user_id → USERS.id
- user_id tiene restricción UNIQUE
- ON DELETE CASCADE

---

### Relación 1:N - PATIENTS → WEIGHT_ENTRIES
**Cardinalidad:** Un paciente puede tener múltiples registros de peso. Un registro pertenece a un único paciente.

```
PATIENTS (1) ←→ (N) WEIGHT_ENTRIES
```

**Implementación:**
- FK en WEIGHT_ENTRIES: patient_id → PATIENTS.id
- ON DELETE CASCADE
- Un paciente puede tener 0 o más registros

---

### Relación 1:N - PATIENTS → DIET_PLANS
**Cardinalidad:** Un paciente puede tener múltiples planes dietéticos. Un plan pertenece a un único paciente.

```
PATIENTS (1) ←→ (N) DIET_PLANS
```

**Implementación:**
- FK en DIET_PLANS: patient_id → PATIENTS.id
- ON DELETE CASCADE

---

### Relación 1:N - USERS (Nutriólogo) → DIET_PLANS
**Cardinalidad:** Un nutriólogo puede crear múltiples planes. Un plan es creado por un único nutriólogo.

```
USERS (1) ←→ (N) DIET_PLANS
```

**Implementación:**
- FK en DIET_PLANS: nutritionist_id → USERS.id
- ON DELETE RESTRICT (no se puede eliminar nutriólogo con planes activos)

---

### Relación 1:N - DIET_PLANS → DIET_MEALS
**Cardinalidad:** Un plan dietético contiene múltiples comidas. Una comida pertenece a un único plan.

```
DIET_PLANS (1) ←→ (N) DIET_MEALS
```

**Implementación:**
- FK en DIET_MEALS: diet_plan_id → DIET_PLANS.id
- ON DELETE CASCADE
- Un plan debe tener al menos 1 comida

---

### Relación 1:N - PATIENTS → APPOINTMENTS
**Cardinalidad:** Un paciente puede tener múltiples citas. Una cita pertenece a un único paciente.

```
PATIENTS (1) ←→ (N) APPOINTMENTS
```

**Implementación:**
- FK en APPOINTMENTS: patient_id → PATIENTS.id
- ON DELETE CASCADE

---

### Relación 1:N - USERS (Nutriólogo) → APPOINTMENTS
**Cardinalidad:** Un nutriólogo puede tener múltiples citas. Una cita es atendida por un único nutriólogo.

```
USERS (1) ←→ (N) APPOINTMENTS
```

**Implementación:**
- FK en APPOINTMENTS: nutritionist_id → USERS.id
- ON DELETE RESTRICT

---

## Diagrama Visual Simplificado

```
                                    ┌─────────────┐
                                    │   ROLES     │
                                    │ PK: id      │
                                    │     name    │
                                    └──────┬──────┘
                                           │
                                           │ N:M
                                           │
                    ┌──────────────────────┴──────────────────────┐
                    │          USER_ROLES (Intermedia)            │
                    │ PK,FK: user_id  → USERS.id                  │
                    │ PK,FK: role_id  → ROLES.id                  │
                    └──────────────────────┬──────────────────────┘
                                           │
                                           │ N:M
                                           │
            ┌──────────────────────────────┴──────────────────────────────┐
            │                         USERS                                │
            │ PK: id                                                       │
            │ UQ: username, email                                          │
            │     password, first_name, last_name, phone, address          │
            │     degree, university, professional_license                 │
            │     created_at, updated_at                                   │
            └────┬──────────────────────┬──────────────────────────────────┘
                 │                      │
                 │ 1:1                  │ 1:N (como Nutriólogo)
                 │                      │
                 ▼                      ▼
        ┌────────────────┐    ┌──────────────────┐
        │   PATIENTS     │    │   DIET_PLANS     │◄────┐
        │ PK: id         │    │ PK: id           │     │
        │ FK: user_id    │    │ FK: patient_id   │     │ 1:N
        │     (UNIQUE)   │───►│ FK: nutritionist │     │
        │     first_name │ 1:N│     plan_name    │     │
        │     last_name  │    │     start_date   │     │
        │     dob, gender│    │     end_date     │     │
        │     height,    │    │     daily_cal    │     │
        │     weight,    │    │     status       │     │
        │     medical    │    └────────┬─────────┘     │
        │     conditions │             │               │
        │     allergies  │             │ 1:N           │
        └────┬───────┬───┘             ▼               │
             │       │         ┌───────────────┐       │
             │       │         │  DIET_MEALS   │       │
             │       │         │ PK: id        │       │
             │       │         │ FK: diet_plan │       │
             │       │         │     meal_type │       │
             │       │         │     meal_name │       │
             │       │         │     calories  │       │
             │       │         │     proteins  │       │
             │       │         └───────────────┘       │
             │       │                                 │
             │ 1:N   │ 1:N                             │
             │       │                                 │
             ▼       ▼                                 │
    ┌─────────────┐  ┌────────────────┐               │
    │WEIGHT_ENTRIES│  │ APPOINTMENTS   │               │
    │ PK: id      │  │ PK: id         │               │
    │ FK: patient │  │ FK: patient_id │───────────────┘
    │     weight  │  │ FK: nutritionist│ 1:N
    │     date    │  │     appt_date  │
    │     notes   │  │     duration   │
    └─────────────┘  │     type       │
                     │     status     │
                     └────────────────┘

                ┌──────────────┐
                │    FOODS     │
                │ PK: id       │
                │     name     │
                │     category │
                │     calories │
                │     nutrients│
                └──────────────┘
                (Tabla de catálogo - sin relaciones directas)
```

---

## Normalización del Modelo

### Primera Forma Normal (1FN)
✓ Todos los atributos contienen valores atómicos
✓ No hay grupos repetitivos
✓ Cada columna tiene un solo valor por fila

### Segunda Forma Normal (2FN)
✓ Cumple 1FN
✓ Todos los atributos no clave dependen completamente de la clave primaria
✓ No hay dependencias parciales en claves compuestas
✓ En USER_ROLES (clave compuesta), no hay atributos adicionales

### Tercera Forma Normal (3FN)
✓ Cumple 2FN
✓ No hay dependencias transitivas
✓ Atributos no clave no dependen de otros atributos no clave
✓ Ejemplo: professional_license en USERS es independiente de otros atributos no clave

### Forma Normal de Boyce-Codd (BCNF)
✓ Cumple 3FN
✓ Toda dependencia funcional tiene como determinante una superclave
✓ No hay anomalías de actualización

---

## Consideraciones de Integridad Referencial

### Cascadas de Eliminación (ON DELETE CASCADE)
- USER_ROLES: Si se elimina un usuario o rol, se eliminan sus asignaciones
- PATIENTS: Si se elimina un usuario paciente, se elimina su registro de paciente
- WEIGHT_ENTRIES: Si se elimina un paciente, se eliminan sus registros de peso
- DIET_MEALS: Si se elimina un plan, se eliminan sus comidas
- APPOINTMENTS: Si se elimina un paciente, se cancelan sus citas

### Restricciones (ON DELETE RESTRICT)
- DIET_PLANS: No se puede eliminar un nutriólogo con planes activos
- APPOINTMENTS: No se puede eliminar un nutriólogo con citas programadas

### Validaciones de Negocio
1. Un usuario no puede tener roles duplicados
2. Una cita no puede solaparse con otra del mismo nutriólogo
3. Un plan dietético debe tener al menos una comida
4. La fecha de fin de un plan debe ser posterior a la fecha de inicio
5. El peso registrado debe estar en un rango válido (20-300 kg)
6. Las citas futuras no pueden estar en el pasado
7. Un nutriólogo solo puede crear planes para pacientes activos

---

## Estadísticas de Cardinalidad Esperada

| Entidad | Registros Estimados | Crecimiento |
|---------|-------------------|-------------|
| USERS | 100-500 | Moderado |
| ROLES | 3 (fijo) | Nulo |
| PATIENTS | 80-400 | Alto |
| FOODS | 500-2000 | Bajo |
| DIET_PLANS | 200-1000 | Alto |
| DIET_MEALS | 1000-10000 | Muy Alto |
| WEIGHT_ENTRIES | 500-5000 | Alto |
| APPOINTMENTS | 1000-5000 | Muy Alto |

---

**Fecha de Elaboración:** Noviembre 2025  
**Sistema:** NutriTrack v1.0  
**Autor:** Carlos HR  
**Curso:** Bases de Datos II
