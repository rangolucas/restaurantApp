<script setup>
import { ref } from 'vue';

const orderStatus = ref('En preparación');
const orderId = ref('123456');
</script>

<template>
  <main>
    <h1>Número de la orden: #{{ orderId }}</h1>
    <h2>Estado: {{ orderStatus }}</h2>

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
