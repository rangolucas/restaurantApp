import axios from 'axios'
import { STATES } from '../constants'

export const apiServiceDev = {
  async getOrders() {
    setTimeout(function () {}, 2000)
    return [
      { orderId: '1', state: STATES.READY, userId: 'user1' },
      { orderId: '2', state: STATES.ACCEPTED, userId: 'user2' },
      { orderId: '3', state: STATES.READY, userId: 'user3' },
      { orderId: '4', state: STATES.PENDING, userId: 'user4' },
    ]
  },

  async markOrderAsReady(storeId, orderId) {
    // do nothing
  },

  async acceptOrder(storeId, orderId) {
    // do nothing
  },

  async deleteOrder(storeId, orderId) {
    // do nothing
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
