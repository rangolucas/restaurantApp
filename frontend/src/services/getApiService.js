import { devApiService } from './devApiService'
import { prodApiService } from './prodApiService'

export function getApiService() {
  const env = import.meta.env.VITE_RUN_MODE ?? 'development'

  switch (env) {
    case 'development':
      return devApiService
    case 'production':
      return prodApiService
    default:
      throw new Error(`Unknown environment: ${env}`)
  }
}
