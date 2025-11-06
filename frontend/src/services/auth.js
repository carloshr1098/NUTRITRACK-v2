import { ref, computed } from 'vue'
import api from './api.js'

const token = ref(localStorage.getItem('token'))

// Safely parse user from localStorage
let userData = null
try {
  const storedUser = localStorage.getItem('user')
  if (storedUser && storedUser !== 'null' && storedUser !== 'undefined') {
    userData = JSON.parse(storedUser)
  }
} catch (error) {
  console.warn('Error parsing user from localStorage:', error)
  localStorage.removeItem('user') // Clean up invalid data
}
const user = ref(userData)

const authService = {
  // Reactive state
  token,
  currentUser: user,
  isAuthenticated: computed(() => !!token.value),

  // Login method
  async login(credentials) {
    try {
      const response = await api.post('/auth/signin', credentials)
      const { accessToken, ...userData } = response.data
      
      // Remover tokenType de los datos del usuario
      delete userData.tokenType
      
      this.setAuthData(accessToken, userData)
      return response.data
    } catch (error) {
      throw error
    }
  },

  // Register method
  async register(userData) {
    try {
      const response = await api.post('/auth/signup', userData)
      return response.data
    } catch (error) {
      throw error
    }
  },

  // Logout method
  async logout() {
    this.clearAuthData()
  },

  // Set authentication data
  setAuthData(accessToken, userData) {
    token.value = accessToken
    user.value = userData
    localStorage.setItem('token', accessToken)
    localStorage.setItem('user', JSON.stringify(userData))
    
    // Set default authorization header
    api.defaults.headers.common['Authorization'] = `Bearer ${accessToken}`
  },

  // Clear authentication data
  clearAuthData() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    
    // Remove authorization header
    delete api.defaults.headers.common['Authorization']
  },

  // Check authentication status
  checkAuthStatus() {
    const storedToken = localStorage.getItem('token')
    const storedUser = localStorage.getItem('user')
    
    if (storedToken && storedUser && storedUser !== 'null' && storedUser !== 'undefined') {
      try {
        token.value = storedToken
        user.value = JSON.parse(storedUser)
        api.defaults.headers.common['Authorization'] = `Bearer ${storedToken}`
      } catch (error) {
        console.warn('Error parsing stored user data:', error)
        this.clearAuthData()
      }
    } else {
      this.clearAuthData()
    }
  },

  // Get user roles
  getUserRoles() {
    return user.value?.roles || []
  },

  // Check if user has specific role
  hasRole(role) {
    const roles = this.getUserRoles()
    return roles.includes(role)
  },

  // Check if user is admin
  isAdmin() {
    return this.hasRole('ROLE_ADMIN')
  },

  // Verificar si el usuario es nutriólogo
  esNutriologo() {
    return this.hasRole('ROLE_NUTRIOLOGO')
  },

  // Verificar si el usuario es paciente
  esPaciente() {
    return this.hasRole('ROLE_PACIENTE')
  }
}

// Initialize auth status
authService.checkAuthStatus()

export default authService