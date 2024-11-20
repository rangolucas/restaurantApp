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
    <h1>Número de la orden: #{{ order.tableId }}</h1>
    <h2>{{ STATES[order.state] }}</h2>
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100vh;
  padding: 20px;
}
</style>
