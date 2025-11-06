<template>
  <div style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <div style="margin-bottom: 20px;">
      <button 
        @click="$router.back()"
        style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;"
      >
        ← Volver
      </button>
    </div>

    <div v-if="loading" style="text-align: center; padding: 40px;">
      <p>Cargando información del paciente...</p>
    </div>

    <div v-else-if="error" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px;">
      <strong>Error:</strong> {{ error }}
    </div>

    <div v-else-if="paciente">
      <!-- Información básica del paciente -->
      <div style="background: white; border: 1px solid #ddd; border-radius: 8px; padding: 25px; margin-bottom: 20px;">
        <h1 style="margin: 0 0 20px 0; color: #2c3e50;">
          {{ paciente.firstName }} {{ paciente.lastName }}
        </h1>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
          <div>
            <h3 style="margin: 0 0 15px 0; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 5px;">
              Información Personal
            </h3>
            <p style="margin: 8px 0;"><strong>ID:</strong> {{ paciente.id }}</p>
            <p style="margin: 8px 0;"><strong>Fecha de Nacimiento:</strong> {{ paciente.dateOfBirth || 'No especificada' }}</p>
            <p style="margin: 8px 0;"><strong>Edad:</strong> {{ calcularEdad(paciente.dateOfBirth) }} años</p>
            <p style="margin: 8px 0;"><strong>Género:</strong> {{ obtenerGeneroTexto(paciente.gender) }}</p>
            <p style="margin: 8px 0;"><strong>Email:</strong> {{ paciente.email || 'No especificado' }}</p>
            <p style="margin: 8px 0;"><strong>Teléfono:</strong> {{ paciente.phone || 'No especificado' }}</p>
          </div>

          <div>
            <h3 style="margin: 0 0 15px 0; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 5px;">
              Medidas Físicas
            </h3>
            <p style="margin: 8px 0;"><strong>Altura:</strong> {{ paciente.height ? paciente.height + ' cm' : 'No especificada' }}</p>
            <p style="margin: 8px 0;"><strong>Peso Actual:</strong> {{ paciente.currentWeight ? paciente.currentWeight + ' kg' : 'No especificado' }}</p>
            <p style="margin: 8px 0;"><strong>IMC:</strong> {{ calcularIMC(paciente.height, paciente.currentWeight) }}</p>
            <p style="margin: 8px 0;"><strong>Nivel de Actividad:</strong> {{ paciente.activityLevel || 'No especificado' }}</p>
          </div>

          <div>
            <h3 style="margin: 0 0 15px 0; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 5px;">
              Información Médica
            </h3>
            <p style="margin: 8px 0;"><strong>Alergias:</strong> {{ paciente.allergies || 'Ninguna registrada' }}</p>
            <p style="margin: 8px 0;"><strong>Condiciones Médicas:</strong> {{ paciente.medicalConditions || 'Ninguna registrada' }}</p>
            <p style="margin: 8px 0;"><strong>Restricciones Dietéticas:</strong> {{ paciente.dietaryRestrictions || 'Ninguna' }}</p>
          </div>
        </div>

        <div v-if="paciente.emergencyContactName || paciente.emergencyContactPhone" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd;">
          <h3 style="margin: 0 0 15px 0; color: #dc3545;">
            🚨 Contacto de Emergencia
          </h3>
          <p style="margin: 8px 0;"><strong>Nombre:</strong> {{ paciente.emergencyContactName || 'No especificado' }}</p>
          <p style="margin: 8px 0;"><strong>Teléfono:</strong> {{ paciente.emergencyContactPhone || 'No especificado' }}</p>
        </div>

        <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 14px;">
          <p style="margin: 5px 0;"><strong>Registro creado:</strong> {{ formatearFecha(paciente.createdAt) }}</p>
          <p style="margin: 5px 0;"><strong>Última actualización:</strong> {{ formatearFecha(paciente.updatedAt) }}</p>
        </div>
      </div>

      <!-- Historial de Peso -->
      <div style="background: white; border: 1px solid #ddd; border-radius: 8px; padding: 25px; margin-bottom: 20px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
          <h2 style="margin: 0; color: #2c3e50;">📊 Historial de Peso</h2>
          <button 
            @click="mostrarFormularioPeso = !mostrarFormularioPeso"
            style="padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px;"
          >
            {{ mostrarFormularioPeso ? '✖ Cancelar' : '➕ Registrar Peso' }}
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
            <p style="margin: 5px 0;"><strong>Hora:</strong> {{ appointment.appointmentTime }}</p>
            <p style="margin: 5px 0;"><strong>Estado:</strong> {{ appointment.status }}</p>
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

    <!-- Modal de edición -->
    <div v-if="mostrarModalEdicion" 
         style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; overflow-y: auto; padding: 20px;"
         @click.self="cerrarModalEdicion">
      <div style="background: white; padding: 30px; border-radius: 8px; max-width: 800px; width: 100%; max-height: 90vh; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #ffc107; padding-bottom: 10px;">
          <h3 style="margin: 0; color: #ffc107;">✏️ Editar Paciente</h3>
          <button 
            @click="cerrarModalEdicion"
            style="background: none; border: none; font-size: 24px; cursor: pointer; color: #6c757d; padding: 0; width: 30px; height: 30px; line-height: 1;"
            title="Cerrar"
          >
            ✖
          </button>
        </div>
        
        <form @submit.prevent="actualizarPaciente">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Nombre *</label>
              <input 
                v-model="formEdicion.firstName" 
                type="text" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Apellido *</label>
              <input 
                v-model="formEdicion.lastName" 
                type="text" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Fecha de Nacimiento *</label>
              <input 
                v-model="formEdicion.dateOfBirth" 
                type="date" 
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Género *</label>
              <select 
                v-model="formEdicion.gender" 
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
                v-model.number="formEdicion.height" 
                type="number" 
                step="0.01"
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Peso Actual (kg) *</label>
              <input 
                v-model.number="formEdicion.currentWeight" 
                type="number" 
                step="0.01"
                required
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Email</label>
              <input 
                v-model="formEdicion.email" 
                type="email" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Teléfono</label>
              <input 
                v-model="formEdicion.phone" 
                type="tel" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Nivel de Actividad</label>
              <select 
                v-model="formEdicion.activityLevel" 
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
                v-model="formEdicion.medicalConditions" 
                rows="3"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Alergias</label>
              <textarea 
                v-model="formEdicion.allergies" 
                rows="2"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div style="grid-column: 1 / -1;">
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Restricciones Dietéticas</label>
              <textarea 
                v-model="formEdicion.dietaryRestrictions" 
                rows="2"
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              ></textarea>
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contacto de Emergencia - Nombre</label>
              <input 
                v-model="formEdicion.emergencyContactName" 
                type="text" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
            <div>
              <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contacto de Emergencia - Teléfono</label>
              <input 
                v-model="formEdicion.emergencyContactPhone" 
                type="tel" 
                style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
              >
            </div>
          </div>
          
          <div v-if="errorEdicion" style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;">
            <strong>Error:</strong> {{ errorEdicion }}
          </div>
          
          <div v-if="exitoEdicion" style="background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;">
            <strong>¡Éxito!</strong> Paciente actualizado correctamente.
          </div>
          
          <div style="margin-top: 20px; display: flex; gap: 10px; justify-content: flex-end;">
            <button 
              type="button"
              @click="cerrarModalEdicion" 
              style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;"
            >
              Cancelar
            </button>
            <button 
              type="submit"
              :disabled="guardando"
              style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;"
            >
              {{ guardando ? 'Guardando...' : 'Actualizar Paciente' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import api from '../../services/api.js'
import jsPDF from 'jspdf'
import WeightChart from '../../components/WeightChart.vue'

export default {
  name: 'PatientDetailView',
  components: {
    WeightChart
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
  },
  methods: {
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
    
    generarFichaPDF() {
      try {
        const doc = new jsPDF()
        let y = 20 // Posición vertical inicial
        
        // ==================== ENCABEZADO CON DISEÑO ====================
        // Banner superior verde
        doc.setFillColor(76, 175, 80) // Verde #4CAF50
        doc.rect(0, 0, 210, 35, 'F')
        
        // Logo/Icono (simulado con círculo)
        doc.setFillColor(255, 255, 255)
        doc.circle(20, 17, 8, 'F')
        doc.setFontSize(16)
        doc.setTextColor(76, 175, 80)
        doc.text('N', 20, 20, { align: 'center' })
        
        // Título principal en blanco
        doc.setFontSize(24)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(255, 255, 255)
        doc.text('EXPEDIENTE MÉDICO', 105, 18, { align: 'center' })
        
        // Subtítulo
        doc.setFontSize(10)
        doc.setFont('helvetica', 'normal')
        doc.text('Sistema NutriTrack - Gestión Nutricional', 105, 26, { align: 'center' })
        
        y = 45
        y = 45
        
        // ==================== INFORMACIÓN PERSONAL ====================
        // Caja con borde y fondo
        doc.setFillColor(245, 245, 245) // Gris claro
        doc.setDrawColor(76, 175, 80) // Verde
        doc.setLineWidth(0.5)
        doc.roundedRect(15, y, 180, 65, 3, 3, 'FD')
        
        // Título de sección con icono
        y += 8
        doc.setFontSize(14)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(76, 175, 80)
        doc.text('INFORMACION PERSONAL', 20, y)
        
        y += 8
        doc.setFontSize(10)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        // Dividir en dos columnas
        const col1X = 20
        const col2X = 110
        let yTemp = y
        
        // Columna 1
        doc.setFont('helvetica', 'bold')
        doc.text('ID Paciente:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(String(this.paciente.id), col1X + 25, yTemp)
        yTemp += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('Nombre:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.firstName} ${this.paciente.lastName}`, col1X + 25, yTemp)
        yTemp += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('Fecha Nac.:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(this.formatearFecha(this.paciente.dateOfBirth), col1X + 25, yTemp)
        yTemp += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('Edad:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.calcularEdad(this.paciente.dateOfBirth)} años`, col1X + 25, yTemp)
        yTemp += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('Género:', col1X, yTemp)
        doc.setFont('helvetica', 'normal')
        doc.text(this.paciente.gender === 'M' ? 'Masculino' : this.paciente.gender === 'F' ? 'Femenino' : 'Otro', col1X + 25, yTemp)
        
        // Columna 2
        yTemp = y
        if (this.paciente.email) {
          doc.setFont('helvetica', 'bold')
          doc.text('Email:', col2X, yTemp)
          doc.setFont('helvetica', 'normal')
          doc.text(this.paciente.email.substring(0, 30), col2X + 18, yTemp)
          yTemp += 6
        }
        
        if (this.paciente.phone) {
          doc.setFont('helvetica', 'bold')
          doc.text('Teléfono:', col2X, yTemp)
          doc.setFont('helvetica', 'normal')
          doc.text(this.paciente.phone, col2X + 18, yTemp)
          yTemp += 6
        }
        
        y += 58
        
        // ==================== MEDIDAS FÍSICAS ====================
        // Caja con gradiente simulado
        doc.setFillColor(232, 245, 233) // Verde muy claro
        doc.setDrawColor(76, 175, 80)
        doc.setLineWidth(0.5)
        doc.roundedRect(15, y, 85, 42, 3, 3, 'FD')
        
        y += 8
        doc.setFontSize(14)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(76, 175, 80)
        doc.text('MEDIDAS FISICAS', 20, y)
        
        y += 8
        doc.setFontSize(10)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        doc.setFont('helvetica', 'bold')
        doc.text('Altura:', 20, y)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.height} cm`, 40, y)
        y += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('Peso:', 20, y)
        doc.setFont('helvetica', 'normal')
        doc.text(`${this.paciente.currentWeight} kg`, 40, y)
        y += 6
        
        doc.setFont('helvetica', 'bold')
        doc.text('IMC:', 20, y)
        doc.setFont('helvetica', 'normal')
        const imc = this.calcularIMC()
        doc.text(imc, 40, y)
        y += 6
        
        const niveles = {
          'SEDENTARY': 'Sedentario',
          'LIGHTLY_ACTIVE': 'Ligeramente Activo',
          'MODERATELY_ACTIVE': 'Moderadamente Activo',
          'VERY_ACTIVE': 'Muy Activo',
          'EXTRA_ACTIVE': 'Extremadamente Activo'
        }
        doc.setFont('helvetica', 'bold')
        doc.text('Actividad:', 20, y)
        doc.setFont('helvetica', 'normal')
        const actividadTexto = niveles[this.paciente.activityLevel] || this.paciente.activityLevel
        doc.text(actividadTexto.substring(0, 18), 40, y)
        
        y -= 26 // Volver arriba para la caja de al lado
        y -= 26 // Volver arriba para la caja de al lado
        
        // ==================== CONTACTO DE EMERGENCIA (al lado) ====================
        if (this.paciente.emergencyContactName || this.paciente.emergencyContactPhone) {
          doc.setFillColor(255, 243, 224) // Naranja muy claro
          doc.setDrawColor(255, 152, 0) // Naranja
          doc.setLineWidth(0.5)
          doc.roundedRect(110, y, 85, 42, 3, 3, 'FD')
          
          y += 8
          doc.setFontSize(14)
          doc.setFont('helvetica', 'bold')
          doc.setTextColor(255, 152, 0)
          doc.text('EMERGENCIA', 115, y)
          
          y += 8
          doc.setFontSize(10)
          doc.setFont('helvetica', 'normal')
          doc.setTextColor(60, 60, 60)
          
          if (this.paciente.emergencyContactName) {
            doc.setFont('helvetica', 'bold')
            doc.text('Contacto:', 115, y)
            doc.setFont('helvetica', 'normal')
            doc.text(this.paciente.emergencyContactName.substring(0, 20), 115, y + 6)
            y += 12
          }
          
          if (this.paciente.emergencyContactPhone) {
            doc.setFont('helvetica', 'bold')
            doc.text('Teléfono:', 115, y)
            doc.setFont('helvetica', 'normal')
            doc.text(this.paciente.emergencyContactPhone, 115, y + 6)
          }
          
          y += 20
        } else {
          y += 42
        }
        
        y += 10
        
        // ==================== INFORMACIÓN MÉDICA ====================
        doc.setFillColor(255, 245, 245) // Rojo muy claro
        doc.setDrawColor(244, 67, 54) // Rojo
        doc.setLineWidth(0.5)
        doc.roundedRect(15, y, 180, 90, 3, 3, 'FD')
        
        y += 8
        doc.setFontSize(14)
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('INFORMACION MEDICA', 20, y)
        y += 10
        
        doc.setFontSize(10)
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        // Condiciones Médicas
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('* Condiciones Medicas:', 20, y)
        y += 5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.medicalConditions) {
          const condiciones = doc.splitTextToSize(this.paciente.medicalConditions, 165)
          doc.text(condiciones, 23, y)
          y += (condiciones.length * 5) + 3
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin condiciones registradas', 23, y)
          doc.setTextColor(60, 60, 60)
          y += 8
        }
        
        // Alergias
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('* Alergias:', 20, y)
        y += 5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.allergies) {
          const alergias = doc.splitTextToSize(this.paciente.allergies, 165)
          doc.text(alergias, 23, y)
          y += (alergias.length * 5) + 3
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin alergias registradas', 23, y)
          doc.setTextColor(60, 60, 60)
          doc.setTextColor(150, 150, 150)
          doc.text('Sin alergias registradas', 23, y)
          doc.setTextColor(60, 60, 60)
          y += 8
        }
        
        // Restricciones Dietéticas
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(244, 67, 54)
        doc.text('* Restricciones Dieteticas:', 20, y)
        y += 5
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(60, 60, 60)
        
        if (this.paciente.dietaryRestrictions) {
          const restricciones = doc.splitTextToSize(this.paciente.dietaryRestrictions, 165)
          doc.text(restricciones, 23, y)
          y += (restricciones.length * 5) + 5
        } else {
          doc.setTextColor(150, 150, 150)
          doc.text('Sin restricciones registradas', 23, y)
          doc.setTextColor(60, 60, 60)
          y += 10
        }
        
        y += 5
        
        // ==================== GRÁFICA DE PESO (Nueva Página) ====================
        if (this.weightRecords && this.weightRecords.length > 0 && this.$refs.weightChart) {
          // Nueva página para la gráfica
          doc.addPage()
          y = 20
          
          // Banner verde para la segunda página
          doc.setFillColor(76, 175, 80)
          doc.rect(0, 0, 210, 15, 'F')
          doc.setFontSize(16)
          doc.setFont('helvetica', 'bold')
          doc.setTextColor(255, 255, 255)
          doc.text('EVOLUCION DEL PESO', 105, 10, { align: 'center' })
          
          y = 25
          y = 25
          
          try {
            // Obtener el canvas de Chart.js
            const chartComponent = this.$refs.weightChart
            const canvas = chartComponent.$el.querySelector('canvas')
            
            if (canvas) {
              // Caja con sombra para la gráfica
              doc.setFillColor(255, 255, 255)
              doc.setDrawColor(200, 200, 200)
              doc.setLineWidth(0.5)
              doc.roundedRect(15, y, 180, 115, 3, 3, 'FD')
              
              y += 5
              
              // Convertir el canvas a imagen base64
              const imgData = canvas.toDataURL('image/png', 1.0)
              
              // Agregar la imagen al PDF (centrada en la caja)
              const imgWidth = 170
              const imgHeight = 105
              const imgX = (210 - imgWidth) / 2
              
              doc.addImage(imgData, 'PNG', imgX, y, imgWidth, imgHeight)
              y += imgHeight + 15
              
              // ==================== TABLA DE REGISTROS ====================
              doc.setFillColor(245, 245, 245)
              doc.setDrawColor(76, 175, 80)
              doc.roundedRect(15, y, 180, 10, 2, 2, 'FD')
              
              y += 7
              doc.setFontSize(12)
              doc.setFont('helvetica', 'bold')
              doc.setTextColor(76, 175, 80)
              doc.text('Detalle de Registros', 20, y)
              
              y += 8
              
              // Encabezados de la tabla con fondo
              doc.setFillColor(232, 245, 233)
              doc.rect(15, y - 5, 180, 8, 'F')
              
              doc.setFontSize(9)
              doc.setFont('helvetica', 'bold')
              doc.setTextColor(60, 60, 60)
              doc.text('Fecha', 20, y)
              doc.text('Peso (kg)', 60, y)
              doc.text('Diferencia', 100, y)
              doc.text('Notas', 140, y)
              
              y += 6
              doc.setFont('helvetica', 'normal')
              doc.setFontSize(8)
              
              // Línea divisoria
              doc.setDrawColor(200, 200, 200)
              doc.setLineWidth(0.3)
              doc.line(15, y - 2, 195, y - 2)
              
              // Registros (mostrar los últimos 15)
              const registrosParaMostrar = this.weightRecords.slice(-15)
              let alternarColor = false
              
              registrosParaMostrar.forEach((record, index) => {
                if (y > 270) {
                  doc.addPage()
                  y = 20
                }
                
                // Alternar color de fondo para filas
                if (alternarColor) {
                  doc.setFillColor(250, 250, 250)
                  doc.rect(15, y - 4, 180, 6, 'F')
                }
                alternarColor = !alternarColor
                
                doc.setTextColor(60, 60, 60)
                const fecha = new Date(record.recordDate).toLocaleDateString('es-MX')
                doc.text(fecha, 20, y)
                doc.text(record.weight.toString(), 60, y)
                
                // Calcular diferencia con el registro anterior
                if (index > 0) {
                  const diff = record.weight - registrosParaMostrar[index - 1].weight
                  const diffText = diff > 0 ? `^ +${diff.toFixed(1)}` : `v ${diff.toFixed(1)}`
                  
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
                  const notasTruncadas = record.notes.substring(0, 22) + (record.notes.length > 22 ? '...' : '')
                  doc.setTextColor(100, 100, 100)
                  doc.text(notasTruncadas, 140, y)
                  doc.setTextColor(60, 60, 60)
                }
                
                y += 6
              })
            }
          } catch (error) {
            console.error('Error agregando gráfica al PDF:', error)
            doc.setFontSize(10)
            doc.setTextColor(244, 67, 54)
            doc.text('Error al generar la grafica', 20, y)
            y += 10
          }
        }
        
        // ==================== FOOTER PROFESIONAL ====================
        const totalPages = doc.internal.getNumberOfPages()
        const fechaGeneracion = new Date().toLocaleString('es-MX', { 
          year: 'numeric', 
          month: 'long', 
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        })
        
        // Agregar footer en todas las páginas
        for (let i = 1; i <= totalPages; i++) {
          doc.setPage(i)
          
          // Línea superior del footer
          doc.setDrawColor(76, 175, 80)
          doc.setLineWidth(0.5)
          doc.line(20, 280, 190, 280)
          
          // Información del footer
          doc.setFontSize(8)
          doc.setFont('helvetica', 'italic')
          doc.setTextColor(120, 120, 120)
          
          if (i === 1) {
            doc.text(`Generado: ${fechaGeneracion}`, 20, 285)
          }
          
          doc.text('NutriTrack - Sistema de Gestión Nutricional', 105, 285, { align: 'center' })
          doc.text(`Página ${i} de ${totalPages}`, 190, 285, { align: 'right' })
          
          // Texto confidencial
          doc.setFontSize(7)
          doc.setTextColor(150, 150, 150)
          doc.text('Documento confidencial - Uso exclusivo del personal médico autorizado', 105, 290, { align: 'center' })
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
    }
  }
}
</script>
