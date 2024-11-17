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
  { id: 'store1', name: 'Guerrin', contact: 'store1@test.com', lat: -34.584770, long: -58.442846, address: 'Calle 124' },
  { id: 'store2', name: 'Cuervo', contact: 'store2@test.com', lat: -34.588254, long: -58.434529, address: 'Avenida Corrientes 742' },
  { id: 'store3', name: 'Panchitos', contact: 'store3@test.com', lat: -34.573144, long: -58.456630, address: 'Calle 456' },
  { id: 'store4', name: 'Paellaza', contact: 'store4@test.com', lat: -34.569148, long: -58.433930, address: 'Avenida 9 de Julio 3243' }
]


export const apiServiceDev = {
  async getOrders() {
    await new Promise(resolve => setTimeout(resolve, 300))
    return ordersDB
  },

  async getOrderById(orderId) {
    const order = ordersDB.find(order => order.orderId === orderId)

    if (order) {
      return order
    } else {
      console.log('Order not found')
    }
  },

  async createOrder() {
    const newOrder = {orderId: 'testId', state: STATES.PENDING, userId: 'testUser'}
    ordersDB.push(newOrder)
    return newOrder
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

  async getMenu(storeId) {
    setTimeout(function () {}, 2000)
    return menuDB
  },

  async addItemToMenu(storeId, itemId) {
    menuDB.push({ itemId: 'testId', itemName: 'testName', itemPrice: 'testPrice' })
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
     storesDB.push({ id: 'testId',
                    name: store.name,
                    address: store.address,
                    contact: store.contact,
                    hours: store.hours,
                    lat: store.lat,
                    long: store.long })
  },
}

const PROD_URL = 'http://localhost:4567'

export const apiServiceProd = {
  async getStores() {
    this.getCollection(`${PROD_URL}/stores`)
  },

  async getOrders(storeId) {
    this.getCollection(`${PROD_URL}/${storeId}/orders`)
  },

  async getMenu(storeId) {
    this.getCollection(`${PROD_URL}/${storeId}/menu`)
  },

  async getCollection(url) {
    try {
      const response = await axios.get(url)
      return response.data
    } catch (error) {
      console.error('Error while fetching:', error)
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
