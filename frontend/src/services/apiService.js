import axios from 'axios'
import { STATES } from '../constants'

export const apiServiceDev = {
  async getOrders() {
    return [
      { state: STATES.READY, user_id: 'user1' },
      { state: STATES.ACCEPTED, user_id: 'user2' },
      { state: STATES.READY, user_id: 'user3' },
      { state: STATES.PENDING, user_id: 'user4' },
    ]
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
