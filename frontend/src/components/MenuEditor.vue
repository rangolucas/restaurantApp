<script setup>
import { ref, onMounted } from 'vue'
import { getApiService } from '../services/getApiService'
import LoadingSpinner from './LoadingSpinner.vue'

const props = defineProps({
  storeId: {
    type: String,
    required: true,
  },
})

const loading = ref(true)
const apiService = getApiService()
const menu = ref([])
const itemName = ref('')
const itemPrice = ref('')

async function deleteItem(item) {
  await runAndUpdateView(async () =>
    await apiService.removeItemFromMenu(props.storeId, item.itemId),
  )
}

async function addItem() {
  await runAndUpdateView(async () => {
    const newItem = {
      name: itemName.value,
      price: itemPrice.value,
    }
    await apiService.addItemToMenu(props.storeId, newItem)
  })
}

async function runAndUpdateView(action) {
  loading.value = true
  await action()
  updateView()
}

async function updateView() {
  try {
    menu.value = await apiService.getMenu(props.storeId)
    loading.value = false
  } catch (error) {
    console.error('Error fetching menu: ', error)
  }
}

onMounted(updateView)
</script>

<template>
  <div>
    <div v-if="loading" class="spinner-wrapper">
      <LoadingSpinner />
    </div>
    <div class="container mt-4">
      <ul class="list-group">
        <li
          v-for="item in menu"
          :key="item.itemId"
          class="list-group-item d-flex justify-content-between align-items-center"
        >
          <span class="col-5">{{ item.itemName }}</span>
          <span class="col-13 text-center badge bg-success rounded-pill">
            ${{ item.price }}
          </span>
          <button @click="deleteItem(item)" class="btn btn-danger">
            <img
              src="@/assets/trash.svg"
              alt="icon"
              style="width: 24px; height: auto"
            />
          </button>
        </li>
      </ul>

      <form @submit.prevent="addItem" class="mb-4" id="agregarProducto">
        <h4>Agregar un producto</h4>
        <div class="mb-3">
          <label for="itemName" class="form-label">Nombre</label>
          <input
            v-model="itemName"
            type="text"
            id="itemName"
            class="form-control"
            required
          />
        </div>
        <div class="mb-3">
          <label for="itemPrice" class="form-label">Precio</label>
          <input
            v-model="itemPrice"
            type="number"
            id="itemPrice"
            class="form-control"
            required
          />
        </div>
        <button type="submit" class="btn btn-primary">Agregar</button>
      </form>
    </div>
  </div>
</template>

<style scoped>

#agregarProducto {
  padding: 10px;
}
.menu-view {
  padding: 20px;
  font-size: 16px;
  color: #555;
}

.spinner-wrapper {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

span {
  display:inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 35ch;
}
</style>
