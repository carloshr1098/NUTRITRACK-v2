<template>
  <v-app>
    <v-navigation-drawer
      v-if="isAuthenticated"
      v-model="drawer"
      :permanent="$vuetify.display.lgAndUp"
      app
    >
      <v-list>
        <v-list-item
          prepend-avatar="https://randomuser.me/api/portraits/men/85.jpg"
          :title="currentUser?.firstName || 'Usuario'"
          :subtitle="currentUser?.email || ''"
        ></v-list-item>
      </v-list>

      <v-divider></v-divider>

      <v-list density="compact" nav>
        <v-list-item
          v-for="item in navigationItems"
          :key="item.title"
          :prepend-icon="item.icon"
          :title="item.title"
          :to="item.route"
          :value="item.title"
        ></v-list-item>
      </v-list>

      <template v-slot:append>
        <div class="pa-2">
          <v-btn
            block
            color="error"
            variant="outlined"
            @click="logout"
          >
            <v-icon start>mdi-logout</v-icon>
            Cerrar Sesión
          </v-btn>
        </div>
      </template>
    </v-navigation-drawer>

    <v-app-bar
      v-if="isAuthenticated"
      app
      color="primary"
      dark
    >
      <v-app-bar-nav-icon
        v-if="$vuetify.display.mdAndDown"
        @click="drawer = !drawer"
      ></v-app-bar-nav-icon>

      <v-toolbar-title>NutriTrack</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn
        icon="mdi-bell"
        @click="showNotifications"
      ></v-btn>
    </v-app-bar>

    <v-main>
      <router-view />
    </v-main>

    <v-snackbar
      v-model="snackbar.show"
      :color="snackbar.color"
      :timeout="snackbar.timeout"
    >
      {{ snackbar.text }}
      <template v-slot:actions>
        <v-btn
          color="white"
          variant="text"
          @click="snackbar.show = false"
        >
          Cerrar
        </v-btn>
      </template>
    </v-snackbar>
  </v-app>
</template>

<script>
import { computed, ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import authService from './services/auth.js'

export default {
  name: 'App',
  setup() {
    const router = useRouter()
    const drawer = ref(false)
    
    const snackbar = reactive({
      show: false,
      text: '',
      color: 'success',
      timeout: 4000
    })

    const currentUser = computed(() => authService.currentUser.value)
    const isAuthenticated = computed(() => authService.isAuthenticated.value)

    const navigationItems = computed(() => {
      const items = []
      const userRoles = currentUser.value?.roles || []

      // Common navigation items
      items.push({
        title: 'Dashboard',
        icon: 'mdi-view-dashboard',
        route: '/'
      })

      if (userRoles.includes('ROLE_ADMIN')) {
        items.push({
          title: 'Gestión de Usuarios',
          icon: 'mdi-account-group',
          route: '/admin/users'
        })
        items.push({
          title: 'Reportes',
          icon: 'mdi-chart-line',
          route: '/admin/reports'
        })
      }

      if (userRoles.includes('ROLE_NUTRITIONIST')) {
        items.push({
          title: 'Pacientes',
          icon: 'mdi-account-multiple',
          route: '/nutritionist/patients'
        })
        items.push({
          title: 'Citas',
          icon: 'mdi-calendar',
          route: '/nutritionist/appointments'
        })
        items.push({
          title: 'Planes Dietéticos',
          icon: 'mdi-food-apple',
          route: '/nutritionist/diet-plans'
        })
      }

      if (userRoles.includes('ROLE_PATIENT')) {
        items.push({
          title: 'Mi Perfil',
          icon: 'mdi-account',
          route: '/patient/profile'
        })
        items.push({
          title: 'Mis Citas',
          icon: 'mdi-calendar-clock',
          route: '/patient/appointments'
        })
        items.push({
          title: 'Mi Plan Dietético',
          icon: 'mdi-food',
          route: '/patient/diet-plan'
        })
        items.push({
          title: 'Control de Peso',
          icon: 'mdi-scale',
          route: '/patient/weight-tracking'
        })
      }

      return items
    })

    const logout = async () => {
      try {
        await authService.logout()
        router.push('/login')
        showSnackbar('Sesión cerrada exitosamente', 'success')
      } catch (error) {
        console.error('Error logging out:', error)
        showSnackbar('Error al cerrar sesión', 'error')
      }
    }

    const showNotifications = () => {
      showSnackbar('Funcionalidad de notificaciones próximamente', 'info')
    }

    const showSnackbar = (text, color = 'success') => {
      snackbar.text = text
      snackbar.color = color
      snackbar.show = true
    }

    onMounted(() => {
      // Check authentication status on app load
      authService.checkAuthStatus()
    })

    return {
      drawer,
      snackbar,
      currentUser,
      isAuthenticated,
      navigationItems,
      logout,
      showNotifications
    }
  }
}
</script>