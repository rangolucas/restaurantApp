<script setup>
const props = defineProps({
  order: {
    type: Object,
    required: true,
  },
})
</script>

<template>
  <main>
    <h1>Número de la orden: #{{ order.orderId }}</h1>
    <h2>Estado: {{ order.state }}</h2>
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
