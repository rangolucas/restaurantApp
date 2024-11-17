<script setup>
import { ref, onMounted } from 'vue'
import { getApiService } from '../services/apiService'
import StoresMap from "@/components/StoresMap.vue";


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

function updateLocation (newLocation) {
  location.value = newLocation
}

onMounted(loadStores)
</script>

<template>
  <main>
    <div class="store-list">
      <h1>Locales disponibles</h1>
      <ul v-if="!loading">
        <li v-for="store in stores" :key="store.id">
          <router-link :to="`/user/${store.id}`">
            <img :src="`${store.logo}`" alt="Logo" class="store-logo" />
            <span class="store-name">{{ store.name }}</span> -
            <span class="store-contact">{{ store.contact }}</span> -
            <span class="store-contact">{{ store.address }}</span>
          </router-link>
        </li>
      </ul>
      <p v-else>Cargando locales</p>
    </div>
  </main>

  <div class="stores">
    <StoresMap :stores="stores" :updateLocation="updateLocation"/>
  </div>
</template>

<style scoped>
.stores {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.store-list {
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
