<script setup>
import { STATES } from '../constants'

const props = defineProps({
  order: {
    type: Object,
    required: true,
  },
})
</script>

<template>
  <main>
    <div class="order-status">
      <h1>Número de la orden: #{{ order.tableId }}</h1>
      <h2 class="order-state">{{ STATES[order.state] }}</h2>
    </div>
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100vh;
  padding: 20px;
  background-color: #f9f9f9;
  font-family: Arial, sans-serif;
}

.order-status {
  background-color: #ffffff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
  max-width: 400px;
  width: 100%;
}

.order-status h1 {
  color: #333;
  font-size: 1.8em;
  margin-bottom: 15px;
}

.order-status h2 {
  color: #4a90e2;
  font-size: 1.5em;
  margin-top: 0;
}

.order-state {
  font-weight: bold;
}
</style>
