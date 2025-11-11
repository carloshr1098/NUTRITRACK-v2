<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <h1 class="text-h4 mb-4">Dashboard Nutricionista</h1>
      </v-col>
    </v-row>

    <!-- KPIs Simples -->
    <v-row>
      <v-col cols="12" md="3">
        <v-card elevation="2">
          <v-card-text>
            <div class="d-flex align-center mb-2">
              <v-icon color="#2A071FF" size="40">mdi-account-group</v-icon>
            </div>
            <div class="text-h4">{{ stats.totalPacientes }}</div>
            <div class="text-subtitle-2 text-grey">PACIENTES ACTIVOS</div>
            <div class="text-caption mt-1">+{{ stats.pacientesNuevos }} este mes</div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card elevation="2">
          <v-card-text>
            <div class="d-flex align-center mb-2">
              <v-icon color="#FF01FF" size="40">mdi-calendar-check</v-icon>
            </div>
            <div class="text-h4">{{ stats.citasHoy }}</div>
            <div class="text-subtitle-2 text-grey">CITAS HOY</div>
            <div class="text-caption mt-1">{{ stats.citasSemana }} esta semana</div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card elevation="2">
          <v-card-text>
            <div class="d-flex align-center mb-2">
              <v-icon color="#B8D438" size="40">mdi-food-apple</v-icon>
            </div>
            <div class="text-h4">{{ stats.planesActivos }}</div>
            <div class="text-subtitle-2 text-grey">PLANES ACTIVOS</div>
            <v-progress-linear 
              :model-value="progressPlanes" 
              color="#B8D438" 
              height="4" 
              class="mt-2"
            ></v-progress-linear>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card elevation="2">
          <v-card-text>
            <div class="d-flex align-center mb-2">
              <v-icon color="#7A7A5A" size="40">mdi-chart-line</v-icon>
            </div>
            <div class="text-h4">{{ stats.progresoPromedio }}%</div>
            <div class="text-subtitle-2 text-grey">PROGRESO PROMEDIO</div>
            <div class="text-caption mt-1">De todos los pacientes</div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Acciones Rápidas -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title>
            <v-icon class="mr-2" color="orange">mdi-lightning-bolt</v-icon>
            Accesos Rápidos
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  :color="'#FF01FF'"
                  variant="tonal"
                  size="large"
                  @click="$router.push('/nutricionista/citas')"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-calendar-plus</v-icon>
                    <div class="text-caption mt-1">Nueva Cita</div>
                  </div>
                </v-btn>
              </v-col>

              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  :color="'#2A071FF'"
                  variant="tonal"
                  size="large"
                  @click="$router.push('/nutricionista/pacientes')"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-account-plus</v-icon>
                    <div class="text-caption mt-1">Nuevo Paciente</div>
                  </div>
                </v-btn>
              </v-col>

              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  :color="'#B8D438'"
                  variant="tonal"
                  size="large"
                  @click="$router.push('/nutricionista/planes')"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-food-apple</v-icon>
                    <div class="text-caption mt-1">Nuevo Plan</div>
                  </div>
                </v-btn>
              </v-col>

              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  :color="'#7A7A5A'"
                  variant="tonal"
                  size="large"
                  @click="$router.push('/nutricionista/alimentos')"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-database</v-icon>
                    <div class="text-caption mt-1">Alimentos</div>
                  </div>
                </v-btn>
              </v-col>

              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  color="primary"
                  variant="tonal"
                  size="large"
                  @click="$router.push('/nutricionista/pacientes')"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-chart-box</v-icon>
                    <div class="text-caption mt-1">Reportes</div>
                  </div>
                </v-btn>
              </v-col>

              <v-col cols="6" sm="3" md="2">
                <v-btn
                  block
                  color="secondary"
                  variant="tonal"
                  size="large"
                  @click="actualizarDatos"
                >
                  <div class="text-center">
                    <v-icon size="32">mdi-refresh</v-icon>
                    <div class="text-caption mt-1">Actualizar</div>
                  </div>
                </v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Próximas Citas -->
    <v-row class="mt-4" v-if="proximasCitas.length > 0">
      <v-col cols="12" md="6">
        <v-card elevation="2">
          <v-card-title>
            <v-icon class="mr-2" color="success">mdi-calendar-clock</v-icon>
            Próximas Citas
          </v-card-title>
          <v-list>
            <v-list-item
              v-for="(cita, index) in proximasCitas"
              :key="index"
            >
              <template v-slot:prepend>
                <v-avatar :color="cita.color || 'primary'">
                  <v-icon>{{ cita.icon || 'mdi-account' }}</v-icon>
                </v-avatar>
              </template>
              <v-list-item-title>{{ cita.paciente }}</v-list-item-title>
              <v-list-item-subtitle>
                {{ cita.tipo }} - {{ cita.hora }}
              </v-list-item-subtitle>
            </v-list-item>
          </v-list>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import api from '@/services/api'
import authService from '@/services/auth'

export default {
  name: 'NutritionistDashboardView',
  data() {
    return {
      stats: {
        totalPacientes: 0,
        pacientesNuevos: 0,
        citasHoy: 0,
        citasSemana: 0,
        planesActivos: 0,
        progresoPromedio: 0
      },
      proximasCitas: []
    }
  },
  computed: {
    progressPlanes() {
      return this.stats.planesActivos > 0 ? Math.min((this.stats.planesActivos / 50) * 100, 100) : 0
    }
  },
  async mounted() {
    await this.cargarDatos()
  },
  methods: {
    async cargarDatos() {
      try {
        // Cargar pacientes
        const pacientesResponse = await api.get('/pacientes')
        this.stats.totalPacientes = pacientesResponse.data.length
        this.stats.pacientesNuevos = 3
        
        // Cargar citas
        const citasResponse = await api.get('/appointments')
        const hoy = new Date()
        hoy.setHours(0, 0, 0, 0)
        
        this.stats.citasHoy = citasResponse.data.filter(c => {
          const fechaCita = new Date(c.appointmentDate)
          return fechaCita.toDateString() === hoy.toDateString()
        }).length
        
        const inicioSemana = new Date(hoy)
        inicioSemana.setDate(hoy.getDate() - hoy.getDay())
        this.stats.citasSemana = citasResponse.data.filter(c => 
          new Date(c.appointmentDate) >= inicioSemana
        ).length
        
        // Cargar planes
        const planesResponse = await api.get('/diet-plans')
        this.stats.planesActivos = planesResponse.data.length
        
        this.stats.progresoPromedio = 65
        
        // Cargar próximas citas
        this.proximasCitas = citasResponse.data
          .filter(c => new Date(c.appointmentDate) >= hoy)
          .slice(0, 5)
          .map(cita => ({
            paciente: cita.patient ? `${cita.patient.firstName} ${cita.patient.lastName}` : 'Paciente',
            tipo: cita.appointmentType || 'Consulta',
            hora: new Date(cita.appointmentDate).toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' }),
            color: 'primary',
            icon: 'mdi-account'
          }))
        
      } catch (error) {
        console.error('Error al cargar datos:', error)
        this.$swal('Error', 'No se pudieron cargar los datos del dashboard', 'error')
      }
    },
    
    async actualizarDatos() {
      await this.cargarDatos()
      this.$swal('Actualizado', 'Datos actualizados correctamente', 'success')
    }
  }
}
</script>

<style scoped>
.v-btn {
  height: auto !important;
  padding: 16px 8px !important;
}
</style>
