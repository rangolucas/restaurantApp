<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getApiService } from '../services/getApiService'
import { Loader } from '@googlemaps/js-api-loader'

const router = useRouter()
const storeName = ref('')
const storeAddress = ref('')
const storeContact = ref('')
const storeHours = ref('')
const storeLat = ref(null)
const storeLng = ref(null)
const storeLogo = ref(null)
const apiService = getApiService()

async function registerStore() {
  const store = {
    name: storeName.value,
    address: storeAddress.value,
    contact: storeContact.value,
    hours: storeHours.value,
    lat: storeLat.value,
    lng: storeLng.value,
    logo: storeLogo.value,
  }

  await apiService.addStore(store)
  router.push('/stores')
}

function handleFileChange(event) {
  const file = event.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = e => {
      storeLogo.value = e.target.result
    }
    reader.readAsDataURL(file)
  }
}

onMounted(() => {
  const loader = new Loader({
    apiKey: import.meta.env.VITE_GOOGLE_API_KEY,
    version: 'weekly',
    libraries: ['places', 'marker'],
  })

  loader.load().then(() => {
    const input = document.getElementById('storeAddress')
    const autocomplete = new google.maps.places.Autocomplete(input)

    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace()
      if (place.geometry) {
        const formattedAddress = place.formatted_address
        const addressParts = formattedAddress.split(',')
        storeAddress.value = addressParts[0] // Save only the first part of the address
        storeLat.value = place.geometry.location.lat()
        storeLng.value = place.geometry.location.lng()
      }
    })
  })
})
</script>

<template>
  <div class="container mt-4">
    <h1 class="text-center mb-4">Registrar local</h1>
    <form v-on:submit.prevent="registerStore" class="p-4 border rounded shadow">
      <!-- Nombre del local -->
      <div class="mb-3">
        <label for="storeName" class="form-label">Nombre</label>
        <input
          type="text"
          v-model="storeName"
          id="storeName"
          class="form-control"
          placeholder="Example"
          required
        />
      </div>

      <!-- Direccion del local -->
      <div class="mb-3">
        <label for="storeAddress" class="form-label">Dirección</label>
        <input
          type="text"
          v-model="storeAddress"
          id="storeAddress"
          class="form-control"
          placeholder="Calle 1234"
          required
        />
      </div>

      <!-- Contacto del local -->
      <div class="mb-3">
        <label for="storeContact" class="form-label">Contacto</label>
        <input
          type="text"
          v-model="storeContact"
          id="storeContact"
          class="form-control"
          placeholder="11 4000-0000"
          required
        />
      </div>

      <!-- Horarios -->
      <div class="mb-3">
        <label for="storeHours" class="form-label">Horarios</label>
        <input
          type="text"
          v-model="storeHours"
          id="storeHours"
          class="form-control"
          placeholder="Lunes a Viernes: 9 AM - 6 PM"
          required
        />
      </div>

      <!-- Logo -->
      <div class="mb-3">
        <label for="storeLogo" class="form-label">Logo del local</label>
        <input
          type="file"
          id="storeLogo"
          class="form-control"
          @change="handleFileChange"
          required
        />
      </div>

      <button type="submit" class="btn btn-primary w-100">
        Registrar Local
      </button>
    </form>
  </div>
</template>

<style scoped>
.container {
  max-width: 600px;
  margin: 0 auto;
}
</style>
