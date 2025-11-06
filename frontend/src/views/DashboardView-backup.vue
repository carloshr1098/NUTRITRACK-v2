<template>
  <v-container fluid class="pa-6">
    <v-row>
      <v-col cols="12">
        <div class="d-flex align-center mb-6">
          <v-icon size="32" color="primary" class="me-3">
            mdi-view-dashboard
          </v-icon>
          <h1 class="text-h4 font-weight-bold">
            Dashboard - {{ obtenerTituloRol() }}
          </h1>
        </div>
      </v-col>
    </v-row>

    <!-- Welcome Card -->
    <v-row class="mb-6">
      <v-col cols="12">
        <v-card class="welcome-card" color="primary" dark>
          <v-card-text class="pa-6">
            <v-row align="center">
              <v-col cols="12" md="8">
                <h2 class="text-h5 mb-2">
                  ¡Bienvenido, {{ currentUser?.firstName || 'Usuario' }}!
                </h2>
                <p class="text-body-1 mb-0">
                  {{ obtenerMensajeBienvenida() }}
                </p>
              </v-col>
              <v-col cols="12" md="4" class="text-center">
                <v-icon size="80" class="opacity-50">
                  {{ obtenerIconoRol() }}
                </v-icon>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Statistics Cards -->
    <v-row class="mb-6">
      <v-col 
        v-for="stat in statistics" 
        :key="stat.title"
        cols="12" 
        sm="6" 
        md="3"
      >
        <v-card class="stat-card" elevation="2">
          <v-card-text class="pa-4">
            <div class="d-flex align-center">
              <v-icon 
                :color="stat.color" 
                size="40" 
                class="me-3"
              >
                {{ stat.icon }}
              </v-icon>
              <div>
                <div class="text-h4 font-weight-bold" :class="`text-${stat.color}`">
                  {{ stat.value }}
                </div>
                <div class="text-body-2 text-medium-emphasis">
                  {{ stat.title }}
                </div>
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Charts Row -->
    <v-row class="mb-6">
      <v-col cols="12" md="8">
        <v-card>
          <v-card-title class="d-flex align-center">
            <v-icon class="me-2">mdi-chart-line</v-icon>
            Actividad Reciente
          </v-card-title>
          <v-card-text>
            <div class="chart-container">
              <canvas ref="activityChart"></canvas>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      
      <v-col cols="12" md="4">
        <v-card>
          <v-card-title class="d-flex align-center">
            <v-icon class="me-2">mdi-calendar-today</v-icon>
            Próximas Citas
          </v-card-title>
          <v-card-text>
            <v-list v-if="upcomingAppointments.length > 0">
              <v-list-item 
                v-for="appointment in upcomingAppointments" 
                :key="appointment.id"
                class="px-0"
              >
                <template v-slot:prepend>
                  <v-avatar color="primary" size="small">
                    <v-icon>mdi-calendar</v-icon>
                  </v-avatar>
                </template>
                
                <v-list-item-title>
                  {{ appointment.patientName || appointment.nutritionistName }}
                </v-list-item-title>
                <v-list-item-subtitle>
                  {{ formatDate(appointment.date) }}
                </v-list-item-subtitle>
              </v-list-item>
            </v-list>
            
            <div v-else class="text-center py-4">
              <v-icon size="48" color="grey-lighten-2">
                mdi-calendar-remove
              </v-icon>
              <p class="text-body-2 text-medium-emphasis mt-2">
                No hay citas próximas
              </p>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Quick Actions -->
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title class="d-flex align-center">
            <v-icon class="me-2">mdi-lightning-bolt</v-icon>
            Acciones Rápidas
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col 
                v-for="action in quickActions" 
                :key="action.title"
                cols="12" 
                sm="6" 
                md="3"
              >
                <v-btn
                  :color="action.color"
                  variant="outlined"
                  size="large"
                  block
                  class="text-none"
                  :to="action.route"
                >
                  <v-icon start>{{ action.icon }}</v-icon>
                  {{ action.title }}
                </v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { Chart, registerables } from 'chart.js'
import authService from '../services/auth.js'
import { format } from 'date-fns'
import { es } from 'date-fns/locale'

Chart.register(...registerables)

