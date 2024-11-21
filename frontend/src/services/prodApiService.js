import axios from 'axios'
import { STATES } from '../constants'

const PROD_URL = import.meta.env.VITE_APP_API_URL || 'http://localhost:4567'

const axiosClient = axios.create({
  withCredentials: true,
})

async function getCollection(url) {
  try {
    const response = await axiosClient.get(url)
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
    address: store.address,
    hours: store.hours,
    coordinates: [store.lat, store.lng],
    logo: store.logo,
  }

  return backendStore
}

function adaptStoreToFrontend(store) {
  const frontendStore = {
    id: store.id,
    name: store.name,
    address: store.address,
    contact: store.contact,
    hours: store.hours,
    lat: store.coordinates[0],
    lng: store.coordinates[1],
    logo: store.logo,
  }

  return frontendStore
}

function adaptOrderToBackend(order) {
  const backendOrder = {
    amountByItem: order.selectedItems,
    userCoordinates: [order.userLocation.lat, order.userLocation.lng],
    takeaway: order.takeaway,
  }

  return backendOrder
}

function adaptOrderToFrontend(order) {
  const getStateValue = order => STATES[order.state]

  const frontendOrder = {
    tableId: order.tableId,
    selectedItems: order.amountByItem,
    state: getStateValue(order),
    takeaway: order.toTakeAway,
  }

  return frontendOrder
}

async function modifyOrderStatus(url) {
  try {
    const response = await axiosClient.put(url)
    return response.data
  } catch (error) {
    console.error('Error updating order:', error)
    throw error
  }
}

async function deleteResource(url) {
  try {
    const response = await axiosClient.delete(url)

    return response.data
  } catch (error) {
    console.error(
      'Error deleting resource:',
      error.response?.data || error.message,
    )
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
    const orders = await getCollection(`${PROD_URL}/stores/${storeId}/orders`)
    const adaptedOrders = orders.map(adaptOrderToFrontend)
    return adaptedOrders
  },

  async getMenu(storeId) {
    return getCollection(`${PROD_URL}/stores/${storeId}/menu`)
  },

  async addStore(store) {
    const url = `${PROD_URL}/stores`

    const storeObject = adaptStoreToBackend(store)

    try {
      const response = await axiosClient.post(url, storeObject, {
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
      const response = await axiosClient.post(url, itemObject, {
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
    await deleteResource(`${PROD_URL}/stores/${storeId}/menu/${itemId}`)
  },

  async createOrder(storeId, order) {
    const orderObject = adaptOrderToBackend(order)

    try {
      const response = await axiosClient.post(
        `${PROD_URL}/stores/${storeId}/orders`,
        orderObject,
        {
          headers: {
            'Content-Type': 'application/json',
          },
        },
      )

      return response.data
    } catch (error) {
      console.error(
        'Error creating order:',
        error.response?.data || error.message,
      )
      throw error
    }
  },

  async getOrderById(storeId, tableId) {
    const url = `${PROD_URL}/stores/${storeId}/orders/${tableId}`

    try {
      const response = await axiosClient.get(url)
      console.log(response.data)
      adaptOrderToFrontend(response.data)
      return response.data
    } catch (error) {
      console.error('Error while fetching order:', error)
      throw error
    }
  },

  async markOrderAsReady(storeId, tableId) {
    await modifyOrderStatus(
      `${PROD_URL}/stores/${storeId}/orders/${tableId}/ready`,
    )
  },

  async acceptOrder(storeId, tableId) {
    await modifyOrderStatus(
      `${PROD_URL}/stores/${storeId}/orders/${tableId}/accept`,
    )
  },

  async rejectOrder(storeId, tableId) {
    await modifyOrderStatus(
      `${PROD_URL}/stores/${storeId}/orders/${tableId}/reject`,
    )
  },

  async deleteOrder(storeId, tableId) {
    await deleteResource(`${PROD_URL}/stores/${storeId}/orders/${tableId}`)
  },
}
