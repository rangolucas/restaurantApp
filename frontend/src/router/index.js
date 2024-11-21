import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import StoresView from '@/views/StoresView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/stores',
      name: 'stores',
      component: StoresView,
    },
    {
      path: '/stores/:id',
      name: 'store-details',
      component: () => import('../views/StoreView.vue'),
    },
    {
      path: '/registerStore',
      name: 'store-register',
      component: () => import('../views/RegisterStoreView.vue'),
    },
    {
      path: '/user',
      name: 'user',
      component: () => import('../views/UserView.vue'),
    },
    {
      path: '/user/:storeId',
      name: 'user-check-in',
      component: () => import('../views/CheckInView.vue'),
    },
  ],
})

export default router
