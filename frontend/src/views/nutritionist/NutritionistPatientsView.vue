<template>
  <div style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <h1 style="color: #2c3e50; margin-bottom: 20px;">Gestión de Pacientes</h1>
    
    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
      <h2 style="margin: 0 0 10px 0; color: #007bff;">👨‍⚕️ Panel del Nutriólogo</h2>
      <p style="margin: 0; color: #666;">Administrar información de pacientes</p>
    </div>
    
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
      <h3 style="margin: 0; color: #333;">Lista de Pacientes</h3>
      <div style="display: flex; gap: 10px;">
        <button 
          @click="mostrarFormulario = !mostrarFormulario" 
          style="padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;"
        >
          {{ mostrarFormulario ? '✖ Cancelar' : '➕ Nuevo Paciente' }}
        </button>
        <button 
          @click="cargarPacientes" 
          style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
        >
          🔄 Cargar Pacientes
        </button>
      </div>
    </div>

    <!-- Modal de formulario para nuevo/editar paciente -->
    <div v-if="mostrarFormulario" 
         style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; overflow-y: auto; padding: 20px;"
         @click.self="cancelarFormulario">
      <div style="background: white; padding: 30px; border-radius: 8px; max-width: 800px; width: 100%; max-height: 90vh; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #007bff; padding-bottom: 10px;">
          <h3 style="margin: 0; color: #007bff;">{{ modoEdicion ? 'Editar Paciente' : 'Nuevo Paciente' }}</h3>
          <button 
            @click="cancelarFormulario"
            style="background: none; border: none; font-size: 24px; cursor: pointer; color: #6c757d; padding: 0; width: 30px; height: 30px; line-height: 1;"
            title="Cerrar"
          >
            ✖
          </button>
        </div>
        
        <form @submit.prevent="modoEdicion ? actualizarPaciente() : crearPaciente()">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Nombre *</label>
              <input 
                v-model="nuevoPaciente.primerNombre" 
                type="text" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Apellido *</label>
              <input 
                v-model="nuevoPaciente.primerApellido" 
                type="text" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Fecha de Nacimiento *</label>
              <input 
                v-model="nuevoPaciente.fechaNacimiento" 
                type="date" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Género *</label>
              <select 
                v-model="nuevoPaciente.genero" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
                <option value="">Seleccionar...</option>
                <option value="M">Masculino</option>
                <option value="F">Femenino</option>
                <option value="O">Otro</option>
              </select>
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Altura (cm) *</label>
              <input 
                v-model.number="nuevoPaciente.altura" 
                type="number" 
                step="0.01"
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Peso Actual (kg) *</label>
              <input 
                v-model.number="nuevoPaciente.pesoActual" 
                type="number" 
                step="0.01"
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Email</label>
              <input 
                v-model="nuevoPaciente.email" 
                type="email" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Teléfono</label>
              <input 
                v-model="nuevoPaciente.telefono" 
                type="tel" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Nivel de Actividad</label>
              <select 
                v-model="nuevoPaciente.nivelActividad" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
                <option value="">Seleccionar...</option>
                <option value="SEDENTARIO">Sedentario</option>
                <option value="LIGERO">Actividad Ligera</option>
                <option value="MODERADO">Actividad Moderada</option>
                <option value="ACTIVO">Activo</option>
                <option value="MUY_ACTIVO">Muy Activo</option>
              </select>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Condiciones Médicas</label>
              <textarea 
                v-model="nuevoPaciente.condicionesMedicas" 
                rows="3"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Alergias</label>
              <textarea 
                v-model="nuevoPaciente.alergias" 
                rows="2"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Restricciones Dietéticas</label>
              <textarea 
                v-model="nuevoPaciente.restriccionesDieteticas" 
                rows="2"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contacto de Emergencia - Nombre</label>
              <input 
                v-model="nuevoPaciente.contactoEmergenciaNombre" 
                type="text" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contacto de Emergencia - Teléfono</label>
              <input 
                v-model="nuevoPaciente.contactoEmergenciaTelefono" 
                type="tel" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
          </div>
          
          <div v-if="errorCreacion" style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
            <strong>Error:</strong> {{ errorCreacion }}
          </div>
          
          <div v-if="exitoCreacion" style="background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
            <strong>¡Éxito!</strong> Paciente {{ modoEdicion ? 'actualizado' : 'creado' }} correctamente.
          </div>
          
          <div style="margin-top: 20px; display: flex; gap: 10px; justify-content: flex-end;">
            <button 
              type="button"
              @click="cancelarFormulario" 
              style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;"
            >
              Cancelar
            </button>
            <button 
              type="submit"
              :disabled="guardando"
              style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
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
    
    <div v-else style="display: grid; gap: 15px;">
      <div 
        v-for="paciente in pacientes" 
        :key="paciente.id" 
        style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: white;"
      >
        <div style="display: flex; justify-content: space-between; align-items: start;">
          <div style="flex: 1;">
            <h4 style="margin: 0 0 10px 0; color: #2c3e50;">
              {{ paciente.firstName }} {{ paciente.lastName }}
            </h4>
            <p style="margin: 5px 0; color: #666;">
              <strong>Fecha de Nacimiento:</strong> {{ paciente.dateOfBirth || 'No especificada' }}
            </p>
            <p style="margin: 5px 0; color: #666;">
              <strong>Género:</strong> {{ paciente.gender || 'No especificado' }}
            </p>
            <p style="margin: 5px 0; color: #666;">
              <strong>Altura:</strong> {{ paciente.height ? paciente.height + ' cm' : 'No especificada' }}
            </p>
            <p style="margin: 5px 0; color: #666;">
              <strong>Peso Actual:</strong> {{ paciente.currentWeight ? paciente.currentWeight + ' kg' : 'No especificado' }}
            </p>
            <p v-if="paciente.activityLevel" style="margin: 5px 0; color: #666;">
              <strong>Nivel de Actividad:</strong> {{ paciente.activityLevel }}
            </p>
            <p v-if="paciente.medicalConditions" style="margin: 5px 0; color: #666;">
              <strong>Condiciones Médicas:</strong> {{ paciente.medicalConditions }}
            </p>
            <p v-if="paciente.allergies" style="margin: 5px 0; color: #666;">
              <strong>Alergias:</strong> {{ paciente.allergies }}
            </p>
          </div>
          <div style="display: flex; flex-direction: column; gap: 10px; margin-left: 20px;">
            <button 
              @click="verDetalle(paciente.id)"
              style="padding: 8px 15px; background: #17a2b8; color: white; border: none; border-radius: 4px; cursor: pointer; white-space: nowrap;"
            >
              👁️ Ver Detalle
            </button>
            <button 
              @click="editarPaciente(paciente)"
              style="padding: 8px 15px; background: #ffc107; color: #000; border: none; border-radius: 4px; cursor: pointer; white-space: nowrap;"
            >
              ✏️ Editar
            </button>
            <button 
              @click="confirmarEliminar(paciente)"
              style="padding: 8px 15px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; white-space: nowrap;"
            >
              🗑️ Eliminar
            </button>
          </div>
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
    
    <div style="margin-top: 30px; text-align: center;">
      <router-link 
        to="/dashboard" 
        style="display: inline-block; padding: 10px 30px; background: #6c757d; color: white; text-decoration: none; border-radius: 4px;"
      >
        ← Volver al Dashboard
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
    // Verificar si hay un paciente pendiente de editar
    const editarPacienteId = localStorage.getItem('editarPacienteId')
    if (editarPacienteId) {
      localStorage.removeItem('editarPacienteId')
      // Cargar pacientes primero
      this.cargarPacientes().then(() => {
        // Buscar el paciente en la lista cargada
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
        
        // Convertir nombres de campos de español a inglés
        const datosCreacion = {
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
    }
  }
}
</script>