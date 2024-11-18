<script setup>
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getApiService } from '../services/getApiService'

const route = useRoute()
const orderId = ref(route.params.id)
const order = ref({ orderId: '', state: '' })
const apiService = getApiService()

async function loadOrder() {
  try {
    order.value = await apiService.getOrderById(orderId.value)
  } catch (error) {
    console.error('Error fetching stores:', error)
  }
}

onMounted(loadOrder)
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
