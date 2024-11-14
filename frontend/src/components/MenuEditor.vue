<script setup>
import { ref, onMounted } from 'vue'
import { getApiService } from '../services/apiService'
import { defineProps } from 'vue'
import LoadingSpinner from './LoadingSpinner.vue'

const props = defineProps({
  storeId: {
    type: String,
    required: true,
  },
})

const loading = ref(true)
const menu = ref([])
const apiService = getApiService()

function deleteItem(item) {
  runAndUpdateView(() =>
    apiService.removeItemFromMenu(props.storeId, item.itemId),
  )
}

function runAndUpdateView(action) {
  loading.value = true
  action()
  updateView()
}

async function updateView() {
  try {
    menu.value = await apiService.getMenu()
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
          <span>{{ item.itemName }}</span>
          <span class="badge bg-success rounded-pill"
            >${{ item.itemPrice }}</span
          >
          <button @click="deleteItem(item)" class="btn btn-danger">
            <img
              src="@/assets/trash.svg"
              alt="icon"
              style="width: 24px; height: auto"
            />
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
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
</style>
