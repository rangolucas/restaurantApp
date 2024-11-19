<script setup>
import { ref, onMounted , computed } from 'vue'
import { getApiService } from '../services/getApiService'
import StoresMap from '@/components/StoresMap.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'
import { DISTANCE_THRESHOLD } from '../constants'


const stores = ref([])
const loading = ref(true)
const location = ref(null)
const apiService = getApiService()

async function loadStores() {
  try {
    stores.value = await apiService.getStores()
    loading.value = false
  } catch (error) {
    console.error('Error fetching stores:', error)
  }
}

function getUserLocation() {
  return new Promise((resolve, reject) => {
    if (navigator.geolocation) {
      const options = {
        enableHighAccuracy: false,
        timeout: 10000,
        maximumAge: 600000,
      }
      navigator.geolocation.getCurrentPosition(
        (position) => {
          location.value = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          }
          resolve()
        },
        (error) => {
          console.error('Error getting user location:', error)
          reject(error)
        },
        options,
      )
    } else {
      console.error('Geolocation is not supported by this browser.')
      reject(new Error('Geolocation not supported'))
    }
  })
}

const calculateDistance = (lat1, lng1, lat2, lng2) => {
  return (Math.sqrt(Math.pow(lat2 - lat1, 2) + Math.pow(lng2 - lng1, 2))) * 100;
};

const storesWithDistance = computed(() => {
  return stores.value.map(store => {
    const distance = calculateDistance(location.value.lat, location.value.lng, store.lat, store.lng)
    return { ...store, distance }
  })
})


onMounted(async () => {
  await getUserLocation()
  loadStores()
})
</script>

<template>
  <main>
    <div class="store-list">
      <h1 v-if="storesWithDistance.length > 0">Locales</h1>
      <h1 v-else>No hay locales disponibles</h1>
      <ul v-if="!loading">
        <h1  v-if="storesWithDistance.some(store => store.distance < DISTANCE_THRESHOLD)">Cercanos a tu ubicación</h1>
        <template v-for="store in storesWithDistance">
          <li v-if="store.distance <= DISTANCE_THRESHOLD" :key="store.id">
            <router-link :to="`/user/${store.id}`">
              <img :src="`${store.logo}`" alt="Logo" class="store-logo" />
              <span class="store-name">{{ store.name }}</span> -
              <span class="store-contact">{{ store.contact }}</span> -
              <span class="store-contact">{{ store.address }}</span>
            </router-link>
          </li>
        </template>
        <h1 class="message" v-if="storesWithDistance.some(store => store.distance > DISTANCE_THRESHOLD)">Lejanos a tu ubicación</h1>
        <template v-for="store in storesWithDistance">
          <li v-if="store.distance > DISTANCE_THRESHOLD" :key="store.id" class="gray-out">
            <div>
              <img :src="`${store.logo}`" alt="Logo" class="store-logo" />
              <span class="store-name">{{ store.name }}</span> -
              <span class="store-contact">{{ store.contact }}</span> -
              <span class="store-contact">{{ store.address }}</span>
            </div>
          </li>
        </template>
      </ul>
      <LoadingSpinner v-else />
    </div>
  </main>

  <div class="stores">
    <StoresMap :stores="stores" />
  </div>
</template>

<style scoped>
.gray-out {
  color: gray;
  pointer-events: none;
  opacity: 0.5;
}

.message {
  margin-top: 20px;
  margin-bottom: 10px;
  text-align: center;
  padding: 10px;
}

.stores {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.store-list {
  display: flex;
  flex-direction: column;
  align-items: center;
  max-width: 600px;
  margin: 20px auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
}

.store-list h1 {
  text-align: center;
  color: #333;
  font-size: 1.8em;
  margin-bottom: 15px;
}

.store-list ul {
  list-style: none;
  padding: 0;
}

.store-list li {
  background-color: #ffffff;
  margin: 10px 0;
  padding: 15px 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
  transition:
    transform 0.2s,
    box-shadow 0.2s;
}

.store-list li:hover {
  cursor: pointer;
  transform: translateY(-3px);
  box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.15);
}

.store-name {
  font-weight: bold;
  color: #4a90e2;
}

.store-contact {
  margin-left: 10px;
  color: #555;
}

.store-logo {
  width: 100px;
  height: 100px;
  margin-right: 15px;
  border-radius: 95%;
}


@media (max-width: 600px) {
  .store-list {
    padding: 15px;
  }

  .store-list li {
    padding: 10px 15px;
  }
}
</style>
