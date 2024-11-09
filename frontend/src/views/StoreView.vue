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

    <div v-if="activeTab === TABS.ORDERS" class="table-container">
      <table class="orders-table">
        <thead>
          <tr>
            <th>Mesa</th>
            <th>Estado del pedido</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.user_id">
            <td>{{ order.user_id }}</td>
            <td>{{ order.state }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="activeTab === TABS.MENU">
      <p class="menu-view">Esta es la vista de Menú del restaurante.</p>
    </div>
  </div>
</template>

<style scoped>
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f9f9f9;
  color: #333;
  margin: 0;
  padding: 0;
}

.nav-tabs {
  display: flex;
  justify-content: center;
  border-bottom: 2px solid #ddd;
  padding: 0;
  width: 100%;
}

.nav-item {
  margin-right: 20px;
}

.nav-link {
  font-size: 16px;
  color: #007bff;
  text-decoration: none;
  padding: 10px 15px;
  border-radius: 5px;
  transition:
    background-color 0.3s,
    color 0.3s;
}

.nav-link:hover {
  background-color: #e9ecef;
}

.nav-link.active {
  color: #fff;
  background-color: #007bff;
}

.table-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 20px 0;
}

/* Orders Table */
.orders-table {
  width: 80%;
  max-width: 1200px;
  border-collapse: collapse;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.orders-table th,
.orders-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.orders-table th {
  background-color: #007bff;
  color: #fff;
  font-weight: 600;
}

.orders-table tr:hover {
  background-color: #f1f1f1;
}

.orders-table tr:last-child td {
  border-bottom: none;
}

.menu-view {
  padding: 20px;
  font-size: 16px;
  color: #555;
}
</style>
