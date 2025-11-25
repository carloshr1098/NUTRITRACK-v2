<template>
  <div class="dashboard-nutritrack">
    <!-- Header con gradiente y logo -->
    <div class="dashboard-header">
      <div class="header-content">
        <div class="welcome-box">
          <h1 class="welcome-title">Bienvenido, {{ userFullName }} 👋</h1>
          <p class="welcome-subtitle">ROL: {{ userRole }}</p>
          <p class="welcome-date">{{ currentDate }}</p>
        </div>
      </div>
    </div>
    
    <!-- Grid de cards principales -->
    <div class="cards-container">
      
      <!-- Card para Pacientes -->
      <div class="action-card card-pacientes">
        <div class="card-icon">📋</div>
        <h3 class="card-title">Gestión de Pacientes</h3>
        <p class="card-description">Administrar información de pacientes</p>
        <router-link to="/nutriologo/pacientes" class="card-button btn-pacientes">
          Ver Pacientes
        </router-link>
      </div>
      
      <!-- Card para Citas -->
      <div class="action-card card-citas">
        <div class="card-icon">📅</div>
        <h3 class="card-title">Gestión de Citas</h3>
        <p class="card-description">Programar y gestionar citas</p>
        <router-link to="/nutriologo/citas" class="card-button btn-citas">
          Ver Citas
        </router-link>
      </div>
      
      <!-- Card para Planes Dietéticos -->
      <div class="action-card card-planes">
        <div class="card-icon">🍎</div>
        <h3 class="card-title">Planes Dietéticos</h3>
        <p class="card-description">Crear y administrar dietas</p>
        <router-link to="/nutriologo/planes-dieteticos" class="card-button btn-planes">
          Ver Planes
        </router-link>
      </div>

      <!-- Card para Base de Datos de Alimentos -->
      <div class="action-card card-alimentos">
        <div class="card-icon">🥗</div>
        <h3 class="card-title">Base de Alimentos</h3>
        <p class="card-description">Gestionar alimentos y nutrición</p>
        <router-link to="/nutriologo/alimentos" class="card-button btn-alimentos">
          Ver Alimentos
        </router-link>
      </div>

      <!-- Card para Mi Perfil -->
      <div class="action-card card-perfil">
        <div class="card-icon">👤</div>
        <h3 class="card-title">Mi Perfil Profesional</h3>
        <p class="card-description">Editar información profesional</p>
        <router-link to="/nutriologo/perfil" class="card-button btn-perfil">
          Ver Perfil
        </router-link>
      </div>
      
    </div>
    
    <!-- Botón de cerrar sesión -->
    <div class="logout-container">
      <button @click="logout" class="logout-button">
        Cerrar Sesión
      </button>
    </div>
  </div>
</template>

<script>
import authService from '../services/auth.js'

