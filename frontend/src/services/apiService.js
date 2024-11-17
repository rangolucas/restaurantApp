import axios from 'axios'
import { STATES } from '../constants'

const ordersDB = [
  { orderId: '1', state: STATES.READY, tableId: 'table1' },
  { orderId: '2', state: STATES.ACCEPTED, tableId: 'table2' },
  { orderId: '3', state: STATES.READY, tableId: 'table3' },
  { orderId: '4', state: STATES.PENDING, tableId: 'table4' },
]

const menuDB = [
  { itemId: '1', itemName: 'name1', itemPrice: 'price1' },
  { itemId: '2', itemName: 'name2', itemPrice: 'price2' },
  { itemId: '3', itemName: 'name3', itemPrice: 'price3' },
  { itemId: '4', itemName: 'name4', itemPrice: 'price4' },
]

const storesDB = [
  {
    id: 'store1',
    name: 'Guerrin',
    contact: 'store1@test.com',
    lat: -34.58477,
    long: -58.442846,
    address: 'Calle 124',
  },
  {
    id: 'store2',
    name: 'Cuervo',
    contact: 'store2@test.com',
    lat: -34.588254,
    long: -58.434529,
    address: 'Avenida Corrientes 742',
  },
  {
    id: 'store3',
    name: 'Panchitos',
    contact: 'store3@test.com',
    lat: -34.62746,
    long: -58.434038,
    address: 'Calle 456',
  },
  {
    id: 'store4',
    name: 'Paellaza',
    contact: 'store4@test.com',
    lat: -34.569148,
    long: -58.43393,
    address: 'Avenida 9 de Julio 3243',
  },
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
    const newOrder = {
      orderId: 'testId',
      state: STATES.PENDING,
      tableId: 'testTable',
    }
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

  async addItemToMenu(storeId, item) {
    menuDB.push({
      itemId: 'testId',
      itemName: item.name,
      itemPrice: item.price,
    })
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
    storesDB.push({
      id: 'testId',
      name: store.name,
      address: store.address,
      contact: store.contact,
      hours: store.hours,
      lat: store.lat,
      long: store.long,
      logo: store.logo,
    })
  },
}

const PROD_URL = 'http://localhost:4567'

export const apiServiceProd = {
  async getCollection(url) {
    try {
      const response = await axios.get(url)
      return response.data
    } catch (error) {
      console.error('Error while fetching:', error)
      throw error
    }
  },

  async getStores() {
    return this.getCollection(`${PROD_URL}/stores`)
  },

  async getOrders(storeId) {
    return this.getCollection(`${PROD_URL}/stores/${storeId}/orders`)
  },

  async getMenu(storeId) {
    return this.getCollection(`${PROD_URL}/stores/${storeId}/menu`)
  },

  async addStore(store) {
    const url = `${PROD_URL}/stores`

    const storeObject = {
      name: store.name,
      contactInfo: store.contact,
      timeTable: store.hours,
      coordinates: [store.lat, store.long],
    }

    try {
      const response = await axios.post(url, storeObject, {
        headers: {
          'Content-Type': 'application/json',
        },
      })

      return response.data
    } catch (error) {
      console.error(
        'Error adding store:',
        error.response?.data || error.message,
      )
      throw error
    }
  },

  async addItemToMenu(storeId, item) {
    const url = `${PROD_URL}/stores/${storeId}/menu`

    const itemObject = {
      itemName: item.name,
      price: item.price,
    }

    try {
      const response = await axios.post(url, itemObject, {
        headers: {
          'Content-Type': 'application/json',
        },
      })

      return response.data
    } catch (error) {
      console.error(
        'Error adding item to menu:',
        error.response?.data || error.message,
      )
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
