<template>
  <div id="app">
    <nav style="padding: 20px; background: #f5f5f5; margin-bottom: 20px;">
      <router-link to="/login" style="margin-right: 20px;">Login</router-link>
      <router-link to="/dashboard">Dashboard</router-link>
    </nav>
    <div style="padding: 20px;">
      <router-view />
    </div>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
body {
  margin: 0;
  font-family: Arial, sans-serif;
}

a {
  color: #2c3e50;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}
</style>