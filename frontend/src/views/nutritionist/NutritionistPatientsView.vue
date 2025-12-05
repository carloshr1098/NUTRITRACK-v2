<template>
  <div class="patients-container">
    <!-- Header elegante -->
    <div class="patients-header">
      <div class="header-content">
        <div class="header-icon">👨‍⚕️</div>
        <div class="header-text">
          <h1 class="header-title">Gestión de Pacientes</h1>
          <p class="header-subtitle">Administrar información de pacientes</p>
        </div>
      </div>
    </div>
    
    <!-- Barra de acciones -->
    <div class="actions-bar">
      <div class="search-container">
        <span class="search-icon">🔍</span>
        <input 
          v-model="busqueda"
          type="text"
          class="search-input"
          placeholder="Buscar paciente por nombre, apellido o email..."
        >
        <button 
          v-if="busqueda"
          @click="busqueda = ''"
          class="clear-search-btn"
          title="Limpiar búsqueda"
        >
          ✖
        </button>
      </div>
      <div class="actions-buttons">
        <button 
          @click="mostrarFormulario = !mostrarFormulario" 
          class="btn-action btn-new"
        >
          <span class="btn-icon">{{ mostrarFormulario ? '✖' : '➕' }}</span>
          {{ mostrarFormulario ? 'Cancelar' : 'Nuevo Paciente' }}
        </button>
        <button 
          @click="cargarPacientes" 
          class="btn-action btn-reload"
        >
          <span class="btn-icon">🔄</span>
          Cargar Pacientes
        </button>
      </div>
    </div>

    <!-- Modal de formulario para nuevo/editar paciente -->
    <div v-if="mostrarFormulario" 
         class="modal-overlay"
         @click.self="cancelarFormulario">
      <div class="modal-edit-content">
        <div class="modal-edit-header">
          <div class="modal-header-icon">{{ modoEdicion ? '✏️' : '➕' }}</div>
          <div>
            <h2 class="modal-edit-title">{{ modoEdicion ? 'Editar Información del Paciente' : 'Registrar Nuevo Paciente' }}</h2>
            <p class="modal-edit-subtitle">{{ modoEdicion ? 'Actualiza los datos del paciente' : 'Completa la información del nuevo paciente' }}</p>
          </div>
          <button 
            type="button"
            @click="cancelarFormulario"
            class="modal-close-btn"
            title="Cerrar"
          >
            ✖
          </button>
        </div>
        
        <form @submit.prevent="modoEdicion ? actualizarPaciente() : crearPaciente()" class="modal-edit-form">
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
                  v-model="nuevoPaciente.primerNombre" 
                  type="text" 
                  required
                  @blur="nuevoPaciente.primerNombre = capitalizarNombre(nuevoPaciente.primerNombre)"
                  class="form-input"
                  placeholder="Ingresa el nombre"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Apellido *</label>
                <input 
                  v-model="nuevoPaciente.primerApellido" 
                  type="text" 
                  required
                  @blur="nuevoPaciente.primerApellido = capitalizarNombre(nuevoPaciente.primerApellido)"
                  class="form-input"
                  placeholder="Ingresa el apellido"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Fecha de Nacimiento *</label>
                <input 
                  v-model="nuevoPaciente.fechaNacimiento" 
                  type="date" 
                  required
                  class="form-input"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Género *</label>
                <select 
                  v-model="nuevoPaciente.genero" 
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
                  v-model="nuevoPaciente.email" 
                  type="email" 
                  class="form-input"
                  placeholder="correo@ejemplo.com"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Teléfono</label>
                <input 
                  v-model="nuevoPaciente.telefono" 
                  type="tel" 
                  maxlength="10"
                  @keypress="soloNumerosEnteros"
                  placeholder="10 dígitos"
                  class="form-input"
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
                  v-model.number="nuevoPaciente.altura" 
                  type="number" 
                  step="0.01"
                  min="0"
                  required
                  @keypress="soloNumeros"
                  class="form-input"
                  placeholder="175"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Peso Actual (kg) *</label>
                <input 
                  v-model.number="nuevoPaciente.pesoActual" 
                  type="number" 
                  step="0.01"
                  min="0"
                  required
                  @keypress="soloNumeros"
                  class="form-input"
                  placeholder="70"
                >
              </div>
              <div class="form-field" style="grid-column: 1 / -1;">
                <label class="form-label">Nivel de Actividad</label>
                <select 
                  v-model="nuevoPaciente.nivelActividad" 
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
                  v-model="nuevoPaciente.healthGoal" 
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
                  v-model="nuevoPaciente.condicionesMedicas" 
                  rows="3"
                  class="form-input"
                  placeholder="Ej: Diabetes tipo 2, hipertensión..."
                ></textarea>
              </div>
              <div class="form-field">
                <label class="form-label">Alergias</label>
                <textarea 
                  v-model="nuevoPaciente.alergias" 
                  rows="2"
                  class="form-input"
                  placeholder="Ej: Nueces, mariscos, lactosa..."
                ></textarea>
              </div>
              <div class="form-field">
                <label class="form-label">Restricciones Dietéticas</label>
                <textarea 
                  v-model="nuevoPaciente.restriccionesDieteticas" 
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
                  v-model="nuevoPaciente.contactoEmergenciaNombre" 
                  type="text"
                  @blur="nuevoPaciente.contactoEmergenciaNombre = capitalizarNombre(nuevoPaciente.contactoEmergenciaNombre)"
                  class="form-input"
                  placeholder="Nombre completo"
                >
              </div>
              <div class="form-field">
                <label class="form-label">Teléfono del Contacto</label>
                <input 
                  v-model="nuevoPaciente.contactoEmergenciaTelefono" 
                  type="tel"
                  maxlength="10"
                  @keypress="soloNumerosEnteros"
                  placeholder="10 dígitos"
                  class="form-input"
                >
              </div>
            </div>
          </div>
          
          <div v-if="errorCreacion" class="alert-error">
            <strong>⚠️ Error:</strong> {{ errorCreacion }}
          </div>
          
          <div v-if="exitoCreacion" class="alert-success">
            <strong>✓ ¡Éxito!</strong> Paciente {{ modoEdicion ? 'actualizado' : 'creado' }} correctamente.
          </div>
          
          <div class="modal-edit-actions">
            <button 
              type="button"
              @click="cancelarFormulario" 
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
              <span v-else>💾 {{ modoEdicion ? 'Actualizar Paciente' : 'Guardar Paciente' }}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
    
    <div v-if="loading" style="text-align: center; padding: 40px;">
      <p>Cargando pacientes...</p>
    </div>
    
    <div v-else-if="error" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
      <strong>Error:</strong> {{ error }}
      <br>
      <small>Endpoint: GET /api/pacientes</small>
    </div>
    
    <div v-else-if="pacientes.length === 0 && !primeraCarga" style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px;">
      <p style="color: #666; margin: 0;">Haz clic en "Cargar Pacientes" para ver la lista de pacientes.</p>
    </div>
    
    <div v-else-if="pacientes.length === 0" style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px;">
      <p style="color: #666; margin: 0;">No hay pacientes registrados aún.</p>
    </div>
    
    <div v-else-if="pacientesFiltrados.length === 0 && busqueda" style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px;">
      <p style="color: #666; margin: 0;">No se encontraron pacientes que coincidan con "{{ busqueda }}"</p>
    </div>
    
    <div v-else class="patients-grid">
      <div 
        v-for="paciente in pacientesFiltrados" 
        :key="paciente.id" 
        class="patient-card"
      >
        <div class="patient-card-header">
          <div class="patient-avatar">{{ paciente.firstName?.[0] }}{{ paciente.lastName?.[0] }}</div>
          <div class="patient-info">
            <h4 class="patient-name">
              {{ paciente.firstName }} {{ paciente.lastName }}
            </h4>
            <span class="patient-badge">{{ paciente.gender || 'No especificado' }}</span>
          </div>
        </div>
        
        <div class="patient-details">
          <div class="detail-row">
            <span class="detail-icon">📅</span>
            <span class="detail-label">Fecha de Nacimiento:</span>
            <span class="detail-value">{{ paciente.dateOfBirth || 'No especificada' }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-icon">📏</span>
            <span class="detail-label">Altura:</span>
            <span class="detail-value">{{ paciente.height ? paciente.height + ' cm' : 'No especificada' }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-icon">⚖️</span>
            <span class="detail-label">Peso Actual:</span>
            <span class="detail-value">{{ paciente.currentWeight ? paciente.currentWeight + ' kg' : 'No especificado' }}</span>
          </div>
          <div v-if="paciente.activityLevel" class="detail-row">
            <span class="detail-icon">🏃</span>
            <span class="detail-label">Actividad:</span>
            <span class="detail-value">{{ paciente.activityLevel }}</span>
          </div>
          <div v-if="paciente.medicalConditions" class="detail-row full-width">
            <span class="detail-icon">🏥</span>
            <span class="detail-label">Condiciones:</span>
            <span class="detail-value">{{ paciente.medicalConditions }}</span>
          </div>
          <div v-if="paciente.allergies" class="detail-row full-width">
            <span class="detail-icon">⚠️</span>
            <span class="detail-label">Alergias:</span>
            <span class="detail-value">{{ paciente.allergies }}</span>
          </div>
        </div>
        
        <div class="patient-actions">
          <button 
            @click="verDetalle(paciente.id)"
            class="btn-patient btn-detail"
          >
            <span class="btn-icon">👁️</span>
            Ver Detalle
          </button>
          <button 
            @click="editarPaciente(paciente)"
            class="btn-patient btn-edit"
          >
            <span class="btn-icon">✏️</span>
            Editar
          </button>
          <button 
            @click="confirmarEliminar(paciente)"
            class="btn-patient btn-delete"
          >
            <span class="btn-icon">🗑️</span>
            Eliminar
          </button>
        </div>
      </div>
    </div>

    <!-- Modal de confirmación para eliminar -->
    <div v-if="mostrarConfirmacionEliminar" 
         style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000;"
         @click.self="cancelarEliminar">
      <div style="background: white; padding: 30px; border-radius: 8px; max-width: 500px; width: 90%;">
        <h3 style="margin: 0 0 15px 0; color: #dc3545;">⚠️ Confirmar Eliminación</h3>
        <p style="margin: 0 0 20px 0;">
          ¿Estás seguro de que deseas eliminar al paciente 
          <strong>{{ pacienteAEliminar?.firstName }} {{ pacienteAEliminar?.lastName }}</strong>?
        </p>
        <p style="margin: 0 0 20px 0; color: #666; font-size: 14px;">
          Esta acción no se puede deshacer y eliminará todos los datos asociados.
        </p>
        <div style="display: flex; gap: 10px; justify-content: flex-end;">
          <button 
            @click="cancelarEliminar"
            style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;"
          >
            Cancelar
          </button>
          <button 
            @click="eliminarPaciente"
            :disabled="eliminando"
            style="padding: 10px 20px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer;"
          >
            {{ eliminando ? 'Eliminando...' : 'Eliminar' }}
          </button>
        </div>
      </div>
    </div>
    
    <div class="back-button-container">
      <router-link to="/dashboard" class="btn-back">
        <span class="btn-icon">←</span>
        Volver al Dashboard
      </router-link>
    </div>
  </div>
</template>

<script>
import api from '../../services/api.js'

export default {
  name: 'NutritionistPatientsView',
  data() {
    return {
      pacientes: [],
      busqueda: '',
      loading: false,
      error: null,
      primeraCarga: true,
      mostrarFormulario: false,
      guardando: false,
      errorCreacion: null,
      exitoCreacion: false,
      nuevoPaciente: {
        primerNombre: '',
        primerApellido: '',
        fechaNacimiento: '',
        genero: '',
        altura: null,
        pesoActual: null,
        email: '',
        telefono: '',
        nivelActividad: '',
        healthGoal: '',
        condicionesMedicas: '',
        alergias: '',
        restriccionesDieteticas: '',
        contactoEmergenciaNombre: '',
        contactoEmergenciaTelefono: ''
      },
      // Para edición
      modoEdicion: false,
      pacienteEditando: null,
      // Para eliminación
      mostrarConfirmacionEliminar: false,
      pacienteAEliminar: null,
      eliminando: false
    }
  },
  computed: {
    pacientesFiltrados() {
      if (!this.busqueda) {
        return this.pacientes
      }
      
      const busquedaLower = this.busqueda.toLowerCase()
      return this.pacientes.filter(paciente => {
        const nombreCompleto = `${paciente.firstName} ${paciente.lastName}`.toLowerCase()
        const email = (paciente.email || '').toLowerCase()
        
        return nombreCompleto.includes(busquedaLower) || 
               email.includes(busquedaLower)
      })
    }
  },
  mounted() {
    // Cargar pacientes automáticamente al entrar
    this.cargarPacientes()
    
    // Verificar si hay un paciente pendiente de editar
    const editarPacienteId = localStorage.getItem('editarPacienteId')
    if (editarPacienteId) {
      localStorage.removeItem('editarPacienteId')
      // Esperar a que carguen los pacientes y luego buscar el que se va a editar
      this.$nextTick(() => {
        const paciente = this.pacientes.find(p => p.id === parseInt(editarPacienteId))
        if (paciente) {
          this.editarPaciente(paciente)
        }
      })
    }
  },
  methods: {
    async cargarPacientes() {
      try {
        this.loading = true
        this.error = null
        this.primeraCarga = false
        
        console.log('Cargando pacientes desde /api/pacientes...')
        const response = await api.get('/pacientes')
        console.log('Respuesta del servidor:', response.data)
        
        this.pacientes = response.data || []
      } catch (error) {
        console.error('Error cargando pacientes:', error)
        this.error = `${error.message} (${error.response?.status || 'Sin código'})`
      } finally {
        this.loading = false
      }
    },
    
    async crearPaciente() {
      try {
        this.guardando = true
        this.errorCreacion = null
        this.exitoCreacion = false
        
        // Validaciones adicionales
        if (this.nuevoPaciente.altura && this.nuevoPaciente.altura < 0) {
          this.errorCreacion = 'La altura no puede ser negativa'
          this.guardando = false
          return
        }
        
        if (this.nuevoPaciente.pesoActual && this.nuevoPaciente.pesoActual < 0) {
          this.errorCreacion = 'El peso no puede ser negativo'
          this.guardando = false
          return
        }
        
        if (this.nuevoPaciente.telefono && this.nuevoPaciente.telefono.length !== 10) {
          this.errorCreacion = 'El teléfono debe tener exactamente 10 dígitos'
          this.guardando = false
          return
        }
        
        if (this.nuevoPaciente.telefono && !/^\d+$/.test(this.nuevoPaciente.telefono)) {
          this.errorCreacion = 'El teléfono solo debe contener números'
          this.guardando = false
          return
        }
        
        // Validar teléfono de emergencia
        if (this.nuevoPaciente.contactoEmergenciaTelefono) {
          if (this.nuevoPaciente.contactoEmergenciaTelefono.length !== 10) {
            this.errorCreacion = 'El teléfono de emergencia debe tener exactamente 10 dígitos'
            this.guardando = false
            return
          }
          if (!/^\d+$/.test(this.nuevoPaciente.contactoEmergenciaTelefono)) {
            this.errorCreacion = 'El teléfono de emergencia solo debe contener números'
            this.guardando = false
            return
          }
        }
        
        // Validar email si se proporciona
        if (this.nuevoPaciente.email) {
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
          if (!emailRegex.test(this.nuevoPaciente.email)) {
            this.errorCreacion = 'El email no tiene un formato válido'
            this.guardando = false
            return
          }
        }
        
        // Convertir nombres de campos de español a inglés
        const datosCreacion = {
          firstName: this.nuevoPaciente.primerNombre.trim(),
          lastName: this.nuevoPaciente.primerApellido.trim(),
          dateOfBirth: this.nuevoPaciente.fechaNacimiento,
          gender: this.nuevoPaciente.genero,
          height: Number(this.nuevoPaciente.altura),
          currentWeight: Number(this.nuevoPaciente.pesoActual),
          email: this.nuevoPaciente.email?.trim() || null,
          phone: this.nuevoPaciente.telefono || null,
          activityLevel: this.nuevoPaciente.nivelActividad || 'SEDENTARIO',
          healthGoal: this.nuevoPaciente.healthGoal || null,
          medicalConditions: this.nuevoPaciente.condicionesMedicas?.trim() || null,
          allergies: this.nuevoPaciente.alergias?.trim() || null,
          dietaryRestrictions: this.nuevoPaciente.restriccionesDieteticas?.trim() || null,
          emergencyContactName: this.nuevoPaciente.contactoEmergenciaNombre?.trim() || null,
          emergencyContactPhone: this.nuevoPaciente.contactoEmergenciaTelefono || null
        }
        
        console.log('Creando paciente:', datosCreacion)
        const response = await api.post('/pacientes', datosCreacion)
        console.log('Paciente creado:', response.data)
        
        this.exitoCreacion = true
        
        // Limpiar formulario después de 1.5 segundos
        setTimeout(() => {
          this.resetearFormulario()
          this.mostrarFormulario = false
          this.cargarPacientes() // Recargar lista
        }, 1500)
        
      } catch (error) {
        console.error('Error creando paciente:', error)
        this.errorCreacion = error.response?.data?.message || error.message || 'Error al crear paciente'
      } finally {
        this.guardando = false
      }
    },
    
    cancelarFormulario() {
      this.resetearFormulario()
      this.mostrarFormulario = false
    },
    
    resetearFormulario() {
      this.nuevoPaciente = {
        primerNombre: '',
        primerApellido: '',
        fechaNacimiento: '',
        genero: '',
        altura: null,
        pesoActual: null,
        email: '',
        telefono: '',
        nivelActividad: '',
        healthGoal: '',
        condicionesMedicas: '',
        alergias: '',
        restriccionesDieteticas: '',
        contactoEmergenciaNombre: '',
        contactoEmergenciaTelefono: ''
      }
      this.errorCreacion = null
      this.exitoCreacion = false
      this.modoEdicion = false
      this.pacienteEditando = null
    },
    
    // Métodos para editar
    editarPaciente(paciente) {
      this.modoEdicion = true
      this.pacienteEditando = paciente.id
      this.mostrarFormulario = true
      
      // Cargar datos del paciente en el formulario
      this.nuevoPaciente = {
        primerNombre: paciente.firstName || '',
        primerApellido: paciente.lastName || '',
        fechaNacimiento: paciente.dateOfBirth || '',
        genero: paciente.gender || '',
        altura: paciente.height || null,
        pesoActual: paciente.currentWeight || null,
        email: paciente.email || '',
        telefono: paciente.phone || '',
        nivelActividad: paciente.activityLevel || '',
        healthGoal: paciente.healthGoal || '',
        condicionesMedicas: paciente.medicalConditions || '',
        alergias: paciente.allergies || '',
        restriccionesDieteticas: paciente.dietaryRestrictions || '',
        contactoEmergenciaNombre: paciente.emergencyContactName || '',
        contactoEmergenciaTelefono: paciente.emergencyContactPhone || ''
      }
    },
    
    async actualizarPaciente() {
      try {
        this.guardando = true
        this.errorCreacion = null
        this.exitoCreacion = false
        
        const datosActualizados = {
          firstName: this.nuevoPaciente.primerNombre,
          lastName: this.nuevoPaciente.primerApellido,
          dateOfBirth: this.nuevoPaciente.fechaNacimiento,
          gender: this.nuevoPaciente.genero,
          height: this.nuevoPaciente.altura,
          currentWeight: this.nuevoPaciente.pesoActual,
          email: this.nuevoPaciente.email,
          phone: this.nuevoPaciente.telefono,
          activityLevel: this.nuevoPaciente.nivelActividad,
          healthGoal: this.nuevoPaciente.healthGoal,
          medicalConditions: this.nuevoPaciente.condicionesMedicas,
          allergies: this.nuevoPaciente.alergias,
          dietaryRestrictions: this.nuevoPaciente.restriccionesDieteticas,
          emergencyContactName: this.nuevoPaciente.contactoEmergenciaNombre,
          emergencyContactPhone: this.nuevoPaciente.contactoEmergenciaTelefono
        }
        
        console.log('Actualizando paciente:', datosActualizados)
        const response = await api.put(`/pacientes/${this.pacienteEditando}`, datosActualizados)
        console.log('Paciente actualizado:', response.data)
        
        this.exitoCreacion = true
        
        setTimeout(() => {
          this.resetearFormulario()
          this.mostrarFormulario = false
          this.cargarPacientes()
        }, 1500)
        
      } catch (error) {
        console.error('Error actualizando paciente:', error)
        this.errorCreacion = error.response?.data?.message || error.message || 'Error al actualizar paciente'
      } finally {
        this.guardando = false
      }
    },
    
    // Métodos para eliminar
    confirmarEliminar(paciente) {
      this.pacienteAEliminar = paciente
      this.mostrarConfirmacionEliminar = true
    },
    
    cancelarEliminar() {
      this.pacienteAEliminar = null
      this.mostrarConfirmacionEliminar = false
    },
    
    async eliminarPaciente() {
      try {
        this.eliminando = true
        
        console.log('Eliminando paciente:', this.pacienteAEliminar.id)
        await api.delete(`/pacientes/${this.pacienteAEliminar.id}`)
        console.log('Paciente eliminado exitosamente')
        
        this.cancelarEliminar()
        this.cargarPacientes()
        
      } catch (error) {
        console.error('Error eliminando paciente:', error)
        alert('Error al eliminar paciente: ' + (error.response?.data?.message || error.message))
      } finally {
        this.eliminando = false
      }
    },
    
    // Método para ver detalle (navegación)
    verDetalle(pacienteId) {
      this.$router.push(`/nutriologo/pacientes/${pacienteId}`)
    },
    
    // Métodos de validación
    soloNumeros(event) {
      const char = String.fromCharCode(event.keyCode)
      // Permitir números, punto decimal y teclas de control
      if (!/[0-9.]/.test(char) && event.keyCode !== 8 && event.keyCode !== 46) {
        event.preventDefault()
      }
    },
    
    soloNumerosEnteros(event) {
      const char = String.fromCharCode(event.keyCode)
      // Solo permitir números (0-9)
      if (!/[0-9]/.test(char)) {
        event.preventDefault()
      }
    },

    capitalizarNombre(texto) {
      if (!texto) return ''
      // Convertir todo a minúsculas primero
      texto = texto.toLowerCase()
      // Capitalizar la primera letra de cada palabra
      return texto.split(' ')
        .map(palabra => palabra.charAt(0).toUpperCase() + palabra.slice(1))
        .join(' ')
    }
  }
}
</script>

<style scoped>
/* Container principal */
.patients-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%);
  position: relative;
  padding-bottom: 60px;
}

