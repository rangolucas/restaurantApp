import { STATES } from '../constants'

const ordersDB = [
  { orderId: '1', state: STATES.READY, tableId: 'table1' },
  { orderId: '2', state: STATES.ACCEPTED, tableId: 'table2' },
  { orderId: '3', state: STATES.READY, tableId: 'table3' },
  { orderId: '4', state: STATES.PENDING, tableId: 'table4' },
]

const menuDB = [
  { itemId: '1', itemName: 'Hamburguesa', price: '10.3' },
  { itemId: '2', itemName: 'Pizza con ananá', price: '5' },
  { itemId: '3', itemName: 'Flan', price: '888' },
  { itemId: '4', itemName: 'Suprema a la maryland', price: '1' },
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

export const devApiService = {
  ordered: false,

  async checkIn() {
    await this.simulateDelay(300)
    const result = [this.ordered ? ordersDB[0] : null, menuDB]
    this.ordered = true
    return result
  },

  async getOrders() {
    await this.simulateDelay(300)
    return ordersDB
  },

  async getOrderById(storeId, orderId) {
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
    await this.simulateDelay(300)
    return menuDB
  },

  async addItemToMenu(storeId, item) {
    menuDB.push({
      itemId: 'testId',
      itemName: item.name,
      price: item.price,
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
    await this.simulateDelay(500)
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

  async simulateDelay(millis) {
    await new Promise(resolve => setTimeout(resolve, millis))
  },
}
