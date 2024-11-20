<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getApiService } from '../services/getApiService'
import { DISTANCE_THRESHOLD } from '../constants'

const route = useRoute()
const apiService = getApiService()

const storeId = ref(route.params.storeId)
const selectedItems = ref({})
const userLocation = ref(null)
const loadingSubmit = ref(false)
const isCloseEnough = ref(false)

const props = defineProps({
  menu: {
    type: Array,
    required: true,
  },
  checkIn: {
    type: Function,
    required: true,
  },
})

function getUserLocation() {
  return new Promise((resolve, reject) => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          userLocation.value = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          }
          resolve()
        },
        (error) => {
          console.error('Error getting user location:', error)
          reject(error)
        }
      )
    } else {
      console.error('Geolocation is not supported by this browser.')
      reject(new Error('Geolocation not supported'))
    }
  })
}

const calculateDistance = (lat1, lng1, lat2, lng2) => {
  return (Math.sqrt(Math.pow(lat2 - lat1, 2) + Math.pow(lng2 - lng1, 2))) * 100;
}

async function getStore(storeId) {
  const stores = await apiService.getStores()
  const storeToReturn = stores.find(s => s.id === storeId)
  return storeToReturn
}

async function checkProximity() {
  try {
    await getUserLocation()
    const store = await getStore(storeId.value)
    const distance = calculateDistance(
      userLocation.value.lat,
      userLocation.value.lng,
      store.lat,
      store.lng
    )
    isCloseEnough.value = distance <= DISTANCE_THRESHOLD
  } catch (error) {
    console.error('Error checking proximity:', error)
  }
}

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
  const order = {
    userLocation: userLocation.value,
    selectedItems: selectedItems.value,
    takeaway: false,
  }

  await apiService.createOrder(storeId.value, order)
  loadingSubmit.value = false
  await props.checkIn()
}

onMounted(checkProximity)
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
                  v-if="isCloseEnough"
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
                  v-if="isCloseEnough"
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
          <button
            v-if="isCloseEnough"
            type="submit"
            class="btn btn-primary"
          >
            Enviar Pedido
          </button>
          <p v-else class="text-danger">
            Debes estar cerca para hacer un pedido.
          </p>
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
