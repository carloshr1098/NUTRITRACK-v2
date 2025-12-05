<template>
  <div class="patient-detail-container">
    <!-- Header elegante -->
    <div class="detail-header">
      <div class="header-content">
        <div class="header-icon">👤</div>
        <div class="header-text">
          <h1 class="header-title">Detalle del Paciente</h1>
          <p class="header-subtitle">Información completa y registro de peso</p>
        </div>
      </div>
    </div>

    <div class="detail-content">

    <div v-if="loading" style="text-align: center; padding: 40px;">
      <p>Cargando información del paciente...</p>
    </div>

    <div v-else-if="error" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px;">
      <strong>Error:</strong> {{ error }}
    </div>

    <div v-else-if="paciente">
      <!-- Información básica del paciente -->
      <div class="modern-card info-card">
        <div class="patient-name-header">
          <div class="patient-avatar-large">
            {{ paciente.firstName?.[0] }}{{ paciente.lastName?.[0] }}
          </div>
          <div>
            <h1 class="patient-title">
              {{ paciente.firstName }} {{ paciente.lastName }}
            </h1>
            <span class="patient-id">ID: {{ paciente.id }}</span>
          </div>
        </div>
        
        <div class="info-grid">
          <div class="info-section">
            <h3 class="section-header header-green">
              <span class="section-icon">📋</span>
              Información Personal
            </h3>
            <p style="margin: 8px 0;"><strong>ID:</strong> {{ paciente.id }}</p>
            <p style="margin: 8px 0;"><strong>Fecha de Nacimiento:</strong> {{ paciente.dateOfBirth || 'No especificada' }}</p>
            <p style="margin: 8px 0;"><strong>Edad:</strong> {{ calcularEdad(paciente.dateOfBirth) }} años</p>
            <p style="margin: 8px 0;"><strong>Género:</strong> {{ obtenerGeneroTexto(paciente.gender) }}</p>
            <p style="margin: 8px 0;"><strong>Email:</strong> {{ paciente.email || 'No especificado' }}</p>
            <p style="margin: 8px 0;"><strong>Teléfono:</strong> {{ paciente.phone || 'No especificado' }}</p>
          </div>

          <div class="info-section">
            <h3 class="section-header header-blue">
              <span class="section-icon">📏</span>
              Medidas Físicas
            </h3>
            <p style="margin: 8px 0;"><strong>Altura:</strong> {{ paciente.height ? paciente.height + ' cm' : 'No especificada' }}</p>
            <p style="margin: 8px 0;"><strong>Peso Actual:</strong> {{ paciente.currentWeight ? paciente.currentWeight + ' kg' : 'No especificado' }}</p>
            <p style="margin: 8px 0;"><strong>IMC:</strong> {{ calcularIMC(paciente.height, paciente.currentWeight) }}</p>
            <p style="margin: 8px 0;"><strong>Nivel de Actividad:</strong> {{ paciente.activityLevel || 'No especificado' }}</p>
          </div>

          <div class="info-section">
            <h3 class="section-header header-orange">
              <span class="section-icon">🏥</span>
              Información Médica
            </h3>
            <p style="margin: 8px 0;"><strong>Alergias:</strong> {{ paciente.allergies || 'Ninguna registrada' }}</p>
            <p style="margin: 8px 0;"><strong>Condiciones Médicas:</strong> {{ paciente.medicalConditions || 'Ninguna registrada' }}</p>
            <p style="margin: 8px 0;"><strong>Restricciones Dietéticas:</strong> {{ paciente.dietaryRestrictions || 'Ninguna' }}</p>
          </div>
        </div>

        <div v-if="paciente.emergencyContactName || paciente.emergencyContactPhone" class="emergency-section">
          <h3 class="section-header header-red">
            <span class="section-icon">🚨</span>
            Contacto de Emergencia
          </h3>
          <p style="margin: 8px 0;"><strong>Nombre:</strong> {{ paciente.emergencyContactName || 'No especificado' }}</p>
          <p style="margin: 8px 0;"><strong>Teléfono:</strong> {{ paciente.emergencyContactPhone || 'No especificado' }}</p>
        </div>

        <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 14px;">
          <p style="margin: 5px 0;"><strong>Registro creado:</strong> {{ formatearFecha(paciente.createdAt) }}</p>
          <p style="margin: 5px 0;"><strong>Última actualización:</strong> {{ formatearFecha(paciente.updatedAt) }}</p>
        </div>
      </div>

      <!-- Evaluación Nutricional -->
      <div class="modern-card assessment-card">
        <div class="card-header-section">
          <h2 class="card-title">
            <span class="title-icon">📋</span>
            Evaluación Nutricional
          </h2>
          <button 
            @click="toggleEvaluacionNutricional"
            class="btn-action btn-assessment"
          >
            <span>{{ mostrarEvaluacionNutricional ? '✖' : (latestAssessment ? '📝' : '➕') }}</span>
            {{ mostrarEvaluacionNutricional ? 'Cancelar' : (latestAssessment ? 'Actualizar Evaluación' : 'Nueva Evaluación') }}
          </button>
        </div>

        <!-- Resumen de la última evaluación -->
        <div v-if="!mostrarEvaluacionNutricional && latestAssessment" class="assessment-summary">
          <div class="summary-header">
            <h3 style="margin: 0 0 10px 0; color: #2c3e50;">Última Evaluación</h3>
            <p style="margin: 0; color: #666; font-size: 14px;">
              {{ formatearFecha(latestAssessment.assessmentDate) }}
            </p>
          </div>
          
          <div class="summary-grid">
            <div class="summary-item">
              <strong>IMC:</strong> {{ latestAssessment.bmi || 'N/A' }}
            </div>
            <div class="summary-item">
              <strong>Peso:</strong> {{ latestAssessment.weight ? latestAssessment.weight + ' kg' : 'N/A' }}
            </div>
            <div class="summary-item">
              <strong>% Grasa:</strong> {{ latestAssessment.bodyFatPercentage ? latestAssessment.bodyFatPercentage + '%' : 'N/A' }}
            </div>
            <div class="summary-item">
              <strong>Objetivo:</strong> {{ getWeightGoalText(latestAssessment.weightGoal) }}
            </div>
            <div class="summary-item">
              <strong>Actividad:</strong> {{ getActivityLevelText(latestAssessment.physicalActivityLevel) }}
            </div>
            <div class="summary-item">
              <strong>Comidas/día:</strong> {{ latestAssessment.mealsPerDay || 'N/A' }}
            </div>
          </div>
          
          <button 
            @click="verEvaluacionCompleta"
            class="btn-view-full"
          >
            👁️ Ver Evaluación Completa
          </button>
        </div>

        <!-- Formulario de evaluación -->
        <div v-if="mostrarEvaluacionNutricional">
          <NutritionalAssessmentForm
            :patient-id="paciente.id"
            :assessment-id="latestAssessment ? latestAssessment.id : null"
            @saved="onAssessmentSaved"
            @cancel="mostrarEvaluacionNutricional = false"
          />
        </div>

        <!-- Sin evaluaciones -->
        <div v-if="!mostrarEvaluacionNutricional && !latestAssessment && !loadingAssessments" 
             style="text-align: center; padding: 40px; color: #666;">
          <p style="font-size: 18px; margin-bottom: 10px;">📋</p>
          <p>No hay evaluaciones nutricionales registradas.</p>
          <p style="font-size: 14px; color: #999;">Crea la primera evaluación para comenzar el seguimiento.</p>
        </div>
      </div>

      <!-- Historial de Peso -->
      <div class="modern-card weight-card">
        <div class="card-header-section">
          <h2 class="card-title">
            <span class="title-icon">📊</span>
            Historial de Peso
          </h2>
          <button 
            @click="mostrarFormularioPeso = !mostrarFormularioPeso"
            class="btn-action btn-add-weight"
          >
            <span>{{ mostrarFormularioPeso ? '✖' : '➕' }}</span>
            {{ mostrarFormularioPeso ? 'Cancelar' : 'Registrar Peso' }}
          </button>
        </div>

        <!-- Formulario para registrar peso -->
        <div v-if="mostrarFormularioPeso" 
             style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; border: 2px solid #28a745;">
          <h3 style="margin: 0 0 15px 0; color: #28a745;">Nuevo Registro de Peso</h3>
          <form @submit.prevent="registrarPeso">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
              <div>
                <label style="display: block; margin-bottom: 5px; font-weight: bold;">Peso (kg) *</label>
                <input 
                  v-model.number="nuevoPeso.weight" 
                  type="number" 
                  step="0.1"
                  required
                  style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
                >
              </div>
              <div>
                <label style="display: block; margin-bottom: 5px; font-weight: bold;">Fecha *</label>
                <input 
                  v-model="nuevoPeso.recordDate" 
                  type="date" 
                  required
                  :max="new Date().toISOString().split('T')[0]"
                  style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
                >
              </div>
            </div>
            <div style="margin-bottom: 15px;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Notas (opcional)</label>
              <textarea 
                v-model="nuevoPeso.notes" 
                rows="2"
                placeholder="Ej: Después de ejercicio, en ayunas, etc."
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div style="display: flex; gap: 10px;">
              <button 
                type="submit"
                :disabled="guardandoPeso"
                style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
              >
                {{ guardandoPeso ? 'Guardando...' : '💾 Guardar Registro' }}
              </button>
              <button 
                type="button"
                @click="mostrarFormularioPeso = false"
                style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;"
              >
                Cancelar
              </button>
            </div>
            <div v-if="errorPeso" style="margin-top: 10px; padding: 10px; background: #f8d7da; color: #721c24; border-radius: 4px;">
              {{ errorPeso }}
            </div>
            <div v-if="exitoPeso" style="margin-top: 10px; padding: 10px; background: #d4edda; color: #155724; border-radius: 4px;">
              ✓ Peso registrado exitosamente
            </div>
          </form>
        </div>

        <!-- Gráfica de evolución de peso -->
        <div v-if="weightRecords && weightRecords.length > 0">
          <WeightChart ref="weightChart" :weight-records="weightRecords" />
          
          <!-- Tabla de registros -->
          <div style="margin-top: 20px; overflow-x: auto;">
            <h3 style="margin: 0 0 15px 0; color: #2c3e50;">📋 Detalle de Registros</h3>
            <table style="width: 100%; border-collapse: collapse;">
              <thead>
                <tr style="background: #f8f9fa;">
                  <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Fecha</th>
                  <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Peso (kg)</th>
                  <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Diferencia</th>
                  <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Notas</th>
                  <th style="padding: 12px; text-align: center; border-bottom: 2px solid #ddd;">Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(record, index) in weightRecords" :key="record.id" style="border-bottom: 1px solid #eee;">
                  <td style="padding: 12px;">{{ formatearFecha(record.recordDate) }}</td>
                  <td style="padding: 12px; font-weight: bold;">{{ record.weight }} kg</td>
                  <td style="padding: 12px;">
                    <span v-if="index > 0" :style="{ color: calcularDiferenciaPeso(record.weight, weightRecords[index-1].weight) >= 0 ? '#dc3545' : '#28a745' }">
                      {{ calcularDiferenciaPeso(record.weight, weightRecords[index-1].weight) >= 0 ? '▲' : '▼' }}
                      {{ Math.abs(calcularDiferenciaPeso(record.weight, weightRecords[index-1].weight)).toFixed(1) }} kg
                    </span>
                    <span v-else>-</span>
                  </td>
                  <td style="padding: 12px;">{{ record.notes || '-' }}</td>
                  <td style="padding: 12px; text-align: center;">
                    <button 
                      @click="eliminarRegistroPeso(record.id)"
                      style="padding: 5px 10px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;"
                      title="Eliminar registro"
                    >
                      🗑️
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div v-else style="text-align: center; padding: 20px; color: #666;">
          No hay registros de peso aún. Haz clic en "Registrar Peso" para agregar el primero.
        </div>
      </div>

      <!-- Citas -->
      <div style="background: white; border: 1px solid #ddd; border-radius: 8px; padding: 25px; margin-bottom: 20px;">
        <h2 style="margin: 0 0 20px 0; color: #2c3e50;">📅 Citas</h2>
        
        <div v-if="paciente.appointments && paciente.appointments.length > 0">
          <div v-for="appointment in paciente.appointments" :key="appointment.id" 
               style="border: 1px solid #eee; border-radius: 4px; padding: 15px; margin-bottom: 10px;">
            <p style="margin: 5px 0;"><strong>Fecha:</strong> {{ formatearFecha(appointment.appointmentDate) }}</p>
            <p style="margin: 5px 0;"><strong>Hora:</strong> {{ formatearHora(appointment.appointmentDate) }}</p>
            <p style="margin: 5px 0;"><strong>Tipo:</strong> {{ traducirTipoCita(appointment.appointmentType) }}</p>
            <p style="margin: 5px 0;"><strong>Estado:</strong> {{ traducirEstado(appointment.status) }}</p>
            <p v-if="appointment.notes" style="margin: 5px 0;"><strong>Notas:</strong> {{ appointment.notes }}</p>
          </div>
        </div>
        <div v-else style="text-align: center; padding: 20px; color: #666;">
          No hay citas programadas.
        </div>
      </div>

      <!-- Planes Dietéticos -->
      <div style="background: white; border: 1px solid #ddd; border-radius: 8px; padding: 25px; margin-bottom: 20px;">
        <h2 style="margin: 0 0 20px 0; color: #2c3e50;">🥗 Planes Dietéticos</h2>
        
        <div v-if="paciente.dietPlans && paciente.dietPlans.length > 0">
          <div v-for="plan in paciente.dietPlans" :key="plan.id" 
               style="border: 1px solid #eee; border-radius: 4px; padding: 15px; margin-bottom: 10px;">
            <h4 style="margin: 0 0 10px 0; color: #007bff;">{{ plan.name }}</h4>
            <p style="margin: 5px 0;"><strong>Inicio:</strong> {{ formatearFecha(plan.startDate) }}</p>
            <p style="margin: 5px 0;"><strong>Fin:</strong> {{ formatearFecha(plan.endDate) }}</p>
            <p style="margin: 5px 0;"><strong>Calorías diarias:</strong> {{ plan.dailyCalories || 'No especificadas' }}</p>
            <p v-if="plan.description" style="margin: 5px 0;"><strong>Descripción:</strong> {{ plan.description }}</p>
          </div>
        </div>
        <div v-else style="text-align: center; padding: 20px; color: #666;">
          No hay planes dietéticos asignados.
        </div>
      </div>

      <!-- Botones de acción -->
      <div style="display: flex; gap: 10px; justify-content: center; margin-top: 30px;">
        <button 
          @click="generarFichaPDF"
          style="padding: 12px 24px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;"
        >
          📄 Imprimir Ficha
        </button>
        <button 
          @click="abrirModalEdicion"
          style="padding: 12px 24px; background: #ffc107; color: #000; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;"
        >
          ✏️ Editar Paciente
        </button>
        <button 
          @click="$router.push('/nutriologo/pacientes')"
          style="padding: 12px 24px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;"
        >
          ← Volver a Lista
        </button>
      </div>
    </div>

    <!-- Modal de edición moderno -->
    <div v-if="mostrarModalEdicion" 
         class="modal-overlay"
         @click.self="cerrarModalEdicion">
      <div class="modal-edit-content">
        <div class="modal-edit-header">
          <div class="modal-header-icon">✏️</div>
          <div>
            <h2 class="modal-edit-title">Editar Información del Paciente</h2>
            <p class="modal-edit-subtitle">Actualiza los datos del paciente</p>
          </div>
          <button 
            type="button"
            @click="cerrarModalEdicion"
            class="modal-close-btn"
            title="Cerrar"
          >
            ✖
          </button>
        </div>
        
        <form @submit.prevent="actualizarPaciente" class="modal-edit-form">
          <!-- Sección: Información Personal -->
          <div class="form-section">
            <div class="form-section-header">
              <span class="form-section-icon">📋</span>
              <h3 class="form-section-title">Información Personal</h3>
            </div>
            <div class="form-grid">
              <div class="form-field">
                <label class="form-label">Nombre *</label>
                <input 
                  v-model="formEdicion.firstName" 
                  type="text" 
                  required
                  class="form-input"
                  placeholder="Ingresa el nombre"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Apellido *</label>
                <input 
                  v-model="formEdicion.lastName" 
                  type="text" 
                  required
                  class="form-input"
                  placeholder="Ingresa el apellido"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Fecha de Nacimiento *</label>
                <input 
                  v-model="formEdicion.dateOfBirth" 
                  type="date" 
                  required
                  class="form-input"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Género *</label>
                <select 
                  v-model="formEdicion.gender" 
                  required
                  class="form-input"
                >
                  <option value="">Seleccionar...</option>
                  <option value="M">Masculino</option>
                  <option value="F">Femenino</option>
                  <option value="O">Otro</option>
                </select>
              </div>
              <div class="form-field">
                <label class="form-label">Email</label>
                <input 
                  v-model="formEdicion.email" 
                  type="email" 
                  class="form-input"
                  placeholder="correo@ejemplo.com"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Teléfono</label>
                <input 
                  v-model="formEdicion.phone" 
                  type="tel" 
                  class="form-input"
                  placeholder="55 1234 5678"
                >
              </div>
            </div>
          </div>

          <!-- Sección: Medidas Físicas -->
          <div class="form-section">
            <div class="form-section-header">
              <span class="form-section-icon">📏</span>
              <h3 class="form-section-title">Medidas Físicas</h3>
            </div>
            <div class="form-grid">
              <div class="form-field">
                <label class="form-label">Altura (cm) *</label>
                <input 
                  v-model.number="formEdicion.height" 
                  type="number" 
                  step="0.01"
                  required
                  class="form-input"
                  placeholder="175"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Peso Actual (kg) *</label>
                <input 
                  v-model.number="formEdicion.currentWeight" 
                  type="number" 
                  step="0.01"
                  required
                  class="form-input"
                  placeholder="70"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Nivel de Actividad</label>
                <select 
                  v-model="formEdicion.activityLevel" 
                  class="form-input"
                >
                  <option value="">Seleccionar...</option>
                  <option value="SEDENTARIO">Sedentario</option>
                  <option value="LIGERO">Actividad Ligera</option>
                  <option value="MODERADO">Actividad Moderada</option>
                  <option value="ACTIVO">Activo</option>
                  <option value="MUY_ACTIVO">Muy Activo</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Sección: Información Médica -->
          <div class="form-section">
            <div class="form-section-header">
              <span class="form-section-icon">🏥</span>
              <h3 class="form-section-title">Información Médica</h3>
            </div>
            <div class="form-grid-full">
              <div class="form-field">
                <label class="form-label">Objetivos de Salud *</label>
                <select 
                  v-model="formEdicion.healthGoal" 
                  required
                  class="form-input"
                >
                  <option value="">Seleccionar objetivo...</option>
                  <option value="PERDER_PESO">Perder Peso</option>
                  <option value="GANAR_MASA_MUSCULAR">Ganar Masa Muscular</option>
                  <option value="MANTENER_PESO">Mantener Peso</option>
                  <option value="MEJORAR_SALUD">Mejorar Salud General</option>
                  <option value="CONTROL_DIABETES">Control de Diabetes</option>
                  <option value="REDUCIR_COLESTEROL">Reducir Colesterol</option>
                  <option value="DEPORTIVO">Rendimiento Deportivo</option>
                  <option value="OTRO">Otro</option>
                </select>
              </div>
              <div class="form-field">
                <label class="form-label">Condiciones Médicas</label>
                <textarea 
                  v-model="formEdicion.medicalConditions" 
                  rows="3"
                  class="form-input"
                  placeholder="Ej: Diabetes tipo 2, hipertensión..."
                ></textarea>
              </div>
              <div class="form-field">
                <label class="form-label">Alergias</label>
                <textarea 
                  v-model="formEdicion.allergies" 
                  rows="2"
                  class="form-input"
                  placeholder="Ej: Nueces, mariscos, lactosa..."
                ></textarea>
              </div>
              <div class="form-field">
                <label class="form-label">Restricciones Dietéticas</label>
                <textarea 
                  v-model="formEdicion.dietaryRestrictions" 
                  rows="2"
                  class="form-input"
                  placeholder="Ej: Vegetariano, bajo en sodio..."
                ></textarea>
              </div>
            </div>
          </div>

          <!-- Sección: Contacto de Emergencia -->
          <div class="form-section">
            <div class="form-section-header">
              <span class="form-section-icon">🚨</span>
              <h3 class="form-section-title">Contacto de Emergencia</h3>
            </div>
            <div class="form-grid">
              <div class="form-field">
                <label class="form-label">Nombre del Contacto</label>
                <input 
                  v-model="formEdicion.emergencyContactName" 
                  type="text" 
                  class="form-input"
                  placeholder="Nombre completo"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Teléfono del Contacto</label>
                <input 
                  v-model="formEdicion.emergencyContactPhone" 
                  type="tel" 
                  class="form-input"
                  placeholder="55 1234 5678"
                >
              </div>
            </div>
          </div>
          
          <div v-if="errorEdicion" class="alert-error">
            <strong>⚠️ Error:</strong> {{ errorEdicion }}
          </div>
          
          <div v-if="exitoEdicion" class="alert-success">
            <strong>✓ ¡Éxito!</strong> Paciente actualizado correctamente.
          </div>
          
          <div class="modal-edit-actions">
            <button 
              type="button"
              @click="cerrarModalEdicion" 
              class="btn-modal-cancel"
            >
              Cancelar
            </button>
            <button 
              type="submit"
              :disabled="guardando"
              class="btn-modal-submit"
            >
              <span v-if="guardando">⏳ Guardando...</span>
              <span v-else>💾 Actualizar Paciente</span>
            </button>
          </div>
        </form>
      </div>
    </div>
    
    <!-- Botón de volver -->
    <div class="back-button-container">
      <router-link to="/nutriologo/pacientes" class="btn-back">
        <span class="btn-icon">←</span>
        Volver a Pacientes
      </router-link>
    </div>
    </div>
  </div>
