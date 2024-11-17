<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getApiService } from '../services/apiService'

const route = useRoute()
const router = useRouter()
const storeId = ref(route.params.id)
const menu = ref([])
const selectedItems = ref({})
const apiService = getApiService()

async function getMenu() {
  try {
    menu.value = await apiService.getMenu(storeId.value)
  } catch (error) {
    console.error('Error fetching menu: ', error)
  }
}

function incrementQuantity(itemId) {
  selectedItems.value[itemId] = (selectedItems.value[itemId] || 0) + 1
}

function decrementQuantity(itemId) {
  if (selectedItems.value[itemId] > 0) {
    selectedItems.value[itemId] -= 1
  }
}

async function handleSubmit() {
  const selectedOrder = Object.entries(selectedItems.value)
    .filter(([id, quantity]) => quantity > 0)
    .map(([id, quantity]) => ({
      itemId: id,
      quantity: quantity,
    }))

  const orderCreated = await apiService.createOrder(selectedOrder)
  router.push(`/user/orders/${orderCreated.orderId}`)
}

onMounted(getMenu)
</script>

<template>
  <div class="container mt-4">
    <h1 class="text-center mb-4">Hacé tu pedido</h1>
    <form @submit.prevent="handleSubmit">
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
            <div class="input-group">
              <button
                type="button"
                class="btn btn-outline-secondary"
                @click="decrementQuantity(item.itemId)"
              >
                -
              </button>
              <input
                type="number"
                class="form-control text-center w-25"
                min="0"
                :placeholder="0"
                v-model.number="selectedItems[item.itemId]"
                readonly
              />
              <button
                type="button"
                class="btn btn-outline-secondary"
                @click="incrementQuantity(item.itemId)"
              >
                +
              </button>
            </div>
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

.input-group {
  display: flex;
  align-items: center;
}

.input-group .btn {
  font-size: 1rem;
  padding: 0.5rem;
}

@media (max-width: 768px) {
  .list-group-item {
    flex-wrap: wrap;
  }

  .input-group {
    width: 100%;
  }
}
</style>