.patients-container::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: 
    radial-gradient(circle at 20% 80%, rgba(139, 195, 74, 0.08) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(95, 194, 198, 0.08) 0%, transparent 50%);
  pointer-events: none;
  z-index: 0;
}

.patients-container > * {
  position: relative;
  z-index: 1;
}

/* Header */
.patients-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 40px 30px;
  box-shadow: 0 8px 32px rgba(139, 195, 74, 0.3);
  position: relative;
  overflow: hidden;
}

.patients-header::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -10%;
  width: 400px;
  height: 400px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  filter: blur(80px);
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  z-index: 2;
}

.header-icon {
  font-size: 4rem;
  filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.2));
}

.header-text {
  flex: 1;
}

.header-title {
  color: white;
  font-size: 2.5rem;
  font-weight: 800;
  margin: 0 0 8px 0;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.header-subtitle {
  color: rgba(255, 255, 255, 0.95);
  font-size: 1.1rem;
  margin: 0;
  font-weight: 500;
}

/* Barra de acciones */
.actions-bar {
  max-width: 1400px;
  margin: 30px auto;
  padding: 0 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

/* Barra de búsqueda */
.search-container {
  position: relative;
  flex: 1;
  max-width: 500px;
  min-width: 300px;
}

.search-icon {
  position: absolute;
  left: 18px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 20px;
  pointer-events: none;
  z-index: 1;
}

.search-input {
  width: 100%;
  padding: 14px 50px 14px 50px;
  border: 2px solid #e0e0e0;
  border-radius: 30px;
  font-size: 15px;
  transition: all 0.3s ease;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.search-input:focus {
  outline: none;
  border-color: #8bc34a;
  box-shadow: 0 4px 16px rgba(139, 195, 74, 0.2);
}

.search-input::placeholder {
  color: #adb5bd;
}

.clear-search-btn {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(139, 195, 74, 0.1);
  border: none;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  font-size: 14px;
  cursor: pointer;
  color: #8bc34a;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.clear-search-btn:hover {
  background: rgba(139, 195, 74, 0.2);
  transform: translateY(-50%) scale(1.1);
}

.actions-buttons {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.btn-action {
  padding: 12px 24px;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-icon {
  font-size: 1.2rem;
}

.btn-new {
  background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
  color: white;
}

.btn-new:hover {
  background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
}

.btn-reload {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  color: white;
}

.btn-reload:hover {
  background: linear-gradient(135deg, #7ab73f 0%, #689f38 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4);
}

/* Grid de pacientes */
.patients-grid {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 30px;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 25px;
}

/* Card de paciente */
.patient-card {
  background: white;
  border-radius: 20px;
  padding: 0;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  border-left: 5px solid #8bc34a;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 420px;
}

.patient-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 35px rgba(139, 195, 74, 0.2);
  border-left-width: 7px;
}

.patient-card-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
}

.patient-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
  text-transform: uppercase;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border: 3px solid white;
}

.patient-info {
  flex: 1;
}

.patient-name {
  color: white;
  font-size: 1.4rem;
  font-weight: 700;
  margin: 0 0 8px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.patient-badge {
  display: inline-block;
  padding: 4px 12px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
  color: white;
}

/* Detalles del paciente */
.patient-details {
  padding: 20px;
  display: grid;
  gap: 10px;
  flex: 1;
}

.detail-row {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 10px;
  padding: 8px 10px;
  border-radius: 10px;
  background: #f8fafb;
  transition: all 0.2s ease;
}

.detail-row:hover {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.08) 0%, transparent 100%);
}

.detail-row.full-width {
  grid-template-columns: auto 1fr;
}

.detail-icon {
  font-size: 1.3rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.detail-label {
  font-weight: 600;
  color: #5f6368;
  font-size: 0.9rem;
}

.detail-value {
  color: #2c3e50;
  font-weight: 500;
  text-align: right;
}

.detail-row.full-width .detail-value {
  grid-column: 2 / -1;
  text-align: left;
  margin-top: 5px;
}

/* Acciones del paciente */
.patient-actions {
  padding: 20px 25px;
  background: #f8fafb;
  display: flex;
  gap: 10px;
  justify-content: space-between;
  border-top: 2px solid #e0e0e0;
}

.btn-patient {
  flex: 1;
  padding: 10px 16px;
  border: none;
  border-radius: 10px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.btn-detail {
  background: linear-gradient(135deg, #5fc2c6 0%, #4fb3b7 100%);
  color: white;
}

.btn-detail:hover {
  background: linear-gradient(135deg, #4fb3b7 0%, #3fa4a8 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(95, 194, 198, 0.4);
}

.btn-edit {
  background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
  color: white;
}

.btn-edit:hover {
  background: linear-gradient(135deg, #f57c00 0%, #ef6c00 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(255, 152, 0, 0.4);
}

.btn-delete {
  background: linear-gradient(135deg, #ff5252 0%, #e74c3c 100%);
  color: white;
}

.btn-delete:hover {
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(255, 82, 82, 0.4);
}

/* Botón de volver */
.back-button-container {
  max-width: 1400px;
  margin: 40px auto 0;
  padding: 0 30px;
  text-align: center;
}

.btn-back {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 14px 32px;
  background: linear-gradient(135deg, #7a7a5a 0%, #6a6a4a 100%);
  color: white;
  text-decoration: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 6px 20px rgba(122, 122, 90, 0.3);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-back:hover {
  background: linear-gradient(135deg, #6a6a4a 0%, #5a5a3a 100%);
  transform: translateY(-4px);
  box-shadow: 0 10px 30px rgba(122, 122, 90, 0.4);
}

/* Responsive */
@media (max-width: 768px) {
  .patients-header {
    padding: 30px 20px;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
  }
  
  .header-title {
    font-size: 2rem;
  }
  
  .actions-bar {
    flex-direction: column;
    align-items: stretch;
    padding: 0 20px;
  }
  
  .search-container {
    max-width: 100%;
    min-width: 100%;
  }
  
  .actions-buttons {
    flex-direction: column;
  }
  
  .patients-grid {
    grid-template-columns: 1fr;
    padding: 0 20px;
  }
  
  .patient-actions {
    flex-direction: column;
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
</style>