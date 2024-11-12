<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getApiService } from '../services/apiService'

const router = useRouter()
const storeName = ref('')
const storeContact = ref('')
const apiService = getApiService()

async function registerStore() {
    const store = {
      name: storeName.value,
      contact: storeContact.value,
    }

    await apiService.addStore(store)
    router.push('/stores')
}

onMounted(() => {})
</script>

<template>
  <div class="container mt-4">
    <h1 class="text-center mb-4">Registrar local</h1>
    <form v-on:submit.prevent="registerStore" class="p-4 border rounded shadow">
      <!-- Nombre del local -->
      <div class="mb-3">
        <label for="storeName" class="form-label">Nombre del local</label>
        <input type="text" v-model="storeName" id="storeName" class="form-control" required>
      </div>

      <!-- Contacto del local -->
      <div class="mb-3">
        <label for="storeContact" class="form-label">Contacto del local</label>
        <input type="text" v-model="storeContact" id="storeContact" class="form-control" required>
      </div>

      <!-- Logo/Fotos -->
      <div class="mb-3">
        <label for="storePhotos" class="form-label">Fotos o logo del local</label>
        <input type="file" id="storePhotos" class="form-control" multiple>
      </div>

      <!-- Horarios -->
      <div class="mb-3">
        <label for="storeHours" class="form-label">Horarios</label>
        <input type="text" v-model="storeHours" id="storeHours" class="form-control" placeholder="Ej. Lunes a Viernes: 9 AM - 6 PM">
      </div>

      <button type="submit" class="btn btn-primary w-100">Registrar Local</button>
    </form>
  </div>
</template>

<style scoped>
.container {
  max-width: 500px;
}
</style>
