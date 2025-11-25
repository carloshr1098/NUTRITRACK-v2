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
      <div class="modal-content">
        <div class="modal-header">
          <div class="modal-title-section">
            <span class="modal-icon">{{ modoEdicion ? '✏️' : '➕' }}</span>
            <h3 class="modal-title">{{ modoEdicion ? 'Editar Paciente' : 'Nuevo Paciente' }}</h3>
          </div>
          <button 
            @click="cancelarFormulario"
            class="btn-close-modal"
            title="Cerrar"
          >
            ✖
          </button>
        </div>
        
        <form @submit.prevent="modoEdicion ? actualizarPaciente() : crearPaciente()" class="modal-form">
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Nombre *</label>
              <input 
                v-model="nuevoPaciente.primerNombre" 
                type="text" 
                required
                @blur="nuevoPaciente.primerNombre = capitalizarNombre(nuevoPaciente.primerNombre)"
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Apellido *</label>
              <input 
                v-model="nuevoPaciente.primerApellido" 
                type="text" 
                required
                @blur="nuevoPaciente.primerApellido = capitalizarNombre(nuevoPaciente.primerApellido)"
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Fecha de Nacimiento *</label>
              <input 
                v-model="nuevoPaciente.fechaNacimiento" 
                type="date" 
                required
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Género *</label>
              <select 
                v-model="nuevoPaciente.genero" 
                required
                class="form-select"
              >
                <option value="">Seleccionar...</option>
                <option value="M">Masculino</option>
                <option value="F">Femenino</option>
                <option value="O">Otro</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Altura (cm) *</label>
              <input 
                v-model.number="nuevoPaciente.altura" 
                type="number" 
                step="0.01"
                min="0"
                required
                @keypress="soloNumeros"
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Peso Actual (kg) *</label>
              <input 
                v-model.number="nuevoPaciente.pesoActual" 
                type="number" 
                step="0.01"
                min="0"
                required
                @keypress="soloNumeros"
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Email</label>
              <input 
                v-model="nuevoPaciente.email" 
                type="email" 
                class="form-input"
              >
            </div>
            <div class="form-group">
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
            <div class="form-group form-group-full">
              <label class="form-label">Nivel de Actividad</label>
              <select 
                v-model="nuevoPaciente.nivelActividad" 
                class="form-select"
              >
                <option value="">Seleccionar...</option>
                <option value="SEDENTARIO">Sedentario</option>
                <option value="LIGERO">Actividad Ligera</option>
                <option value="MODERADO">Actividad Moderada</option>
                <option value="ACTIVO">Activo</option>
                <option value="MUY_ACTIVO">Muy Activo</option>
              </select>
            </div>
            <div class="form-group form-group-full">
              <label class="form-label">Condiciones Médicas</label>
              <textarea 
                v-model="nuevoPaciente.condicionesMedicas" 
                rows="3"
                class="form-textarea"
              ></textarea>
            </div>
            <div class="form-group form-group-full">
              <label class="form-label">Alergias</label>
              <textarea 
                v-model="nuevoPaciente.alergias" 
                rows="2"
                class="form-textarea"
              ></textarea>
            </div>
            <div class="form-group form-group-full">
              <label class="form-label">Restricciones Dietéticas</label>
              <textarea 
                v-model="nuevoPaciente.restriccionesDieteticas" 
                rows="2"
                class="form-textarea"
              ></textarea>
            </div>
            <div class="form-group">
              <label class="form-label">Contacto de Emergencia - Nombre</label>
              <input 
                v-model="nuevoPaciente.contactoEmergenciaNombre" 
                type="text"
                @blur="nuevoPaciente.contactoEmergenciaNombre = capitalizarNombre(nuevoPaciente.contactoEmergenciaNombre)"
                class="form-input"
              >
            </div>
            <div class="form-group">
              <label class="form-label">Contacto de Emergencia - Teléfono</label>
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
          
          <div v-if="errorCreacion" class="alert alert-error">
            <strong>⚠️ Error:</strong> {{ errorCreacion }}
          </div>
          
          <div v-if="exitoCreacion" class="alert alert-success">
            <strong>✅ ¡Éxito!</strong> Paciente {{ modoEdicion ? 'actualizado' : 'creado' }} correctamente.
          </div>
          
          <div class="modal-actions">
            <button 
              type="button"
              @click="cancelarFormulario" 
              class="btn-modal btn-cancel"
            >
              Cancelar
            </button>
            <button 
              type="submit"
              :disabled="guardando"
              class="btn-modal btn-save"
            >
              {{ guardando ? 'Guardando...' : (modoEdicion ? 'Actualizar Paciente' : 'Guardar Paciente') }}
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
    
    <div v-else class="patients-grid">
      <div 
        v-for="paciente in pacientes" 
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
  justify-content: flex-end;
  align-items: center;
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

