<template>
  <div style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <h1 style="color: #2c3e50; margin-bottom: 20px;">Gestión de Pacientes</h1>
    
    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
      <h2 style="margin: 0 0 10px 0; color: #007bff;">👨‍⚕️ Panel del Nutriólogo</h2>
      <p style="margin: 0; color: #666;">Administrar información de pacientes</p>
    </div>
    
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
      <h3 style="margin: 0; color: #333;">Lista de Pacientes</h3>
      <button 
        @click="crearPaciente" 
        style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
      >
        + Nuevo Paciente
      </button>
    </div>
    
    <div v-if="loading" style="text-align: center; padding: 40px;">
      <p>Cargando pacientes...</p>
    </div>
    
    <div v-else-if="error" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
      Error: {{ error }}
    </div>
    
    <div v-else>
      <div v-if="pacientes.length === 0" style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px;">
        <p style="color: #666; margin: 0;">No hay pacientes registrados aún.</p>
      </div>
      
      <div v-else style="display: grid; gap: 15px;">
        <div 
          v-for="paciente in pacientes" 
          :key="paciente.id" 
          style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: white;"
        >
          <div style="display: flex; justify-content: space-between; align-items: start;">
            <div>
              <h4 style="margin: 0 0 10px 0; color: #2c3e50;">
                {{ paciente.primerNombre }} {{ paciente.primerApellido }}
              </h4>
              <p style="margin: 5px 0; color: #666;">
                <strong>Email:</strong> {{ paciente.email }}
              </p>
              <p style="margin: 5px 0; color: #666;">
                <strong>Teléfono:</strong> {{ paciente.telefono }}
              </p>
              <p style="margin: 5px 0; color: #666;">
                <strong>Edad:</strong> {{ paciente.edad }} años
              </p>
            </div>
            <div style="display: flex; gap: 10px;">
              <button 
                @click="editarPaciente(paciente)" 
                style="padding: 8px 15px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;"
              >
                Editar
              </button>
              <button 
                @click="eliminarPaciente(paciente.id)" 
                style="padding: 8px 15px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer;"
              >
                Eliminar
              </button>
            </div>
          </div>
        </div>
      </div>
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
      loading: true,
      error: null
    }
  },
  async mounted() {
    await this.cargarPacientes()
  },
  methods: {
    async cargarPacientes() {
      try {
        this.loading = true
        this.error = null
        const response = await api.get('/pacientes')
        this.pacientes = response.data || []
      } catch (error) {
        console.error('Error cargando pacientes:', error)
        this.error = error.message || 'Error al cargar pacientes'
      } finally {
        this.loading = false
      }
    },
    crearPaciente() {
      alert('Función "Crear Paciente" - Por implementar')
    },
    editarPaciente(paciente) {
      alert(`Editando paciente: ${paciente.primerNombre} ${paciente.primerApellido}`)
    },
    async eliminarPaciente(id) {
      if (confirm('¿Estás seguro de que quieres eliminar este paciente?')) {
        try {
          await api.delete(`/pacientes/${id}`)
          await this.cargarPacientes()
          alert('Paciente eliminado exitosamente')
        } catch (error) {
          console.error('Error eliminando paciente:', error)
          alert('Error al eliminar paciente')
        }
      }
    }
  }
}
</script>