<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const TABS = {
  ORDERS: 'Orders',
  MENU: 'Menu',
}

const route = useRoute()
const storeId = ref(route.params.id)
const activeTab = ref(TABS.ORDERS)
const orders = ref([])

function loadOrders(storeId) {
  return [
    { state: 'ready', user_id: 'user1' },
    { state: 'rejected', user_id: 'user2' },
    { state: 'ready', user_id: 'user3' },
    { state: 'accepted', user_id: 'user4' },
  ]
}

function setActiveTab(tab) {
  activeTab.value = tab
}

onMounted(() => {
  console.log(`Store ID: ${storeId.value}`)

  try {
    orders.value = loadOrders()
  } catch (error) {
    console.error('Error fetching stores: ', error)
  }
})
</script>

<template>
  <div>
    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a
          class="nav-link"
          :class="{ active: activeTab === TABS.ORDERS }"
          v-on:click="setActiveTab(TABS.ORDERS)"
          >Pedidos</a
        >
      </li>
      <li class="nav-item">
        <a
          class="nav-link"
          :class="{ active: activeTab === TABS.MENU }"
          v-on:click="setActiveTab(TABS.MENU)"
          >Menu</a
        >
      </li>
    </ul>

    <div v-if="activeTab === TABS.ORDERS">
      <ul class="orders">
        <li v-for="order in orders" :key="order.user_id">
          <span>{{ order.state }}</span> -
          <span>{{ order.user_id }}</span>
        </li>
      </ul>
    </div>

    <div v-if="activeTab === TABS.MENU">
      <p>Esta es la vista de Menú del restaurante.</p>
    </div>
  </div>
</template>

<style scoped>
.orders {
  list-style-type: none;
  padding: 0;
}
.orders li {
  padding: 10px;
  margin-bottom: 5px;
  margin-left: 10px;
  border: 1px solid #ddd;
  background-color: #a3c6f8;
  border-radius: 5px;
}
li {
  cursor: pointer;
}
</style>