export default {
  name: 'DashboardView',
  setup() {
    const activityChart = ref(null)
    const currentUser = computed(() => authService.currentUser.value)
    
    // Mock data - in real app, fetch from API
    const statistics = ref([
      { title: 'Pacientes Activos', value: '24', icon: 'mdi-account-group', color: 'primary' },
      { title: 'Citas del Día', value: '8', icon: 'mdi-calendar-today', color: 'success' },
      { title: 'Planes Dietéticos', value: '12', icon: 'mdi-food-apple', color: 'warning' },
      { title: 'Consultas del Mes', value: '156', icon: 'mdi-chart-line', color: 'info' }
    ])

    const upcomingAppointments = ref([
      { id: 1, patientName: 'María González', date: new Date('2024-01-25 10:00') },
      { id: 2, patientName: 'Carlos Rodríguez', date: new Date('2024-01-25 14:30') },
      { id: 3, patientName: 'Ana López', date: new Date('2024-01-26 09:00') }
    ])

    const obtenerTituloRol = () => {
      const roles = authService.getUserRoles()
      if (roles.includes('ROLE_ADMIN')) return 'Administrador'
      if (roles.includes('ROLE_NUTRIOLOGO')) return 'Nutriólogo'
      if (roles.includes('ROLE_PACIENTE')) return 'Paciente'
      return 'Usuario'
    }

    const obtenerIconoRol = () => {
      const roles = authService.getUserRoles()
      if (roles.includes('ROLE_ADMIN')) return 'mdi-shield-crown'
      if (roles.includes('ROLE_NUTRIOLOGO')) return 'mdi-stethoscope'
      if (roles.includes('ROLE_PACIENTE')) return 'mdi-account-heart'
      return 'mdi-account'
    }

    const obtenerMensajeBienvenida = () => {
      const roles = authService.getUserRoles()
      if (roles.includes('ROLE_ADMIN')) {
        return 'Gestiona usuarios y supervisa el sistema completo desde aquí.'
      }
      if (roles.includes('ROLE_NUTRIOLOGO')) {
        return 'Administra tus pacientes, citas y planes dietéticos de manera eficiente.'
      }
      if (roles.includes('ROLE_PACIENTE')) {
        return 'Mantén un seguimiento de tu progreso nutricional y próximas citas.'
      }
      return 'Bienvenido al sistema de gestión nutricional.'
    }

    const quickActions = computed(() => {
      const actions = []
      const roles = authService.getUserRoles()

      if (roles.includes('ROLE_ADMIN')) {
        actions.push(
          { title: 'Gestionar Usuarios', icon: 'mdi-account-plus', color: 'primary', route: '/admin/users' },
          { title: 'Ver Reportes', icon: 'mdi-chart-box', color: 'success', route: '/admin/reports' }
        )
      }

      if (roles.includes('ROLE_NUTRIOLOGO')) {
        actions.push(
          { title: 'Nuevo Paciente', icon: 'mdi-account-plus', color: 'primary', route: '/nutriologo/pacientes' },
          { title: 'Agendar Cita', icon: 'mdi-calendar-plus', color: 'success', route: '/nutriologo/citas' },
          { title: 'Crear Plan Dietético', icon: 'mdi-food-apple', color: 'warning', route: '/nutriologo/planes-dieteticos' }
        )
      }

      if (roles.includes('ROLE_PACIENTE')) {
        actions.push(
          { title: 'Actualizar Perfil', icon: 'mdi-account-edit', color: 'primary', route: '/paciente/perfil' },
          { title: 'Mis Citas', icon: 'mdi-calendar', color: 'success', route: '/paciente/citas' },
          { title: 'Mi Plan Dietético', icon: 'mdi-food', color: 'warning', route: '/paciente/plan-dietetico' },
          { title: 'Registrar Peso', icon: 'mdi-scale', color: 'info', route: '/paciente/control-peso' }
        )
      }

      return actions
    })

    const formatDate = (date) => {
      return format(new Date(date), 'PPp', { locale: es })
    }

    const initChart = () => {
      if (activityChart.value) {
        new Chart(activityChart.value, {
          type: 'line',
          data: {
            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
            datasets: [{
              label: 'Consultas',
              data: [12, 19, 15, 25, 22, 30],
              borderColor: '#2E7D32',
              backgroundColor: 'rgba(46, 125, 50, 0.1)',
              tension: 0.4
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false
              }
            },
            scales: {
              y: {
                beginAtZero: true
              }
            }
          }
        })
      }
    }

    onMounted(() => {
      setTimeout(initChart, 100) // Delay to ensure DOM is ready
    })

    return {
      activityChart,
      currentUser,
      statistics,
      upcomingAppointments,
      quickActions,
      obtenerTituloRol,
      obtenerIconoRol,
      obtenerMensajeBienvenida,
      formatDate
    }
  }
}
</script>

<style scoped>
.welcome-card {
  background: linear-gradient(135deg, #2E7D32 0%, #388E3C 100%);
}

.stat-card {
  transition: transform 0.2s ease-in-out;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.chart-container {
  position: relative;
  height: 300px;
  width: 100%;
}
</style>