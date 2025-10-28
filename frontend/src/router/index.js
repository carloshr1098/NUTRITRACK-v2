import { createRouter, createWebHistory } from 'vue-router'
import authService from '../services/auth.js'

// Views
import LoginView from '../views/LoginView.vue'
import DashboardView from '../views/DashboardView.vue'

// Admin views
import AdminUsersView from '../views/admin/AdminUsersView.vue'
import AdminReportsView from '../views/admin/AdminReportsView.vue'

// Nutritionist views
import NutritionistPatientsView from '../views/nutritionist/NutritionistPatientsView.vue'
import NutritionistAppointmentsView from '../views/nutritionist/NutritionistAppointmentsView.vue'
import NutritionistDietPlansView from '../views/nutritionist/NutritionistDietPlansView.vue'

// Patient views
import PatientProfileView from '../views/patient/PatientProfileView.vue'
import PatientAppointmentsView from '../views/patient/PatientAppointmentsView.vue'
import PatientDietPlanView from '../views/patient/PatientDietPlanView.vue'
import PatientWeightTrackingView from '../views/patient/PatientWeightTrackingView.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
    meta: { requiresGuest: true }
  },
  {
    path: '/',
    name: 'Dashboard',
    component: DashboardView,
    meta: { requiresAuth: true }
  },
  // Admin routes
  {
    path: '/admin/users',
    name: 'AdminUsers',
    component: AdminUsersView,
    meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
  },
  {
    path: '/admin/reports',
    name: 'AdminReports',
    component: AdminReportsView,
    meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
  },
  // Nutritionist routes
  {
    path: '/nutritionist/patients',
    name: 'NutritionistPatients',
    component: NutritionistPatientsView,
    meta: { requiresAuth: true, roles: ['ROLE_NUTRITIONIST', 'ROLE_ADMIN'] }
  },
  {
    path: '/nutritionist/appointments',
    name: 'NutritionistAppointments',
    component: NutritionistAppointmentsView,
    meta: { requiresAuth: true, roles: ['ROLE_NUTRITIONIST', 'ROLE_ADMIN'] }
  },
  {
    path: '/nutritionist/diet-plans',
    name: 'NutritionistDietPlans',
    component: NutritionistDietPlansView,
    meta: { requiresAuth: true, roles: ['ROLE_NUTRITIONIST', 'ROLE_ADMIN'] }
  },
  // Patient routes
  {
    path: '/patient/profile',
    name: 'PatientProfile',
    component: PatientProfileView,
    meta: { requiresAuth: true, roles: ['ROLE_PATIENT'] }
  },
  {
    path: '/patient/appointments',
    name: 'PatientAppointments',
    component: PatientAppointmentsView,
    meta: { requiresAuth: true, roles: ['ROLE_PATIENT'] }
  },
  {
    path: '/patient/diet-plan',
    name: 'PatientDietPlan',
    component: PatientDietPlanView,
    meta: { requiresAuth: true, roles: ['ROLE_PATIENT'] }
  },
  {
    path: '/patient/weight-tracking',
    name: 'PatientWeightTracking',
    component: PatientWeightTrackingView,
    meta: { requiresAuth: true, roles: ['ROLE_PATIENT'] }
  },
  // Catch all route - redirect to dashboard
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guards
router.beforeEach((to, from, next) => {
  const isAuthenticated = authService.isAuthenticated.value
  const userRoles = authService.getUserRoles()

  // Check if route requires authentication
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
    return
  }

  // Check if route requires guest (unauthenticated)
  if (to.meta.requiresGuest && isAuthenticated) {
    next('/')
    return
  }

  // Check role-based access
  if (to.meta.roles && to.meta.roles.length > 0) {
    const hasRequiredRole = to.meta.roles.some(role => userRoles.includes(role))
    if (!hasRequiredRole) {
      // Redirect to dashboard if user doesn't have required role
      next('/')
      return
    }
  }

  next()
})

export default router