/* Modal Overlay */
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
  padding: 30px 20px;
  animation: fadeIn 0.3s ease;
  overflow-y: auto;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Modal Content */
.modal-content {
  background: white;
  border-radius: 20px;
  max-width: 900px;
  width: 100%;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: slideUp 0.3s ease;
  position: relative;
}

@keyframes slideUp {
  from {
    transform: translateY(50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Modal Header */
.modal-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 25px 30px;
  border-radius: 20px 20px 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.modal-title-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.modal-icon {
  font-size: 32px;
  filter: drop-shadow(2px 2px 4px rgba(0, 0, 0, 0.2));
}

.modal-title {
  margin: 0;
  color: white;
  font-size: 28px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.btn-close-modal {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  font-size: 24px;
  cursor: pointer;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  font-weight: 300;
}

.btn-close-modal:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: rotate(90deg) scale(1.1);
}

/* Modal Form */
.modal-form {
  padding: 30px;
  overflow-y: auto;
  flex: 1;
}

/* Form Grid */
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group-full {
  grid-column: 1 / -1;
}

.form-label {
  font-weight: 600;
  color: #2c3e50;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.form-input,
.form-select,
.form-textarea {
  padding: 12px 15px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f8f9fa;
  font-family: inherit;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  outline: none;
  border-color: #8bc34a;
  background: white;
  box-shadow: 0 0 0 4px rgba(139, 195, 74, 0.1);
}

.form-input:hover,
.form-select:hover,
.form-textarea:hover {
  border-color: #bdbdbd;
}

.form-textarea {
  resize: vertical;
  min-height: 80px;
}

/* Alerts */
.alert {
  padding: 15px 20px;
  border-radius: 12px;
  margin-bottom: 20px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from {
    transform: translateY(-10px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.alert-error {
  background: rgba(255, 82, 82, 0.1);
  color: #ff5252;
  border: 2px solid #ff5252;
}

.alert-success {
  background: rgba(139, 195, 74, 0.1);
  color: #8bc34a;
  border: 2px solid #8bc34a;
}

/* Modal Actions */
.modal-actions {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  padding-top: 20px;
  border-top: 2px solid #f0f0f0;
}

.btn-modal {
  padding: 12px 30px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 15px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-modal:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none !important;
}

.btn-cancel {
  background: linear-gradient(135deg, #7a7a5a 0%, #6a6a4a 100%);
  color: white;
}

.btn-cancel:hover:not(:disabled) {
  background: linear-gradient(135deg, #6a6a4a 0%, #5a5a3a 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(122, 122, 90, 0.3);
}

.btn-save {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  color: white;
}

.btn-save:hover:not(:disabled) {
  background: linear-gradient(135deg, #7ab73f 0%, #6aa72f 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(139, 195, 74, 0.3);
}

/* Responsive Modal */
@media (max-width: 768px) {
  .modal-overlay {
    padding: 10px;
  }
  
  .modal-content {
    max-height: 95vh;
  }
  
  .modal-header {
    padding: 20px;
  }
  
  .modal-title {
    font-size: 22px;
  }
  
  .modal-icon {
    font-size: 28px;
  }
  
  .modal-form {
    padding: 20px;
  }
  
  .form-grid {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .modal-actions {
    flex-direction: column;
  }
  
  .btn-modal {
    width: 100%;
    justify-content: center;
  }
}
</style>