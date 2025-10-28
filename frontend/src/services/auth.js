import { ref, computed } from 'vue'
import api from './api.js'

const token = ref(localStorage.getItem('token'))
const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

const authService = {
  // Reactive state
  token,
  currentUser: user,
  isAuthenticated: computed(() => !!token.value),

  // Login method
  async login(credentials) {
    try {
      const response = await api.post('/auth/signin', credentials)
      const { accessToken, user: userData } = response.data
      
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
    
    if (storedToken && storedUser) {
      token.value = storedToken
      user.value = JSON.parse(storedUser)
      api.defaults.headers.common['Authorization'] = `Bearer ${storedToken}`
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

  // Check if user is nutritionist
  isNutritionist() {
    return this.hasRole('ROLE_NUTRITIONIST')
  },

  // Check if user is patient
  isPatient() {
    return this.hasRole('ROLE_PATIENT')
  }
}

// Initialize auth status
authService.checkAuthStatus()

export default authService