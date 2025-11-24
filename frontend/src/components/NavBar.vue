<template>
  <v-app-bar
    app
    elevation="2"
    color="white"
    height="70"
    class="nutritrack-navbar"
  >
    <!-- Logo y título -->
    <v-toolbar-title class="d-flex align-center cursor-pointer" @click="goHome">
      <div class="logo-container">
        <img src="/logo/nutritrack-icon.png" alt="NutriTrack Logo" class="logo-icon" width="45" height="45" />
      </div>
      <div class="brand-text ml-3">
        <div class="brand-name">NutriTrack</div>
        <div class="brand-subtitle">Monitoreo Nutricional</div>
      </div>
    </v-toolbar-title>

    <v-spacer></v-spacer>

    <!-- Navigation links - Desktop -->
    <v-toolbar-items v-if="isAuthenticated && !mobile" class="hidden-sm-and-down">
      <v-btn
        v-for="item in menuItems"
        :key="item.title"
        :to="item.route"
        text
        class="nav-btn"
      >
        <v-icon left>{{ item.icon }}</v-icon>
        {{ item.title }}
      </v-btn>
    </v-toolbar-items>

    <!-- User menu -->
    <v-menu v-if="isAuthenticated" offset-y>
      <template v-slot:activator="{ props }">
        <v-btn icon v-bind="props" class="ml-2">
          <v-avatar size="40" color="#2A07FF">
            <v-icon color="white">mdi-account</v-icon>
          </v-avatar>
        </v-btn>
      </template>
      
      <v-list>
        <v-list-item>
          <v-list-item-title class="font-weight-bold">{{ userName }}</v-list-item-title>
          <v-list-item-subtitle>{{ userRole }}</v-list-item-subtitle>
        </v-list-item>
        <v-divider></v-divider>
        <v-list-item @click="goToProfile">
          <template v-slot:prepend>
            <v-icon>mdi-account-circle</v-icon>
          </template>
          <v-list-item-title>Mi Perfil</v-list-item-title>
        </v-list-item>
        <v-list-item @click="goToSettings">
          <template v-slot:prepend>
            <v-icon>mdi-cog</v-icon>
          </template>
          <v-list-item-title>Configuración</v-list-item-title>
        </v-list-item>
        <v-divider></v-divider>
        <v-list-item @click="logout">
          <template v-slot:prepend>
            <v-icon color="error">mdi-logout</v-icon>
          </template>
          <v-list-item-title class="text-error">Cerrar Sesión</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <!-- Mobile menu -->
    <v-app-bar-nav-icon
      v-if="isAuthenticated && mobile"
      @click="drawer = !drawer"
      class="hidden-md-and-up"
    ></v-app-bar-nav-icon>
  </v-app-bar>

  <!-- Mobile navigation drawer -->
  <v-navigation-drawer
    v-model="drawer"
    app
    temporary
    class="mobile-drawer"
  >
    <v-list>
      <v-list-item class="pa-4">
        <div class="brand-text">
          <div class="brand-name">NutriTrack</div>
          <div class="brand-subtitle">Monitoreo Nutricional</div>
        </div>
      </v-list-item>
      <v-divider></v-divider>
      
      <v-list-item
        v-for="item in menuItems"
        :key="item.title"
        :to="item.route"
        @click="drawer = false"
      >
        <template v-slot:prepend>
          <v-icon :color="item.color">{{ item.icon }}</v-icon>
        </template>
        <v-list-item-title>{{ item.title }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import authService from '@/services/auth'

export default {
  name: 'NavBar',
  setup() {
    const router = useRouter()
    const drawer = ref(false)
    const mobile = ref(false)
    
    const user = computed(() => authService.currentUser.value)
    const isAuthenticated = computed(() => !!user.value)
    
    const userName = computed(() => {
      if (!user.value) return ''
      return user.value.username || 'Usuario'
    })
    
    const userRole = computed(() => {
      if (!user.value || !user.value.roles) return ''
      const roles = user.value.roles
      if (roles.includes('ROLE_ADMIN')) return 'Administrador'
      if (roles.includes('ROLE_NUTRIOLOGO')) return 'Nutricionista'
      if (roles.includes('ROLE_PACIENTE')) return 'Paciente'
      return 'Usuario'
    })
    
    const menuItems = computed(() => {
      if (!user.value || !user.value.roles) return []
      
      const roles = user.value.roles
      
      if (roles.includes('ROLE_NUTRIOLOGO') || roles.includes('ROLE_ADMIN')) {
        return [
          { title: 'Dashboard', icon: 'mdi-view-dashboard', route: '/', color: '#2A07FF' },
          { title: 'Pacientes', icon: 'mdi-account-group', route: '/nutriologo/pacientes', color: '#FF01FF' },
          { title: 'Citas', icon: 'mdi-calendar', route: '/nutriologo/citas', color: '#B8D438' },
          { title: 'Planes', icon: 'mdi-food-apple', route: '/nutriologo/planes-dieteticos', color: '#7A7A5A' },
          { title: 'Alimentos', icon: 'mdi-database', route: '/nutriologo/alimentos', color: '#FF0000' },
          { title: 'Mi Perfil', icon: 'mdi-account-cog', route: '/nutriologo/perfil', color: '#5FC3E4' }
        ]
      }
      
      if (roles.includes('ROLE_PACIENTE')) {
        return [
          { title: 'Mi Perfil', icon: 'mdi-account', route: '/paciente/perfil', color: '#2A07FF' },
          { title: 'Mi Plan', icon: 'mdi-food-apple', route: '/paciente/plan', color: '#FF01FF' },
          { title: 'Citas', icon: 'mdi-calendar', route: '/paciente/citas', color: '#B8D438' },
          { title: 'Progreso', icon: 'mdi-chart-line', route: '/paciente/progreso', color: '#7A7A5A' }
        ]
      }
      
      return []
    })
    
    const checkMobile = () => {
      mobile.value = window.innerWidth < 960
    }
    
    onMounted(() => {
      checkMobile()
      window.addEventListener('resize', checkMobile)
    })
    
    const goHome = () => {
      if (isAuthenticated.value) {
        router.push('/dashboard')
      } else {
        router.push('/login')
      }
    }
    
    const goToProfile = () => {
      const roles = user.value?.roles || []
      if (roles.includes('ROLE_PACIENTE')) {
        router.push('/paciente/perfil')
      } else if (roles.includes('ROLE_NUTRIOLOGO')) {
        router.push('/nutriologo/perfil')
      }
    }
    
    const goToSettings = () => {
      // TODO: Implementar vista de configuración
      console.log('Ir a configuración')
    }
    
    const logout = async () => {
      await authService.logout()
      router.push('/login')
    }
    
    return {
      drawer,
      mobile,
      isAuthenticated,
      userName,
      userRole,
      menuItems,
      goHome,
      goToProfile,
      goToSettings,
      logout
    }
  }
}
</script>

<style scoped>
.nutritrack-navbar {
  border-bottom: 3px solid transparent;
  border-image: linear-gradient(to right, #2A071FF, #FF01FF, #B8D438) 1;
}

.logo-container {
  position: relative;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  background: linear-gradient(135deg, rgba(126, 211, 33, 0.1), rgba(74, 144, 226, 0.1));
  transition: all 0.3s ease;
}

.logo-container:hover {
  background: linear-gradient(135deg, rgba(126, 211, 33, 0.2), rgba(74, 144, 226, 0.2));
  transform: scale(1.05);
}

.logo-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.logo-icon {
  transition: all 0.3s ease;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.logo-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.brand-text {
  line-height: 1.2;
}

.brand-name {
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #2A071FF 0%, #FF01FF 50%, #B8D438 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.5px;
}

.brand-subtitle {
  font-size: 0.7rem;
  color: #7A7A5A;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.nav-btn {
  margin: 0 4px;
  text-transform: none;
  font-weight: 500;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  background: linear-gradient(135deg, rgba(42, 7, 31, 0.1), rgba(255, 1, 255, 0.1));
}

.cursor-pointer {
  cursor: pointer;
}

.mobile-drawer .brand-name {
  font-size: 1.3rem;
}

.mobile-drawer .brand-subtitle {
  font-size: 0.65rem;
}
</style>