export default {
  name: 'DashboardView',
  data() {
    return {
      user: null,
      userFullName: 'Nutricionista',
      userRole: 'NUTRIÓLOGO'
    }
  },
  computed: {
    currentDate() {
      const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
      return new Date().toLocaleDateString('es-ES', options)
    }
  },
  mounted() {
    this.user = authService.currentUser.value
    if (!this.user) {
      this.$router.push('/login')
    } else {
      this.obtenerNombreUsuario()
    }
  },
  methods: {
    obtenerNombreUsuario() {
      const user = authService.currentUser.value || JSON.parse(localStorage.getItem('user') || '{}')
      
      // Obtener nombre completo
      const firstName = user.firstName || ''
      const lastName = user.lastName || ''
      this.userFullName = `${firstName} ${lastName}`.trim() || user.username || 'Nutricionista'
      
      // Formatear el rol
      let role = 'NUTRIÓLOGO'
      if (user.roles && user.roles.length > 0) {
        role = user.roles[0].replace('ROLE_', '').replace('_', ' ')
      } else if (user.role) {
        role = user.role.replace('ROLE_', '').replace('_', ' ')
      }
      this.userRole = role
    },
    
    logout() {
      authService.logout()
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.dashboard-nutritrack {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%);
  position: relative;
}

.dashboard-nutritrack::before {
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

.dashboard-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 60px 30px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(139, 195, 74, 0.3);
  z-index: 1;
}

.dashboard-header::before {
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
  position: relative;
  z-index: 2;
}

.welcome-box {
  text-align: center;
}

.welcome-title {
  color: white;
  font-size: 3rem;
  font-weight: 800;
  margin: 0 0 15px 0;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  letter-spacing: -0.5px;
}

.welcome-subtitle {
  color: rgba(255, 255, 255, 0.95);
  font-size: 1.25rem;
  margin: 0 0 10px 0;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.welcome-date {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1rem;
  margin: 0;
  font-weight: 400;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.cards-container {
  max-width: 1400px;
  margin: -40px auto 0;
  padding: 0 30px 60px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 30px;
  position: relative;
  z-index: 1;
}

.action-card {
  background: white;
  border-radius: 20px;
  padding: 40px 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  border-top: 5px solid;
  position: relative;
  overflow: hidden;
}

.action-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 5px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transform: translateX(-100%);
  transition: transform 0.6s;
}

.action-card:hover::before {
  transform: translateX(100%);
}

.action-card:hover {
  transform: translateY(-12px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.card-pacientes {
  border-top-color: #2196F3;
}

.card-citas {
  border-top-color: #8bc34a;
}

.card-planes {
  border-top-color: #ff9800;
}

.card-alimentos {
  border-top-color: #5fc2c6;
}

.card-perfil {
  border-top-color: #7a7a5a;
}

.card-icon {
  font-size: 4rem;
  margin-bottom: 20px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.card-title {
  color: #2c3e50;
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 0 12px 0;
  line-height: 1.3;
}

.card-description {
  color: #7f8c8d;
  font-size: 1rem;
  margin: 0 0 25px 0;
  line-height: 1.6;
}

.card-button {
  display: inline-block;
  padding: 14px 32px;
  color: white;
  text-decoration: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-pacientes {
  background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
}

.btn-pacientes:hover {
  background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
}

.btn-citas {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
}

.btn-citas:hover {
  background: linear-gradient(135deg, #7ab73f 0%, #689f38 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4);
}

.btn-planes {
  background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
}

.btn-planes:hover {
  background: linear-gradient(135deg, #f57c00 0%, #ef6c00 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 152, 0, 0.4);
}

.btn-alimentos {
  background: linear-gradient(135deg, #5fc2c6 0%, #4fb3b7 100%);
}

.btn-alimentos:hover {
  background: linear-gradient(135deg, #4fb3b7 0%, #3fa4a8 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(95, 194, 198, 0.4);
}

.btn-perfil {
  background: linear-gradient(135deg, #7a7a5a 0%, #6a6a4a 100%);
}

.btn-perfil:hover {
  background: linear-gradient(135deg, #6a6a4a 0%, #5a5a3a 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(122, 122, 90, 0.4);
}

.logout-container {
  text-align: center;
  padding: 0 30px 60px;
  position: relative;
  z-index: 1;
}

.logout-button {
  padding: 16px 48px;
  background: linear-gradient(135deg, #ff5252 0%, #e74c3c 100%);
  color: white;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  font-size: 1.1rem;
  font-weight: 700;
  transition: all 0.3s ease;
  box-shadow: 0 6px 20px rgba(255, 82, 82, 0.3);
  text-transform: uppercase;
  letter-spacing: 1px;
}

.logout-button:hover {
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
  transform: translateY(-4px);
  box-shadow: 0 10px 30px rgba(255, 82, 82, 0.4);
}

.logout-button:active {
  transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 2rem;
  }
  
  .cards-container {
    grid-template-columns: 1fr;
    gap: 20px;
    margin-top: -30px;
  }
  
  .dashboard-header {
    padding: 40px 20px;
  }
}
</style>