</template>

<script>
import api from '../../services/api.js'
import jsPDF from 'jspdf'
import { generarEncabezadoPDF } from '../../services/pdfService.js'
import WeightChart from '../../components/WeightChart.vue'
import NutritionalAssessmentForm from '../../components/NutritionalAssessmentForm.vue'

export default {
  name: 'PatientDetailView',
  components: {
    WeightChart,
    NutritionalAssessmentForm
  },
  data() {
    return {
      paciente: null,
      loading: false,
      error: null,
      mostrarModalEdicion: false,
      guardando: false,
      errorEdicion: null,
      exitoEdicion: false,
      weightRecords: [],
      mostrarFormularioPeso: false,
      guardandoPeso: false,
      errorPeso: null,
      exitoPeso: false,
      nuevoPeso: {
        weight: null,
        recordDate: new Date().toISOString().split('T')[0],
        notes: ''
      },
      mostrarEvaluacionNutricional: false,
      assessments: [],
      latestAssessment: null,
      loadingAssessments: false,
      formEdicion: {
        firstName: '',
        lastName: '',
        dateOfBirth: '',
        gender: '',
        height: null,
        currentWeight: null,
        email: '',
        phone: '',
        activityLevel: '',
        healthGoal: '',
        medicalConditions: '',
        allergies: '',
        dietaryRestrictions: '',
        emergencyContactName: '',
        emergencyContactPhone: ''
      }
    }
  },
  mounted() {
    this.cargarPaciente()
    this.cargarRegistrosPeso()
    this.cargarEvaluaciones()
  },
  methods: {
    async cargarLogo() {
      const rutasLogo = [
        '/logo/nutritrack-logo.png',
        '/logo/logos_tampeq/nutritrack-logo.png'
      ]
      
      for (const ruta of rutasLogo) {
        try {
          const response = await fetch(ruta)
          if (response.ok) {
            const blob = await response.blob()
            return new Promise((resolve, reject) => {
              const reader = new FileReader()
              reader.onloadend = () => resolve(reader.result)
              reader.onerror = reject
              reader.readAsDataURL(blob)
            })
          }
        } catch (error) {
          console.warn(`No se pudo cargar logo desde ${ruta}`)
        }
      }
      return null
    },
    
    async cargarPaciente() {
      try {
        this.loading = true
        this.error = null
        
        const pacienteId = this.$route.params.id
        console.log('Cargando paciente con ID:', pacienteId)
        
        const response = await api.get(`/pacientes/${pacienteId}`)
        console.log('Paciente cargado:', response.data)
        
        this.paciente = response.data
      } catch (error) {
        console.error('Error cargando paciente:', error)
        this.error = error.response?.data?.message || error.message || 'Error al cargar paciente'
      } finally {
        this.loading = false
      }
    },
    
    calcularEdad(fechaNacimiento) {
      if (!fechaNacimiento) return 'N/A'
      
      const hoy = new Date()
      const nacimiento = new Date(fechaNacimiento)
      let edad = hoy.getFullYear() - nacimiento.getFullYear()
      const mes = hoy.getMonth() - nacimiento.getMonth()
      
      if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
        edad--
      }
      
      return edad
    },
    
    calcularIMC(altura, peso) {
      if (!altura || !peso) return 'N/A'
      
      const alturaM = altura / 100
      const imc = (peso / (alturaM * alturaM)).toFixed(2)
      
      let categoria = ''
      if (imc < 18.5) categoria = '(Bajo peso)'
      else if (imc < 25) categoria = '(Normal)'
      else if (imc < 30) categoria = '(Sobrepeso)'
      else categoria = '(Obesidad)'
      
      return `${imc} ${categoria}`
    },
    
    obtenerGeneroTexto(genero) {
      const generos = {
        'M': 'Masculino',
        'F': 'Femenino',
        'O': 'Otro'
      }
      return generos[genero] || genero || 'No especificado'
    },
    
    formatearFecha(fecha) {
      if (!fecha) return 'N/A'
      
      try {
        const date = new Date(fecha)
        return date.toLocaleDateString('es-ES', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        })
      } catch (e) {
        return fecha
      }
    },

    formatearHora(fecha) {
      if (!fecha) return 'N/A'
      try {
        const date = new Date(fecha)
        return date.toLocaleTimeString('es-ES', {
          hour: '2-digit',
          minute: '2-digit'
        })
      } catch (e) {
        return 'N/A'
      }
    },

    traducirTipoCita(tipo) {
      const traducciones = {
        'CONSULTATION': 'Consulta',
        'FOLLOW_UP': 'Seguimiento',
        'EMERGENCY': 'Emergencia'
      }
      return traducciones[tipo] || tipo
    },

    traducirEstado(status) {
      const traducciones = {
        'SCHEDULED': 'Programada',
        'CONFIRMED': 'Confirmada',
        'COMPLETED': 'Completada',
        'CANCELLED': 'Cancelada',
        'NO_SHOW': 'No asistió',
        'ATENDIDO': 'Atendida'
      }
      return traducciones[status] || status
    },
    
    abrirModalEdicion() {
      // Cargar datos del paciente en el formulario de edición
      this.formEdicion = {
        firstName: this.paciente.firstName || '',
        lastName: this.paciente.lastName || '',
        dateOfBirth: this.paciente.dateOfBirth || '',
        gender: this.paciente.gender || '',
        height: this.paciente.height || null,
        currentWeight: this.paciente.currentWeight || null,
        email: this.paciente.email || '',
        phone: this.paciente.phone || '',
        activityLevel: this.paciente.activityLevel || '',
        healthGoal: this.paciente.healthGoal || '',
        medicalConditions: this.paciente.medicalConditions || '',
        allergies: this.paciente.allergies || '',
        dietaryRestrictions: this.paciente.dietaryRestrictions || '',
        emergencyContactName: this.paciente.emergencyContactName || '',
        emergencyContactPhone: this.paciente.emergencyContactPhone || ''
      }
      this.mostrarModalEdicion = true
      this.errorEdicion = null
      this.exitoEdicion = false
    },
    
    cerrarModalEdicion() {
      this.mostrarModalEdicion = false
      this.errorEdicion = null
      this.exitoEdicion = false
    },
    
    async actualizarPaciente() {
      try {
        this.guardando = true
        this.errorEdicion = null
        this.exitoEdicion = false
        
        console.log('Actualizando paciente:', this.formEdicion)
        const response = await api.put(`/pacientes/${this.paciente.id}`, this.formEdicion)
        console.log('Paciente actualizado:', response.data)
        
        this.exitoEdicion = true
        
        // Recargar datos del paciente después de 1.5 segundos
        setTimeout(() => {
          this.cargarPaciente()
          this.cerrarModalEdicion()
        }, 1500)
        
      } catch (error) {
        console.error('Error actualizando paciente:', error)
        this.errorEdicion = error.response?.data?.message || error.message || 'Error al actualizar paciente'
      } finally {
        this.guardando = false
      }
    },
    
    async generarFichaPDF() {
      try {
        const doc = new jsPDF()
        
        // ==================== ENCABEZADO ESTANDARIZADO ====================
        const userStr = localStorage.getItem('user')
        const nutricionistaInfo = userStr ? JSON.parse(userStr) : null
        
        await generarEncabezadoPDF(doc, 'Expediente Médico del Paciente', nutricionistaInfo)
        
        let y = 52
        
        // ==================== INFORMACIÓN PERSONAL ====================
        // Caja compacta con borde y fondo
        doc.setFillColor(245, 245, 245) // Gris claro
        doc.setDrawColor(76, 175, 80) // Verde
        doc.setLineWidth(0.4)
        doc.roundedRect(15, y, 180, 40, 2, 2, 'FD')
        
        // Título de sección compacto
        y += 5
        doc.setFontSize(10)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(76, 175, 80)
        doc.text('INFORMACION PERSONAL', 20, y)
        
        y += 5
        doc.setFontSize(7.5)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        // Dividir en dos columnas compactas
        const col1X = 20
        const col2X = 110
        let yTemp = y
        
        // Columna 1
        doc.setFont('helvetica', 'bold')
        doc.text('ID:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(String(this.paciente.id), col1X + 18, yTemp)
        yTemp += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('Nombre:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.firstName} ${this.paciente.lastName}`, col1X + 18, yTemp)
        yTemp += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('Fecha Nac.:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(this.formatearFecha(this.paciente.dateOfBirth), col1X + 18, yTemp)
        yTemp += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('Edad:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.calcularEdad(this.paciente.dateOfBirth)} años`, col1X + 18, yTemp)
        yTemp += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('Género:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(this.paciente.gender === 'M' ? 'Masculino' : this.paciente.gender === 'F' ? 'Femenino' : 'Otro', col1X + 18, yTemp)
        
        // Columna 2
        yTemp = y
        if (this.paciente.email) {
          doc.setFont('helvetica', 'bold')
          doc.text('Email:', col2X, yTemp)
          doc.setFont('helvetica', 'normal')
          doc.text(this.paciente.email.substring(0, 30), col2X + 13, yTemp)
          yTemp += 4
        }
        
        if (this.paciente.phone) {
          doc.setFont('helvetica', 'bold')
          doc.text('Teléfono:', col2X, yTemp)
          doc.setFont('helvetica', 'normal')
          doc.text(this.paciente.phone, col2X + 13, yTemp)
          yTemp += 4
        }
        
        y += 36
        
        // ==================== FILA DE 3 COLUMNAS: MEDIDAS + EMERGENCIA + OBJETIVO ====================
        const yFilaInicio = y
        
        // COLUMNA 1: MEDIDAS FÍSICAS
        doc.setFillColor(232, 245, 233) // Verde muy claro
        doc.setDrawColor(76, 175, 80)
        doc.setLineWidth(0.4)
        doc.roundedRect(15, y, 58, 27, 2, 2, 'FD')
        
        y += 5
        doc.setFontSize(9)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(76, 175, 80)
        doc.text('MEDIDAS FISICAS', 17, y)
        
        y += 4.5
        doc.setFontSize(7.5)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        doc.setFont('helvetica', 'bold')
        doc.text('Altura:', 17, y)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.height} cm`, 30, y)
        y += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('Peso:', 17, y)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.currentWeight} kg`, 30, y)
        y += 4
        
        doc.setFont('helvetica', 'bold')
        doc.text('IMC:', 17, y)
        doc.setFont('helvetica', 'normal')
        const imc = this.calcularIMC()
        doc.text(imc, 30, y)
        y += 4
        
        const niveles = {
          'SEDENTARY': 'Sedentario',
          'LIGHTLY_ACTIVE': 'Lig. Activo',
          'MODERATELY_ACTIVE': 'Mod. Activo',
          'VERY_ACTIVE': 'Muy Activo',
          'EXTRA_ACTIVE': 'Extra Activo'
        }
        doc.setFont('helvetica', 'bold')
        doc.text('Actividad:', 17, y)
        doc.setFont('helvetica', 'normal')
        const actividadTexto = niveles[this.paciente.activityLevel] || this.paciente.activityLevel
        doc.text(actividadTexto.substring(0, 11), 30, y)
        
        // COLUMNA 2: CONTACTO DE EMERGENCIA
        y = yFilaInicio
        if (this.paciente.emergencyContactName || this.paciente.emergencyContactPhone) {
          doc.setFillColor(255, 243, 224) // Naranja muy claro
          doc.setDrawColor(255, 152, 0) // Naranja
          doc.setLineWidth(0.4)
          doc.roundedRect(78, y, 58, 27, 2, 2, 'FD')
          
          y += 5
          doc.setFontSize(9)
          doc.setFont('helvetica', 'bold')
          doc.setTextColor(255, 152, 0)
          doc.text('EMERGENCIA', 80, y)
          
          y += 4.5
          doc.setFontSize(7)
          doc.setFont('helvetica', 'normal')
          doc.setTextColor(60, 60, 60)
          
          if (this.paciente.emergencyContactName) {
            doc.setFont('helvetica', 'bold')
            doc.text('Contacto:', 80, y)
            doc.setFont('helvetica', 'normal')
            // Dividir en múltiples líneas si es necesario
            const nombreLineas = doc.splitTextToSize(this.paciente.emergencyContactName, 52)
            doc.text(nombreLineas, 80, y + 3.5)
            y += 3.5 + (nombreLineas.length * 3.5) + 0.5
          }
          
          if (this.paciente.emergencyContactPhone) {
            doc.setFont('helvetica', 'bold')
            doc.text('Teléfono:', 80, y)
            doc.setFont('helvetica', 'normal')
            doc.text(this.paciente.emergencyContactPhone, 80, y + 3.5)
          }
        }
        
        // COLUMNA 3: OBJETIVO/META
        y = yFilaInicio
        doc.setFillColor(227, 242, 253) // Azul muy claro
        doc.setDrawColor(33, 150, 243) // Azul
        doc.setLineWidth(0.4)
        doc.roundedRect(141, y, 54, 27, 2, 2, 'FD')
        
        y += 5
        doc.setFontSize(9)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(33, 150, 243)
        doc.text('OBJETIVO', 143, y)
        
        y += 4.5
        doc.setFontSize(7.5)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        const objetivos = {
          'LOSE_WEIGHT': 'Bajar peso',
          'MAINTAIN_WEIGHT': 'Mantener',
          'GAIN_WEIGHT': 'Subir peso',
          'GAIN_MUSCLE': 'Ganar músculo'
        }
        
        doc.setFont('helvetica', 'bold')
        doc.text('Meta:', 143, y)
        doc.setFont('helvetica', 'normal')
        const metaTexto = objetivos[this.paciente.healthGoal] || this.paciente.healthGoal || 'No definido'
        doc.text(metaTexto.substring(0, 13), 143, y + 4)
        
        y = yFilaInicio + 31
        
        // ==================== INFORMACIÓN MÉDICA (2 COLUMNAS) ====================
        doc.setFillColor(255, 245, 245) // Rojo muy claro
        doc.setDrawColor(244, 67, 54) // Rojo
        doc.setLineWidth(0.4)
        doc.roundedRect(15, y, 180, 42, 2, 2, 'FD')
        
        y += 5
        doc.setFontSize(10)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('INFORMACION MEDICA', 20, y)
        y += 5
        
        doc.setFontSize(7.5)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        const yMedicaInicio = y
        
        // COLUMNA IZQUIERDA
        // Condiciones Médicas
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('Condiciones Medicas:', 20, y)
        y += 3.5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.medicalConditions) {
          const condiciones = doc.splitTextToSize(this.paciente.medicalConditions, 80)
          doc.text(condiciones, 22, y)
          y += (condiciones.length * 3.5) + 1.5
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin condiciones', 22, y)
          doc.setTextColor(60, 60, 60)
          y += 4.5
        }
        
        // Alergias
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('Alergias:', 20, y)
        y += 3.5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.allergies) {
          const alergias = doc.splitTextToSize(this.paciente.allergies, 80)
          doc.text(alergias, 22, y)
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin alergias', 22, y)
          doc.setTextColor(60, 60, 60)
        }
        
        // COLUMNA DERECHA
        y = yMedicaInicio
        
        // Restricciones Dietéticas
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('Restricciones Dieteticas:', 107, y)
        y += 3.5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.dietaryRestrictions) {
          const restricciones = doc.splitTextToSize(this.paciente.dietaryRestrictions, 80)
          doc.text(restricciones, 109, y)
          y += (restricciones.length * 3.5) + 1.5
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin restricciones', 109, y)
          doc.setTextColor(60, 60, 60)
          y += 4.5
        }
        
        // Notas adicionales
        if (this.paciente.notes) {
          doc.setFont('helvetica', 'bold')
          doc.setTextColor(244, 67, 54)
          doc.text('Notas:', 107, y)
          y += 3.5
          doc.setFont('helvetica', 'normal')
          doc.setTextColor(60, 60, 60)
          const notas = doc.splitTextToSize(this.paciente.notes, 80)
          doc.text(notas, 109, y)
        }
        
        y = yMedicaInicio + 46
        
        // ==================== GRÁFICA DE PESO (Nueva Página) ====================
        if (this.weightRecords && this.weightRecords.length > 0 && this.$refs.weightChart) {
          // Nueva página para la gráfica
          doc.addPage()
          
          // Encabezado en la segunda página (igual que la primera)
          await generarEncabezadoPDF(doc, 'Evolución del Peso', nutricionistaInfo)
          
          y = 52
          
          try {
            // Obtener el canvas de Chart.js
            const chartComponent = this.$refs.weightChart
            const canvas = chartComponent.$el.querySelector('canvas')
            
            if (canvas) {
              // Caja compacta para la gráfica
              doc.setFillColor(255, 255, 255)
              doc.setDrawColor(200, 200, 200)
              doc.setLineWidth(0.4)
              doc.roundedRect(15, y, 180, 105, 2, 2, 'FD')
              
              y += 3
              
              // Convertir el canvas a imagen base64
              const imgData = canvas.toDataURL('image/png', 1.0)
              
              // Agregar la imagen al PDF (centrada en la caja)
              const imgWidth = 174
              const imgHeight = 99
              const imgX = (210 - imgWidth) / 2
              
              doc.addImage(imgData, 'PNG', imgX, y, imgWidth, imgHeight)
              y += imgHeight + 8
              
              // ==================== TABLA DE REGISTROS ====================
              doc.setFillColor(232, 245, 233)
              doc.setDrawColor(76, 175, 80)
              doc.setLineWidth(0.4)
              doc.roundedRect(15, y, 180, 8, 2, 2, 'FD')
              
              y += 5.5
              doc.setFontSize(10)
              doc.setFont('helvetica', 'bold')
              doc.setTextColor(76, 175, 80)
              doc.text('Detalle de Registros', 20, y)
              
              y += 8
              
              // Encabezados de la tabla con fondo
              doc.setFillColor(245, 245, 245)
              doc.rect(15, y - 4, 180, 6, 'F')
              
              doc.setFontSize(7.5)
              doc.setFont('helvetica', 'bold')
              doc.setTextColor(60, 60, 60)
              doc.text('Fecha', 20, y)
              doc.text('Peso (kg)', 60, y)
              doc.text('Diferencia', 100, y)
              doc.text('Notas', 140, y)
              
              y += 6
              doc.setFont('helvetica', 'normal')
              
              y += 1
              
              // Registros (mostrar los últimos 20 con espacio compacto)
              const registrosParaMostrar = this.weightRecords.slice(-20)
              let alternarColor = false
              
              for (let index = 0; index < registrosParaMostrar.length; index++) {
                const record = registrosParaMostrar[index]
                
                if (y > 268) {
                  doc.addPage()
                  await generarEncabezadoPDF(doc, 'Evolución del Peso (continuación)', nutricionistaInfo)
                  y = 56
                }
                
                // Alternar color de fondo para filas
                if (alternarColor) {
                  doc.setFillColor(252, 252, 252)
                  doc.rect(15, y - 3, 180, 4.5, 'F')
                }
                alternarColor = !alternarColor
                
                doc.setTextColor(60, 60, 60)
                const fecha = new Date(record.recordDate).toLocaleDateString('es-MX')
                doc.text(fecha, 20, y)
                doc.text(record.weight.toString(), 60, y)
                
                // Calcular diferencia con el registro anterior
                if (index > 0) {
                  const diff = record.weight - registrosParaMostrar[index - 1].weight
                  const diffText = diff > 0 ? `+${diff.toFixed(1)}` : `${diff.toFixed(1)}`
                  
                  // Color según aumento o disminución
                  if (diff > 0) {
                    doc.setTextColor(244, 67, 54) // Rojo
                  } else {
                    doc.setTextColor(76, 175, 80) // Verde
                  }
                  doc.text(diffText, 100, y)
                  doc.setTextColor(60, 60, 60)
                }
                
                // Notas (truncadas si son muy largas)
                if (record.notes) {
                  const notasTruncadas = record.notes.substring(0, 25) + (record.notes.length > 25 ? '...' : '')
                  doc.setTextColor(100, 100, 100)
                  doc.text(notasTruncadas, 140, y)
                  doc.setTextColor(60, 60, 60)
                }
                
                y += 4.5
              }
              
              // Espacio adicional después de la tabla
              y += 8
            }
          } catch (error) {
            console.error('Error agregando gráfica al PDF:', error)
            doc.setFontSize(8)
            doc.setTextColor(244, 67, 54)
            doc.text('Error al generar la grafica', 20, y)
            y += 8
          }
        }
        
        // ============ SECCIÓN DE FIRMA (en la última página) ============
        const totalPages = doc.internal.getNumberOfPages()
        doc.setPage(totalPages)
        
        // Verificar si hay espacio suficiente, sino agregar nueva página
        const yFirma = y > 235 ? (doc.addPage(), 52) : y + 15
        y = yFirma
        
        // Línea de firma
        doc.setDrawColor(100, 100, 100)
        doc.setLineWidth(0.3)
        doc.line(65, y, 145, y)
        
        y += 5
        
        // Nombre del nutriólogo
        doc.setFontSize(9)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(60, 60, 60)
        const nombreNutriologo = nutricionistaInfo 
          ? `${nutricionistaInfo.firstName} ${nutricionistaInfo.lastName}`
          : 'Nutriólogo(a)'
        doc.text(nombreNutriologo, 105, y, { align: 'center' })
        
        y += 4
        
        // Título profesional (igual que en el encabezado)
        doc.setFontSize(7.5)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(100, 100, 100)
        const tituloProfesional = nutricionistaInfo?.degree || 'Lic. en Nutrición'
        doc.text(tituloProfesional, 105, y, { align: 'center' })
        
        if (nutricionistaInfo?.professionalLicense) {
          y += 3.5
          doc.text(`Ced. Prof. ${nutricionistaInfo.professionalLicense}`, 105, y, { align: 'center' })
        }
        
        // ============ PIE DE PÁGINA ============
        const totalPagesActualizado = doc.internal.getNumberOfPages()
        const colorVerde = [139, 195, 74]
        const colorGris = [120, 120, 120]
        const colorAzul = [95, 195, 228]
        
        for (let i = 1; i <= totalPagesActualizado; i++) {
          doc.setPage(i)
          
          // Línea decorativa superior del pie
          doc.setDrawColor(220, 220, 220)
          doc.setLineWidth(0.3)
          doc.line(20, 275, 190, 275)
          
          // Columna izquierda - Número de página
          doc.setFontSize(7)
          doc.setTextColor(...colorGris)
          doc.setFont('helvetica', 'normal')
          doc.text(`Pag. ${i} de ${totalPagesActualizado}`, 20, 282)
          
          // Columna centro - Nombre del sistema
          doc.setFont('helvetica', 'bold')
          doc.setFontSize(8)
          doc.setTextColor(...colorVerde)
          doc.text('NUTRITRACK', 105, 281, { align: 'center' })
          
          // Subtítulo
          doc.setFont('helvetica', 'normal')
          doc.setFontSize(6.5)
          doc.setTextColor(...colorGris)
          doc.text('Sistema de Gestión Nutricional', 105, 285, { align: 'center' })
          
          // Columna derecha - Contacto
          doc.setFontSize(6.5)
          doc.setTextColor(...colorAzul)
          doc.text('www.nutritrack.com', 190, 281, { align: 'right' })
          doc.setTextColor(...colorGris)
          doc.text('contacto@nutritrack.com', 190, 285, { align: 'right' })
          
          // Texto confidencial (centrado debajo de todo)
          doc.setFontSize(6)
          doc.setFont('helvetica', 'italic')
          doc.setTextColor(120, 120, 120)
          doc.text('Documento confidencial - Uso exclusivo del personal médico autorizado', 105, 291, { align: 'center' })
        }
        
        // Guardar el PDF
        const nombreArchivo = `FichaMedica_${this.paciente.firstName}_${this.paciente.lastName}_${this.paciente.id}.pdf`
        doc.save(nombreArchivo)
        
      } catch (error) {
        console.error('Error generando PDF:', error)
        alert('Error al generar el PDF. Por favor, intente de nuevo.')
      }
    },
    
    async cargarRegistrosPeso() {
      try {
        const pacienteId = this.$route.params.id
        const response = await api.get(`/weight-records/patient/${pacienteId}`)
        this.weightRecords = response.data
        console.log('Registros de peso cargados:', this.weightRecords)
      } catch (error) {
        console.error('Error cargando registros de peso:', error)
        // No mostramos error al usuario ya que es normal no tener registros
      }
    },
    
    async registrarPeso() {
      try {
        this.guardandoPeso = true
        this.errorPeso = null
        this.exitoPeso = false
        
        const pacienteId = this.$route.params.id
        const payload = {
          patientId: pacienteId,
          weight: this.nuevoPeso.weight,
          recordDate: this.nuevoPeso.recordDate,
          notes: this.nuevoPeso.notes
        }
        
        console.log('Registrando peso:', payload)
        await api.post('/weight-records', payload)
        
        this.exitoPeso = true
        
        // Recargar registros y paciente
        await this.cargarRegistrosPeso()
        await this.cargarPaciente()
        
        // Limpiar formulario después de 1.5 segundos
        setTimeout(() => {
          this.nuevoPeso = {
            weight: null,
            recordDate: new Date().toISOString().split('T')[0],
            notes: ''
          }
          this.mostrarFormularioPeso = false
          this.exitoPeso = false
        }, 1500)
        
      } catch (error) {
        console.error('Error registrando peso:', error)
        this.errorPeso = error.response?.data?.message || error.message || 'Error al registrar peso'
      } finally {
        this.guardandoPeso = false
      }
    },
    
    async eliminarRegistroPeso(recordId) {
      if (!confirm('¿Estás seguro de eliminar este registro de peso?')) {
        return
      }
      
      try {
        await api.delete(`/weight-records/${recordId}`)
        await this.cargarRegistrosPeso()
        await this.cargarPaciente()
      } catch (error) {
        console.error('Error eliminando registro:', error)
        alert('Error al eliminar el registro. Por favor, intente de nuevo.')
      }
    },
    
    calcularDiferenciaPeso(pesoActual, pesoAnterior) {
      return pesoActual - pesoAnterior
    },
    
    // Métodos de Evaluación Nutricional
    async cargarEvaluaciones() {
      this.loadingAssessments = true
      try {
        const patientId = this.$route.params.id
        const response = await api.get(`/nutritional-assessments/patient/${patientId}/latest`)
        this.latestAssessment = response.data
      } catch (error) {
        if (error.response?.status !== 404) {
          console.error('Error cargando evaluaciones:', error)
        }
      } finally {
        this.loadingAssessments = false
      }
    },
    
    toggleEvaluacionNutricional() {
      this.mostrarEvaluacionNutricional = !this.mostrarEvaluacionNutricional
    },
    
    async onAssessmentSaved() {
      this.mostrarEvaluacionNutricional = false
      await this.cargarEvaluaciones()
      alert('Evaluación guardada correctamente')
    },
    
    verEvaluacionCompleta() {
      // Aquí podrías abrir un modal con toda la información
      // Por ahora, simplemente abrimos el formulario en modo edición
      this.mostrarEvaluacionNutricional = true
    },
    
    getWeightGoalText(goal) {
      const goals = {
        'LOSS': 'Pérdida de peso',
        'GAIN': 'Ganancia de peso',
        'MAINTENANCE': 'Mantenimiento'
      }
      return goals[goal] || 'N/A'
    },
    
    getActivityLevelText(level) {
      const levels = {
        'SEDENTARY': 'Sedentario',
        'LIGHT': 'Ligero',
        'MODERATE': 'Moderado',
        'INTENSE': 'Intenso'
      }
      return levels[level] || 'N/A'
    }
  }
}
</script>

