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
    <h1>Registrar local</h1>
    <form v-on:submit.prevent="registerStore">
        <input type="text" v-model="storeName">
        <input type="text" v-model="storeContact">
        <input type="submit">
    </form>
</template>

<style scoped>
</style>
