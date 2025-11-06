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
        @click="cargarPacientes" 
        style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
      >
        🔄 Cargar Pacientes
      </button>
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
      primeraCarga: true
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
    }
  }
}
</script>