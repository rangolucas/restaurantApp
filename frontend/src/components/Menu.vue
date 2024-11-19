<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getApiService } from '../services/getApiService'
import LoadingSpinner from '../components/LoadingSpinner.vue'

const router = useRouter()
const userLocation = useRoute().state?.userLocation
const selectedItems = ref({})
const apiService = getApiService()
const loadingSubmit = ref(false)

const props = defineProps({
  menu: {
    type: Array,
    required: true,
  },
  storeId: {
    type: String,
    required: true,
  },
  checkIn: {
    type: Function,
    required: true,
  },
})

function incrementQuantity(itemName) {
  selectedItems.value[itemName] = (selectedItems.value[itemName] || 0) + 1
}

function decrementQuantity(itemName) {
  if (selectedItems.value[itemName] > 0) {
    selectedItems.value[itemName] -= 1
  } else {
    delete selectedItems.value[itemName]
  }
}

async function handleSubmit() {
  loadingSubmit.value = true
  await apiService.createOrder(
    userLocation,
    props.storeId,
    selectedItems.value,
    false,
  )
  loadingSubmit.value = false
  await props.checkIn()
}
</script>

<template>
  <div class="container mt-4">
    <h1 class="text-center mb-4">Hacé tu pedido</h1>
    <div class="content-wrapper">
      <form @submit.prevent="handleSubmit">
        <ul class="list-group">
          <li
            v-for="item in menu"
            :key="item.itemId"
            class="list-group-item d-flex justify-content-between align-items-center"
          >
            <div class="d-flex flex-column" style="flex: 3">
              <strong>{{ item.itemName }}</strong>
              <span class="text-muted">Precio: ${{ item.price }}</span>
            </div>
            <div class="d-flex align-items-center" style="flex: 2">
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
          <button type="submit" class="btn btn-primary">Enviar Pedido</button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
h1 {
  font-size: 1.75rem;
  color: #333;
}

.content-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
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

strong {
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 35ch;
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
