<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getApiService } from '../services/getApiService'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import Menu from '../components/Menu.vue'
import OrderStatus from '../components/OrderStatus.vue'

const route = useRoute()
const storeId = ref(route.params.storeId)
const apiService = getApiService()
const loading = ref(true)
const menu = ref(null)
const order = ref(null)

async function checkIn() {
  try {
    loading.value = true
    const [updatedOrder, updatedMenu] = await apiService.checkIn(storeId.value)
    order.value = updatedOrder
    menu.value = updatedMenu
    loading.value = false
  } catch (error) {
    console.error('Error performing check-in action', error)
  }
}

onMounted(checkIn)
</script>

<template>
  <div v-if="loading" class="spinner-wrapper">
    <LoadingSpinner />
  </div>
  <OrderStatus v-else-if="order != null" :order="order" />
  <Menu v-else :menu="menu" :checkIn="checkIn" />
</template>

<style scoped>
.spinner-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
}
</style>
