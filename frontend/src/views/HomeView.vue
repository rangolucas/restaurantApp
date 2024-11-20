<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'

const router = useRoute()

onMounted(() => {})
</script>

<template>
  <div class="home-container">
    <header class="header">
      <h1>verLaCarta</h1>
    </header>

    <main class="main-content">
      <div class="welcome-message">
        <h4>Elige el modo de acceso</h4>
      </div>

      <div class="buttons-container">
        <router-link to="/user" class="action-button user-button">
          <span class="button-icon">👤</span>
          <span class="button-text">Modo Usuario</span>
        </router-link>

        <router-link to="/stores" class="action-button business-button">
          <span class="button-icon">🏪</span>
          <span class="button-text">Modo Negocio</span>
        </router-link>
      </div>
    </main>
  </div>
</template>


<style scoped>
.home-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
  padding: 2rem;
  color: #1a1a1a;
}

.header {
  text-align: center;
  margin-bottom: 3rem;
}

.main-content {
  flex: 1;
  width: 100%;
  max-width: 800px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.welcome-message {
  text-align: center;
  margin-bottom: 3rem;
  color: #666;
}

.buttons-container {
  display: flex;
  gap: 2rem;
  flex-wrap: wrap;
  justify-content: center;
}

.action-button {
  width: 300px;
  padding: 2rem;
  border-radius: 12px;
  text-decoration: none;
  color: #1a1a1a;
  text-align: center;
  transition: transform 0.2s, box-shadow 0.2s;
  backdrop-filter: blur(10px);
}

.action-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
}

.user-button {
  background-color: rgba(52, 152, 219, 0.2);
  border: 1px solid #3498db;
}

.user-button:hover {
  background-color: rgba(52, 152, 219, 0.3);
}

.business-button {
  background-color: rgba(46, 204, 113, 0.2);
  border: 1px solid #2ecc71;
}

.business-button:hover {
  background-color: rgba(46, 204, 113, 0.3);
}

.button-icon {
  font-size: 2.5rem;
  display: block;
  margin-bottom: 1rem;
}

.button-text {
  font-size: 1.5rem;
  font-weight: bold;
  display: block;
  margin-bottom: 0.5rem;
}

.button-description {
  font-size: 0.9rem;
  opacity: 0.9;
}

.footer {
  margin-top: 3rem;
  color: #666;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .buttons-container {
    flex-direction: column;
    gap: 1rem;
  }

  .action-button {
    width: 100%;
  }
}
</style>
