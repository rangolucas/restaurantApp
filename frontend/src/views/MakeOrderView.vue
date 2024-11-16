<script setup>
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getApiService } from '../services/apiService'

const route = useRoute()
const storeId = ref(route.params.id)
const menu = ref([])
const selectedItems = ref({})
const apiService = getApiService()

async function getMenu() {
  try {
    menu.value = await apiService.getMenu(storeId)
  } catch (error) {
    console.error('Error fetching menu: ', error)
  }
}

function handleSubmit() {
  const selectedOrder = Object.entries(selectedItems.value)
    .filter(([id, quantity]) => quantity > 0)
    .map(([id, quantity]) => ({
      itemId: id,
      quantity: quantity,
    }))
  
  console.log('Selected Order:', selectedOrder)

  // Send selectedOrder to the back
}

onMounted(getMenu)
</script>

<template>
  <div class="container mt-4">
    <h1 class="text-center mb-4">Hacé tu pedido</h1>
    <form v-on:submit.prevent="handleSubmit">
      <ul class="list-group">
        <li
          v-for="item in menu"
          :key="item.itemId"
          class="list-group-item d-flex justify-content-between align-items-center"
        >
          <div class="d-flex flex-column">
            <strong>{{ item.itemName }}</strong>
            <span class="text-muted">Precio: ${{ item.itemPrice }}</span>
          </div>
          <div class="d-flex align-items-center">
            <label class="me-2 mb-0">Cantidad:</label>
            <input
              type="number"
              class="form-control w-25"
              min="0"
              :placeholder="'Cantidad de ' + item.itemName"
              v-model.number="selectedItems[item.itemId]"
            />
          </div>
        </li>
      </ul>
      <div class="text-center mt-4">
        <button type="submit" class="btn btn-primary">
          Enviar Pedido
        </button>
      </div>
    </form>
  </div>
</template>

<style scoped>
h1 {
  font-size: 1.75rem;
  color: #333;
}

.list-group-item {
  padding: 16px;
  font-size: 1rem;
}

.list-group-item .form-control.input-cantidad {
  width: 120px;
  max-width: none;
}

.text-muted {
  font-size: 0.85rem;
}

button.btn-primary {
  padding: 10px 20px;
  font-size: 1rem;
}

label {
  font-weight: bold;
}

@media (max-width: 768px) {
  .list-group-item {
    flex-wrap: wrap;
  }

  .list-group-item .form-control.input-cantidad {
    width: 100%;
    max-width: none;
  }
}
</style>
