<template>
  <v-app-bar
    app
    elevation="0"
    color="white"
    height="80"
    class="nutritrack-navbar"
  >
    <!-- Logo y título -->
    <v-toolbar-title class="d-flex align-center cursor-pointer toolbar-content" @click="goHome">
      <div class="logo-container">
        <img src="/logo/nutritrack-icon.png" alt="NutriTrack Logo" class="logo-icon" />
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
        <v-btn icon v-bind="props" class="ml-2 user-menu-btn">
          <v-avatar size="42" class="user-avatar">
            <v-icon color="white" size="24">mdi-account</v-icon>
          </v-avatar>
        </v-btn>
      </template>
      
      <v-list class="user-menu-list">
        <v-list-item class="user-info-item">
          <v-list-item-title class="font-weight-bold user-name">{{ userName }}</v-list-item-title>
          <v-list-item-subtitle class="user-role">{{ userRole }}</v-list-item-subtitle>
        </v-list-item>
        <v-divider class="menu-divider"></v-divider>
        <v-list-item @click="goToProfile" class="menu-item">
          <template v-slot:prepend>
            <v-icon color="#5fc2c6">mdi-account-circle</v-icon>
          </template>
          <v-list-item-title>Mi Perfil</v-list-item-title>
        </v-list-item>
        <v-list-item @click="goToSettings" class="menu-item">
          <template v-slot:prepend>
            <v-icon color="#ff9800">mdi-cog</v-icon>
          </template>
          <v-list-item-title>Configuración</v-list-item-title>
        </v-list-item>
        <v-divider class="menu-divider"></v-divider>
        <v-list-item @click="logout" class="menu-item logout-item">
          <template v-slot:prepend>
            <v-icon color="#ff5252">mdi-logout</v-icon>
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
          { title: 'Dashboard', icon: 'mdi-view-dashboard', route: '/', color: '#8bc34a' },
          { title: 'Pacientes', icon: 'mdi-account-group', route: '/nutriologo/pacientes', color: '#5fc2c6' },
          { title: 'Citas', icon: 'mdi-calendar', route: '/nutriologo/citas', color: '#ff9800' },
          { title: 'Planes', icon: 'mdi-food-apple', route: '/nutriologo/planes-dieteticos', color: '#8bc34a' },
          { title: 'Alimentos', icon: 'mdi-database', route: '/nutriologo/alimentos', color: '#ff5252' },
          { title: 'Mi Perfil', icon: 'mdi-account-cog', route: '/nutriologo/perfil', color: '#7a7a5a' }
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
  background: linear-gradient(to bottom, white 0%, white 100%) !important;
  box-shadow: 0 4px 20px rgba(139, 195, 74, 0.15) !important;
  border-image: linear-gradient(90deg, #8bc34a 0%, #5fc2c6 50%, #ff9800 100%) 1;
  border-image-slice: 0 0 1 0;
}

.logo-container {
  position: relative;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: white;
  box-shadow: 0 4px 12px rgba(139, 195, 74, 0.3), 0 0 0 3px #8bc34a;
  transition: all 0.3s ease;
  flex-shrink: 0;
  overflow: visible;
}

.logo-container:hover {
  transform: scale(1.05) rotate(3deg);
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4), 0 0 0 3px #7ab73f;
}

.logo-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.logo-icon {
  width: 50px;
  height: 50px;
  object-fit: contain;
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
  font-size: 1.6rem;
  font-weight: 800;
  background: linear-gradient(135deg, #8bc34a 0%, #5fc2c6 50%, #ff9800 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.5px;
}

.brand-subtitle {
  font-size: 0.7rem;
  color: #7a7a5a;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1.5px;
}

.nav-btn {
  margin: 0 4px;
  text-transform: none;
  font-weight: 600;
  transition: all 0.3s ease;
  border-radius: 12px;
  position: relative;
  overflow: hidden;
}

.nav-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 0;
  height: 100%;
  background: linear-gradient(135deg, rgba(139, 195, 74, 0.1) 0%, rgba(95, 194, 198, 0.1) 100%);
  transition: width 0.3s ease;
}

.nav-btn:hover::before {
  width: 100%;
}

.nav-btn:hover {
  color: #8bc34a !important;
  transform: translateY(-2px);
}

.nav-btn.v-btn--active {
  background: linear-gradient(135deg, rgba(139, 195, 74, 0.15) 0%, rgba(95, 194, 198, 0.15) 100%);
  color: #8bc34a !important;
  font-weight: 700;
}

/* User menu button */
.user-menu-btn {
  transition: all 0.3s ease;
}

.user-menu-btn:hover {
  transform: scale(1.05);
}

.user-avatar {
  background: linear-gradient(135deg, #8bc34a 0%, #5fc2c6 100%) !important;
  box-shadow: 0 4px 12px rgba(139, 195, 74, 0.3);
  transition: all 0.3s ease;
}

.user-menu-btn:hover .user-avatar {
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4);
  transform: rotate(5deg);
}

/* User menu dropdown */
.user-menu-list {
  border-radius: 16px !important;
  overflow: hidden;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15) !important;
}

.user-info-item {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  color: white;
  padding: 16px !important;
}

.user-name {
  color: white !important;
  font-size: 1.1rem !important;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.user-role {
  color: rgba(255, 255, 255, 0.95) !important;
  font-weight: 600;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.menu-divider {
  border-color: rgba(139, 195, 74, 0.2);
  margin: 4px 0 !important;
}

.menu-item {
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  padding: 12px 16px !important;
}

.menu-item:hover {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.08) 0%, transparent 100%) !important;
  border-left-color: #8bc34a;
  transform: translateX(4px);
}

.logout-item:hover {
  background: linear-gradient(90deg, rgba(255, 82, 82, 0.08) 0%, transparent 100%) !important;
  border-left-color: #ff5252;
}

.cursor-pointer {
  cursor: pointer;
  transition: all 0.3s ease;
}

.cursor-pointer:hover {
  transform: scale(1.02);
}

/* Mobile drawer */
.mobile-drawer {
  border-right: 3px solid #8bc34a !important;
}

.mobile-drawer .brand-name {
  font-size: 1.4rem;
}

.mobile-drawer .brand-subtitle {
  font-size: 0.65rem;
}

.mobile-drawer :deep(.v-list-item) {
  border-left: 3px solid transparent;
  transition: all 0.3s ease;
}

.mobile-drawer :deep(.v-list-item:hover) {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.1) 0%, transparent 100%) !important;
  border-left-color: #8bc34a;
  transform: translateX(4px);
}

.mobile-drawer :deep(.v-list-item--active) {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.15) 0%, transparent 100%) !important;
  border-left-color: #8bc34a;
  font-weight: 700;
}

/* Toolbar title override */
:deep(.v-toolbar-title) {
  overflow: visible !important;
}

.toolbar-content {
  padding: 12px 0 !important;
  margin-top: 2px;
  margin-left: 20px;
}

/* Responsive */
@media (max-width: 768px) {
  .brand-name {
    font-size: 1.3rem;
  }
  
  .brand-subtitle {
    font-size: 0.65rem;
  }
  
  .logo-container {
    width: 48px;
    height: 48px;
    padding: 4px;
  }
}
</style>
