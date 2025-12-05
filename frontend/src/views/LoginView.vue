<template>
  <div class="login-container">
    <!-- Panel izquierdo - Información -->
    <div class="info-panel">
      <div class="info-content">
        <div class="logo-section">
          <img src="/logo/nutritrack-logo.png" alt="NutriTrack" class="main-logo" />
        </div>
        
        <div class="info-section">
          <div class="info-card">
            <div class="icon">🥗</div>
            <h3>¿Qué es NutriTrack?</h3>
            <p>Plataforma integral de gestión nutricional que conecta nutriólogos y pacientes para un seguimiento efectivo de hábitos alimenticios y objetivos de salud.</p>
          </div>

          <div class="info-card">
            <div class="icon">👥</div>
            <h3>¿Quiénes somos?</h3>
            <p>Somos un equipo comprometido con la salud y el bienestar, brindando herramientas tecnológicas para facilitar el trabajo de profesionales de la nutrición.</p>
          </div>

          <div class="info-card">
            <div class="icon">✨</div>
            <h3>Características</h3>
            <ul>
              <li>📊 Seguimiento de peso y medidas</li>
              <li>🍎 Planes alimenticios personalizados</li>
              <li>📅 Gestión de citas</li>
              <li>📈 Reportes y estadísticas</li>
            </ul>
          </div>

          <div class="info-card contact">
            <div class="icon">📧</div>
            <h3>Contacto</h3>
            <p><strong>Email:</strong> contacto@nutritrack.com</p>
            <p><strong>Teléfono:</strong> +52 55 1234 5678</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Panel derecho - Login -->
    <div class="login-panel">
      <div class="login-content">
        <h1>Iniciar Sesión</h1>
        <p class="subtitle">Accede a tu cuenta de NutriTrack</p>
        
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        
        <form @submit.prevent="login" class="login-form">
          <div class="form-group">
            <label>Usuario</label>
            <input 
              type="text" 
              v-model="form.username" 
              required
              placeholder="Ingresa tu usuario"
            />
          </div>
          
          <div class="form-group">
            <label>Contraseña</label>
            <div class="password-input-container">
              <input 
                :type="mostrarPassword ? 'text' : 'password'" 
                v-model="form.password" 
                required
                placeholder="Ingresa tu contraseña"
                class="password-input"
              />
              <button 
                type="button"
                @click="mostrarPassword = !mostrarPassword"
                class="toggle-password-btn"
                :title="mostrarPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'"
              >
                {{ mostrarPassword ? '👁️' : '👁️‍🗨️' }}
              </button>
            </div>
          </div>
          
          <button type="submit" :disabled="loading" class="login-button">
            {{ loading ? 'Iniciando sesión...' : 'Iniciar Sesión' }}
          </button>
        </form>
        
        <div class="demo-users">
          <h4>Usuarios de demostración</h4>
          <div class="demo-user">
            <span class="badge nutriologo">Nutriólogo</span>
            <span class="credentials">nutriologo / nutri123</span>
          </div>
          <div class="demo-user">
            <span class="badge paciente">Paciente</span>
            <span class="credentials">paciente / paciente123</span>
          </div>
          <div class="demo-user">
            <span class="badge admin">Admin</span>
            <span class="credentials">admin / admin123</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import authService from '../services/auth.js'

