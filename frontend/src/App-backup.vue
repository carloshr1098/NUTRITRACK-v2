<template>
  <div id="app">
    <h1>NutriTrack - Test</h1>
    <p>Probando si Vue funciona sin Vuetify</p>
    <TestComponent />
    <router-view />
  </div>
</template>

<script>
import TestComponent from './TestComponent.vue'

export default {
  name: 'App',
  components: {
    TestComponent
  }
}
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  padding: 20px;
}
</style>