<style scoped>
/* Container principal con gradiente de fondo */
.patient-detail-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 50%, #e0f7fa 100%);
  padding: 30px;
  position: relative;
  overflow: hidden;
}

.patient-detail-container::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(139, 195, 74, 0.1) 0%, transparent 70%);
  z-index: 1;
}

.patient-detail-container::after {
  content: '';
  position: absolute;
  bottom: -50%;
  left: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(95, 194, 198, 0.1) 0%, transparent 70%);
  z-index: 1;
}

/* Header principal */
.detail-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  border-radius: 20px;
  padding: 30px 40px;
  margin-bottom: 30px;
  box-shadow: 0 8px 20px rgba(139, 195, 74, 0.3);
  position: relative;
  z-index: 2;
  overflow: hidden;
}

.detail-header::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -20%;
  width: 300px;
  height: 300px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  z-index: 0;
}

.header-content {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-icon {
  font-size: 50px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.header-text {
  flex: 1;
}

.header-title {
  font-size: 32px;
  font-weight: 700;
  color: white;
  margin: 0;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.header-subtitle {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.95);
  margin: 5px 0 0 0;
}

/* Contenido principal */
.detail-content {
  position: relative;
  z-index: 2;
}

/* Cards modernos */
.modern-card {
  background: white;
  border-radius: 20px;
  padding: 30px;
  margin-bottom: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  border-left: 5px solid #8bc34a;
  transition: all 0.3s ease;
}

.modern-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.info-card {
  border-left-color: #8bc34a;
}

.weight-card {
  border-left-color: #5fc2c6;
}

/* Header del paciente con avatar */
.patient-name-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 25px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f0f0f0;
}

.patient-avatar-large {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #8bc34a, #5fc2c6);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  font-weight: 700;
  color: white;
  box-shadow: 0 4px 15px rgba(139, 195, 74, 0.3);
  flex-shrink: 0;
}

.patient-title {
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin: 0;
}

.patient-id {
  font-size: 14px;
  color: #7a7a5a;
  font-weight: 400;
  display: block;
  margin-top: 5px;
}

/* Grid de información */
.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.info-section {
  margin-bottom: 20px;
}

/* Headers de sección con variantes de color */
.section-header {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 15px;
  padding: 12px 20px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 10px;
  background: linear-gradient(135deg, #8bc34a, #7ab73f);
  color: white;
  box-shadow: 0 3px 10px rgba(139, 195, 74, 0.3);
}

.section-header.header-green {
  background: linear-gradient(135deg, #8bc34a, #7ab73f);
  box-shadow: 0 3px 10px rgba(139, 195, 74, 0.3);
}

.section-header.header-blue {
  background: linear-gradient(135deg, #5fc2c6, #4fb1b6);
  box-shadow: 0 3px 10px rgba(95, 194, 198, 0.3);
}

.section-header.header-orange {
  background: linear-gradient(135deg, #ff9800, #f57c00);
  box-shadow: 0 3px 10px rgba(255, 152, 0, 0.3);
}

.section-header.header-red {
  background: linear-gradient(135deg, #ff5252, #ff1744);
  box-shadow: 0 3px 10px rgba(255, 82, 82, 0.3);
}

.section-icon {
  font-size: 24px;
  filter: drop-shadow(2px 2px 2px rgba(0, 0, 0, 0.2));
}

/* Filas de detalles */
.detail-row {
  display: flex;
  align-items: center;
  padding: 10px 15px;
  border-radius: 8px;
  background: #f8f9fa;
  margin-bottom: 10px;
  transition: all 0.2s ease;
}

.detail-row:hover {
  background: #e8f5e9;
  transform: translateX(5px);
}

.detail-label {
  font-weight: 600;
  color: #7a7a5a;
  min-width: 150px;
  font-size: 14px;
}

.detail-value {
  color: #2c3e50;
  font-size: 15px;
  flex: 1;
}

/* Sección de emergencia */
.emergency-section {
  margin-top: 25px;
  padding-top: 25px;
  border-top: 3px dashed #ff5252;
}

/* Card header con botón */
.card-header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.card-title {
  font-size: 24px;
  font-weight: 700;
  color: #2c3e50;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 10px;
}

.title-icon {
  font-size: 28px;
}

/* Botones de acción */
.btn-action {
  padding: 10px 20px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: white;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.btn-action:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.btn-action:active {
  transform: translateY(0);
}

.btn-add-weight {
  background: linear-gradient(135deg, #5fc2c6, #4fb1b6);
}

.btn-add-weight:hover {
  background: linear-gradient(135deg, #4fb1b6, #3fa1a6);
}

/* Formularios */
.form-section {
  background: #f8f9fa;
  padding: 25px;
  border-radius: 15px;
  margin-bottom: 20px;
}

.form-section h4 {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-label {
  font-weight: 600;
  color: #7a7a5a;
  font-size: 14px;
}

.form-input,
.form-select,
.form-textarea {
  padding: 10px 15px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: white;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  outline: none;
  border-color: #8bc34a;
  box-shadow: 0 0 0 3px rgba(139, 195, 74, 0.1);
}

.form-textarea {
  min-height: 100px;
  resize: vertical;
  font-family: inherit;
}

/* Botones de formulario */
.form-buttons {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  margin-top: 20px;
}

.btn-submit {
  background: linear-gradient(135deg, #8bc34a, #7ab73f);
  color: white;
  padding: 12px 30px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 15px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 3px 10px rgba(139, 195, 74, 0.3);
}

.btn-submit:hover {
  background: linear-gradient(135deg, #7ab73f, #6aa72f);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(139, 195, 74, 0.4);
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.btn-cancel {
  background: linear-gradient(135deg, #7a7a5a, #6a6a4a);
  color: white;
  padding: 12px 30px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 15px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 3px 10px rgba(122, 122, 90, 0.3);
}

.btn-cancel:hover {
  background: linear-gradient(135deg, #6a6a4a, #5a5a3a);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(122, 122, 90, 0.4);
}

/* Registros de peso */
.weight-records {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 15px;
  margin-top: 20px;
}

.weight-record-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #e8f5e9 100%);
  padding: 20px;
  border-radius: 15px;
  border-left: 4px solid #5fc2c6;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.weight-record-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
}

.weight-date {
  font-size: 13px;
  color: #7a7a5a;
  margin-bottom: 10px;
  font-weight: 600;
}

.weight-value {
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 8px;
  display: flex;
  align-items: baseline;
  gap: 5px;
}

.weight-unit {
  font-size: 16px;
  color: #7a7a5a;
  font-weight: 400;
}

.weight-diff {
  font-size: 14px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 8px;
  display: inline-block;
  margin-bottom: 10px;
}

.weight-diff.positive {
  background: rgba(255, 82, 82, 0.1);
  color: #ff5252;
}

.weight-diff.negative {
  background: rgba(139, 195, 74, 0.1);
  color: #8bc34a;
}

.weight-notes {
  font-size: 13px;
  color: #5a5a5a;
  margin-bottom: 12px;
  font-style: italic;
}

.record-actions {
  display: flex;
  gap: 8px;
}

.btn-record {
  padding: 6px 12px;
  border: none;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  color: white;
  flex: 1;
}

.btn-edit-record {
  background: linear-gradient(135deg, #ff9800, #f57c00);
}

.btn-edit-record:hover {
  background: linear-gradient(135deg, #f57c00, #e65100);
  transform: scale(1.05);
}

.btn-delete-record {
  background: linear-gradient(135deg, #ff5252, #ff1744);
}

.btn-delete-record:hover {
  background: linear-gradient(135deg, #ff1744, #d50000);
  transform: scale(1.05);
}

/* Mensajes de estado */
.success-message,
.error-message {
  padding: 12px 20px;
  border-radius: 12px;
  margin-bottom: 15px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.success-message {
  background: rgba(139, 195, 74, 0.1);
  color: #8bc34a;
  border: 2px solid #8bc34a;
}

.error-message {
  background: rgba(255, 82, 82, 0.1);
  color: #ff5252;
  border: 2px solid #ff5252;
}

/* Botón de volver */
.back-button-container {
  display: flex;
  justify-content: center;
  margin-top: 40px;
  padding-top: 30px;
  border-top: 2px solid rgba(139, 195, 74, 0.2);
}

.btn-back {
  background: linear-gradient(135deg, #7a7a5a, #6a6a4a);
  color: white;
  padding: 14px 40px;
  border: none;
  border-radius: 15px;
  font-weight: 600;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(122, 122, 90, 0.3);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 10px;
}

.btn-back:hover {
  background: linear-gradient(135deg, #6a6a4a, #5a5a3a);
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 6px 20px rgba(122, 122, 90, 0.4);
}

.btn-back:active {
  transform: translateY(-1px) scale(1);
}

/* Responsive design */
@media (max-width: 768px) {
  .patient-detail-container {
    padding: 15px;
  }

  .detail-header {
    padding: 20px;
    margin-bottom: 20px;
  }

  .header-content {
    flex-direction: column;
    text-align: center;
  }

  .header-title {
    font-size: 24px;
  }

  .modern-card {
    padding: 20px;
  }

  .patient-name-header {
    flex-direction: column;
    text-align: center;
  }

  .patient-title {
    font-size: 22px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .card-header-section {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .weight-records {
    grid-template-columns: 1fr;
  }

  .form-buttons {
    flex-direction: column;
  }

  .btn-back {
    width: 100%;
    justify-content: center;
  }
}

/* ===== ESTILOS DEL MODAL DE EDICIÓN MODERNO ===== */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  overflow-y: auto;
  padding: 20px;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-edit-content {
  background: white;
  border-radius: 20px;
  max-width: 900px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-edit-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 30px 35px;
  display: flex;
  align-items: center;
  gap: 20px;
  border-radius: 20px 20px 0 0;
  position: relative;
  overflow: hidden;
}

.modal-edit-header::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -10%;
  width: 200px;
  height: 200px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

.modal-header-icon {
  font-size: 48px;
  filter: drop-shadow(2px 2px 4px rgba(0, 0, 0, 0.2));
}

.modal-edit-title {
  font-size: 28px;
  font-weight: 700;
  color: white;
  margin: 0;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.modal-edit-subtitle {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.95);
  margin: 5px 0 0 0;
}

.modal-close-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.3);
  font-size: 24px;
  cursor: pointer;
  color: white;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  margin-left: auto;
  flex-shrink: 0;
  position: relative;
  z-index: 10;
}

.modal-close-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: rotate(90deg);
}

.modal-edit-form {
  padding: 35px;
}

/* Secciones del formulario */
.form-section {
  margin-bottom: 30px;
  padding-bottom: 30px;
  border-bottom: 2px solid #f0f0f0;
}

.form-section:last-of-type {
  border-bottom: none;
  margin-bottom: 20px;
}

.form-section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.form-section-icon {
  font-size: 28px;
  filter: drop-shadow(2px 2px 4px rgba(0, 0, 0, 0.1));
}

.form-section-title {
  font-size: 20px;
  font-weight: 700;
  color: #2c3e50;
  margin: 0;
}

/* Grids del formulario */
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.form-grid-full {
  display: grid;
  grid-template-columns: 1fr;
  gap: 20px;
}

.form-field {
  display: flex;
  flex-direction: column;
}

.form-label {
  font-weight: 600;
  color: #495057;
  margin-bottom: 8px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.form-input {
  padding: 12px 15px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
  font-size: 15px;
  transition: all 0.3s ease;
  background: #f8f9fa;
}

.form-input:focus {
  outline: none;
  border-color: #8bc34a;
  background: white;
  box-shadow: 0 0 0 4px rgba(139, 195, 74, 0.1);
}

.form-input::placeholder {
  color: #adb5bd;
}

/* Alertas */
.alert-error {
  background: #fee;
  color: #c33;
  padding: 15px 20px;
  border-radius: 12px;
  margin-top: 20px;
  border-left: 4px solid #c33;
  display: flex;
  align-items: center;
  gap: 10px;
}

.alert-success {
  background: #d4edda;
  color: #155724;
  padding: 15px 20px;
  border-radius: 12px;
  margin-top: 20px;
  border-left: 4px solid #28a745;
  display: flex;
  align-items: center;
  gap: 10px;
}

/* Botones del modal */
.modal-edit-actions {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  margin-top: 30px;
  padding-top: 25px;
  border-top: 2px solid #f0f0f0;
}

.btn-modal-cancel {
  padding: 12px 30px;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-modal-cancel:hover {
  background: #5a6268;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
}

.btn-modal-submit {
  padding: 12px 30px;
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(139, 195, 74, 0.3);
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-modal-submit:hover:not(:disabled) {
  background: linear-gradient(135deg, #7ab73f 0%, #6aa62f 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4);
}

.btn-modal-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

/* Responsive del modal */
@media (max-width: 768px) {
  .modal-overlay {
    padding: 10px;
  }

  .modal-edit-content {
    max-height: 95vh;
  }

  .modal-edit-header {
    padding: 20px;
    flex-wrap: wrap;
  }

  .modal-header-icon {
    font-size: 36px;
  }

  .modal-edit-title {
    font-size: 22px;
  }

  .modal-edit-form {
    padding: 20px;
  }

  .form-grid {
    grid-template-columns: 1fr;
  }

  .modal-edit-actions {
    flex-direction: column;
  }

  .btn-modal-cancel,
  .btn-modal-submit {
    width: 100%;
    justify-content: center;
  }
}

/* Estilos para Evaluación Nutricional */
.assessment-card {
  background: white;
  border-radius: 12px;
  padding: 25px;
  margin-bottom: 25px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.btn-assessment {
  background: linear-gradient(135deg, #9C27B0 0%, #7B1FA2 100%);
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-assessment:hover {
  background: linear-gradient(135deg, #7B1FA2 0%, #6A1B9A 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(156, 39, 176, 0.3);
}

.assessment-summary {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 20px;
  margin-top: 15px;
}

.summary-header {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #e0e0e0;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.summary-item {
  background: white;
  padding: 12px 15px;
  border-radius: 6px;
  border-left: 3px solid #9C27B0;
  font-size: 14px;
}

.summary-item strong {
  color: #555;
  display: block;
  margin-bottom: 5px;
}

.btn-view-full {
  width: 100%;
  padding: 12px;
  background: white;
  border: 2px solid #9C27B0;
  color: #9C27B0;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.btn-view-full:hover {
  background: #9C27B0;
  color: white;
}
</style>
