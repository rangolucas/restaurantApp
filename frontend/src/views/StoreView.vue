<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import OrdersTable from '@/components/OrdersTable.vue'
import MenuEditor from '@/components/MenuEditor.vue'
import QrCode from '@/components/QR.vue'

const TABS = {
  ORDERS: 'Orders',
  MENU: 'Menu',
}

const route = useRoute()
const storeId = ref(route.params.id)
const activeTab = ref(TABS.ORDERS)

const qrCodeUrl = computed(() => {
  const baseUrl = window.location.origin // Current base URL
  return `${baseUrl}/user/${storeId.value}`
})

function setActiveTab(tab) {
  activeTab.value = tab
}
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

    <OrdersTable v-if="activeTab === TABS.ORDERS" :storeId="storeId" />
    <MenuEditor v-if="activeTab === TABS.MENU" :storeId="storeId" />

    <div class="qr-container">
      <QrCode :url="qrCodeUrl" class="qrcode" />
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

.qr-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.qrcode {
  border: 2px solid #ddd;
  padding: 10px;
}
</style>
