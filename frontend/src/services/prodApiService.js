import axios from 'axios'

const PROD_URL = 'http://localhost:4567'

export const prodApiService = {
  async getCollection(url) {
    try {
      const response = await axios.get(url)
      return response.data
    } catch (error) {
      console.error('Error while fetching:', error)
      throw error
    }
  },

  async checkIn(storeId) {
    const response = this.getCollection(
      `${PROD_URL}/stores/${storeId}/check-in`,
    )
    return response.type == 'menu'
      ? [null, response.value]
      : [response.value, null]
  },

  async getStores() {
    const stores = await this.getCollection(`${PROD_URL}/stores`)
    // Transform coordinates array to lat and lng
    return stores.map(store => {
      const { coordinates, ...rest } = store
      return {
        ...rest,
        lat: coordinates[0],
        lng: coordinates[1]
      }
    })
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
      coordinates: [store.lat, store.lng],
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

  async removeItemFromMenu(storeId, itemId) {
    // TODO
  },

  async createOrder(storeId, order) {
    // TODO
  },

  async getOrderById(storeId, orderId) {
    const url = `${PROD_URL}/stores/${storeId}/orders/${orderId}`

    try {
      const response = await axios.get(url)
      return response.data
    } catch (error) {
      console.error('Error while fetching order:', error)
      throw error
    }
  },

  async markOrderAsReady(storeId, orderId) {
    // TODO
  },

  async acceptOrder(storeId, orderId) {
    // TODO
  },

  async deleteOrder(storeId, orderId) {
    // TODO
  },
}
