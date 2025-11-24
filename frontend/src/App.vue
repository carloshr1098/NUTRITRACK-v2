<template>
  <v-app>
    <nav-bar v-if="!isLoginRoute" />
    
    <v-main>
      <v-container fluid :class="{ 'pa-0': isLoginRoute }">
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from './components/NavBar.vue'

export default {
  name: 'App',
  components: {
    NavBar
  },
  setup() {
    const route = useRoute()
    
    const isLoginRoute = computed(() => {
      return route.path === '/login' || route.path === '/'
    })
    
    return {
      isLoginRoute
    }
  }
}
</script>

<style>
@import './assets/main.css';

#app {
  background-color: #F5F5F5;
}
</style>
