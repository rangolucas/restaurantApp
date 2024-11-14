import axios from 'axios'
import { STATES } from '../constants'

const ordersDB = [
  { orderId: '1', state: STATES.READY, userId: 'user1' },
  { orderId: '2', state: STATES.ACCEPTED, userId: 'user2' },
  { orderId: '3', state: STATES.READY, userId: 'user3' },
  { orderId: '4', state: STATES.PENDING, userId: 'user4' },
]

const menuDB = [
  { itemId: '1', itemName: 'name1', itemPrice: 'price1' },
  { itemId: '2', itemName: 'name2', itemPrice: 'price2' },
  { itemId: '3', itemName: 'name3', itemPrice: 'price3' },
  { itemId: '4', itemName: 'name4', itemPrice: 'price4' },
]

const storesDB = [
  { id: 'store1', contact: 'store@test.com' },
  { id: 'store2', contact: 'store@test.com' },
  { id: 'store3', contact: 'store@test.com' },
  { id: 'store4', contact: 'store@test.com' },
]

export const apiServiceDev = {
  async getOrders() {
    await new Promise(resolve => setTimeout(resolve, 300))
    return ordersDB
  },

  async markOrderAsReady(storeId, orderId) {
    const order = ordersDB.find(order => order.orderId === orderId)

    if (order) {
      order.state = STATES.READY
    } else {
      console.log('Order not found')
    }
  },

  async acceptOrder(storeId, orderId) {
    const order = ordersDB.find(order => order.orderId === orderId)

    if (order) {
      order.state = STATES.ACCEPTED
    } else {
      console.log('Order not found')
    }
  },

  async deleteOrder(storeId, orderId) {
    const order = ordersDB.find(order => order.orderId === orderId)

    if (order) {
      ordersDB.splice(ordersDB.indexOf(order), 1)
    } else {
      console.log('Order not found')
    }
  },

  async getMenu() {
    setTimeout(function () {}, 2000)
    return menuDB
  },

  async addItemToMenu(storeId, itemId) {
    // do nothing
  },

  async removeItemFromMenu(storeId, itemId) {
    const menuItem = menuDB.find(item => item.itemId === itemId)

    if (menuItem) {
      menuDB.splice(menuDB.indexOf(menuItem), 1)
    } else {
      console.log('Item not found')
    }
  },

  async getStores() {
    setTimeout(function () {}, 2000)
    return storesDB
  },

  async addStore(store) {
    storesDB.push({ id: 'testId', contact: store.contact })
  },
}

const PROD_URL = 'http://localhost:4567'

export const apiServiceProd = {
  async getOrders(storeId) {
    try {
      const response = await axios.get(`${PROD_URL}/${storeId}/orders`)
      return response.data
    } catch (error) {
      console.error('Error fetching items:', error)
      throw error
    }
  },

  async getMenu(storeId) {
    try {
      const response = await axios.get(`${PROD_URL}/${storeId}/menu`)
      return response.data
    } catch (error) {
      console.error('Error fetching items:', error)
      throw error
    }
  },
}

export function getApiService() {
  const env = import.meta.env.MODE ?? 'development'

  switch (env) {
    case 'development':
      return apiServiceDev
    case 'production':
      return apiServiceProd
    default:
      throw new Error(`Unknown environment: ${env}`)
  }
}