export default {
  name: 'LoginView',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      loading: false,
      error: null,
      mostrarPassword: false
    }
  },
  methods: {
    async login() {
      if (this.loading) return
      
      this.loading = true
      this.error = null
      
      try {
        // Eliminar espacios en blanco de usuario y contraseña
        const cleanForm = {
          username: this.form.username.trim(),
          password: this.form.password.trim()
        }
        await authService.login(cleanForm)
        
        // Si llegamos aquí, el login fue exitoso
        this.$router.push('/dashboard')
      } catch (error) {
        console.error('Error en login:', error)
        this.error = error.response?.data?.message || error.message || 'Error al iniciar sesión'
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  min-height: 100vh;
  background: #f5f5f5;
}

/* Panel izquierdo - Información */
.info-panel {
  flex: 1;
  background: linear-gradient(135deg, #7cb342 0%, #558b2f 100%);
  color: white;
  padding: 40px;
  overflow-y: auto;
}

.info-content {
  max-width: 600px;
  margin: 0 auto;
}

.logo-section {
  text-align: center;
  margin-bottom: 40px;
}

.main-logo {
  max-width: 300px;
  height: auto;
}

.info-section {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.info-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 25px;
  transition: transform 0.3s ease;
}

.info-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.15);
}

.info-card .icon {
  font-size: 48px;
  margin-bottom: 15px;
}

.info-card h3 {
  margin: 0 0 12px 0;
  font-size: 22px;
  font-weight: 600;
}

.info-card p {
  margin: 8px 0;
  line-height: 1.6;
  opacity: 0.95;
}

.info-card ul {
  list-style: none;
  padding: 0;
  margin: 10px 0 0 0;
}

.info-card ul li {
  padding: 8px 0;
  opacity: 0.95;
}

.info-card.contact {
  background: rgba(255, 255, 255, 0.15);
}

/* Panel derecho - Login */
.login-panel {
  flex: 0 0 480px;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  box-shadow: -5px 0 20px rgba(0, 0, 0, 0.1);
}

.login-content {
  width: 100%;
  max-width: 400px;
}

.login-content h1 {
  margin: 0 0 10px 0;
  color: #333;
  font-size: 32px;
  font-weight: 700;
}

.subtitle {
  color: #666;
  margin: 0 0 30px 0;
  font-size: 16px;
}

.error-message {
  background: #fee;
  color: #c33;
  padding: 12px 15px;
  border-radius: 8px;
  margin-bottom: 20px;
  border-left: 4px solid #c33;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 30px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
  margin-bottom: 8px;
  color: #333;
  font-weight: 600;
  font-size: 14px;
}

.form-group input {
  padding: 12px 15px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.form-group input:focus {
  outline: none;
  border-color: #7cb342;
  box-shadow: 0 0 0 3px rgba(124, 179, 66, 0.1);
}

/* Contenedor de input de contraseña */
.password-input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.password-input {
  flex: 1;
  padding-right: 45px !important;
}

.toggle-password-btn {
  position: absolute;
  right: 10px;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 20px;
  padding: 5px 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  border-radius: 6px;
}

.toggle-password-btn:hover {
  background: rgba(124, 179, 66, 0.1);
}

.toggle-password-btn:active {
  transform: scale(0.95);
}

.login-button {
  padding: 14px;
  background: linear-gradient(135deg, #7cb342 0%, #558b2f 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.login-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(124, 179, 66, 0.3);
}

.login-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.demo-users {
  background: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e0e0e0;
}

.demo-users h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.demo-user {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #e0e0e0;
}

.demo-user:last-child {
  border-bottom: none;
}

.badge {
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  min-width: 80px;
  text-align: center;
}

.badge.nutriologo {
  background: #e3f2fd;
  color: #1976d2;
}

.badge.paciente {
  background: #f3e5f5;
  color: #7b1fa2;
}

.badge.admin {
  background: #fce4ec;
  color: #c2185b;
}

.credentials {
  font-family: 'Courier New', monospace;
  font-size: 13px;
  color: #666;
}

/* Responsive */
@media (max-width: 968px) {
  .login-container {
    flex-direction: column;
  }

  .info-panel {
    min-height: auto;
    padding: 30px 20px;
  }

  .login-panel {
    flex: 1;
    padding: 30px 20px;
  }

  .main-logo {
    max-width: 200px;
  }

  .info-section {
    gap: 15px;
  }

  .info-card {
    padding: 20px;
  }

  .info-card .icon {
    font-size: 36px;
  }

  .info-card h3 {
    font-size: 18px;
  }
}
</style>