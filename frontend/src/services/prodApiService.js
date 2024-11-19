import axios from 'axios'

const PROD_URL = 'http://localhost:4567'

async function getCollection(url) {
  try {
    const response = await axios.get(url)
    return response.data
  } catch (error) {
    console.error('Error while fetching:', error)
    throw error
  }
}

function adaptStoreToBackend(store) {
  const backendStore = {
    name: store.name,
    contact: store.contact,
    hours: store.hours,
    coordinates: [store.lat, store.lng],
  }

  return backendStore
}

function adaptStoreToFrontend(store) {
  const frontendStore = {
    id: store.id,
    name: store.name,
    contact: store.contact,
    hours: store.hours,
    lat: store.coordinates[0],
    lng: store.coordinates[1],
  }

  return frontendStore
}

async function modifyOrderStatus(url) {
  try {
    const response = await axios.put(url)
    return response.data
  } catch (error) {
    console.error('Error updating order:', error)
    throw error
  }
}

export const prodApiService = {
  async checkIn(storeId) {
    const response = await getCollection(
      `${PROD_URL}/stores/${storeId}/check-in`,
    )
    return response.type == 'menu'
      ? [null, response.value]
      : [response.value, null]
  },

  async getStores() {
    const stores = await getCollection(`${PROD_URL}/stores`)
    const adaptedStores = stores.map(adaptStoreToFrontend)
    return adaptedStores
  },

  async getOrders(storeId) {
    return getCollection(`${PROD_URL}/stores/${storeId}/orders`)
  },

  async getMenu(storeId) {
    return getCollection(`${PROD_URL}/stores/${storeId}/menu`)
  },

  async addStore(store) {
    const url = `${PROD_URL}/stores`

    const storeObject = adaptStoreToBackend(store)

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

  async createOrder(userLocation, storeId, order, takeaway) {
    const payload = {
      amountByItem: order,
      userCoordinates: [userLocation.lat, userLocation.lng],
      takeaway: takeaway,
    }
    await axios.post(`${PROD_URL}/stores/${storeId}/orders`, payload, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
  },

  async getOrderById(storeId, tableId) {
    const url = `${PROD_URL}/stores/${storeId}/orders/${tableId}`

    try {
      const response = await axios.get(url)
      return response.data
    } catch (error) {
      console.error('Error while fetching order:', error)
      throw error
    }
  },

  async markOrderAsReady(storeId, tableId) {
    modifyOrderStatus(`${PROD_URL}/stores/${storeId}/orders/${tableId}/ready`)
  },

  async acceptOrder(storeId, tableId) {
    modifyOrderStatus(`${PROD_URL}/stores/${storeId}/orders/${tableId}/accept`)
  },

  async deleteOrder(storeId, tableId) {
    const url = `${PROD_URL}/stores/${storeId}/orders/${tableId}`

    try {
      const response = await axios.delete(url)
      return response.data
    } catch (error) {
      console.error('Error deleting order:', error)
      throw error
    }
  },
}
