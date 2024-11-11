<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getApiService } from '../services/apiService'
import { STATES } from '../constants'

const TABS = {
  ORDERS: 'Orders',
  MENU: 'Menu',
}

const route = useRoute()
const loading = ref(true)
const storeId = ref(route.params.id)
const activeTab = ref(TABS.ORDERS)
const orders = ref([])
const menu = ref([])
const apiService = getApiService()

function setActiveTab(tab) {
  activeTab.value = tab
}

function acceptOrder(order) {
  loading.value = true
  apiService.acceptOrder(storeId, order.orderId)
  updateView()
}

function markOrderAsReady(order) {
  loading.value = true
  apiService.markOrderAsReady(storeId, order.orderId)
  updateView()
}

function deleteOrder(order) {
  loading.value = true
  apiService.deleteOrder(storeId, order.orderId)
  updateView()
}

function deleteItem(item) {
  loading.value = true
  apiService.removeItemFromMenu(storeId, item.itemId)
  updateView()
}

async function updateView() {
  try {
    orders.value = await apiService.getOrders()
    menu.value = await apiService.getMenu()
    loading.value = false
  } catch (error) {
    console.error('Error fetching stores: ', error)
  }
}

onMounted(updateView)
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
      <div v-if="loading" class="spinner-wrapper">
        <div class="spinner"></div>
      </div>
      <table v-if="!loading" class="orders-table">
        <thead>
          <tr>
            <th>Mesa</th>
            <th>Estado del pedido</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.userId">
            <td>{{ order.userId }}</td>
            <td>{{ order.state }}</td>
            <td class="order-buttons">
              <button
                v-if="order.state === STATES.PENDING"
                @click="acceptOrder(order)"
                class="btn btn-primary"
              >
                <img
                  src="@/assets/thumbs-up.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.PENDING"
                @click="deleteOrder(order)"
                class="btn btn-primary"
              >
                <img
                  src="@/assets/trash.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.ACCEPTED"
                @click="markOrderAsReady(order)"
                class="btn btn-primary"
              >
                <img
                  src="@/assets/delivered.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.READY"
                @click="deleteOrder(order)"
                class="btn btn-primary"
              >
                <img
                  src="@/assets/trash.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="activeTab === TABS.MENU">
      <div v-if="loading" class="spinner-wrapper">
        <div class="spinner"></div>
      </div>
      <div class="container mt-4">
        <ul class="list-group">
          <li 
            v-for="item in menu"
            :key="item.itemId"
            class="list-group-item d-flex justify-content-between align-items-center"
          >
            <span>{{ item.itemName }}</span>
            <span class="badge bg-success rounded-pill">${{ item.itemPrice }}</span>
            <button
                @click="deleteItem(item)"
                class="btn btn-danger"
            >
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

.order-buttons {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  gap: 5px;
}

.orders-table {
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
.spinner-wrapper {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
