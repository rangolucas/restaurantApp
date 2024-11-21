import { createRouter, createWebHashHistory } from 'vue-router'
import CheckInView from '@/views/CheckInView.vue'
import HomeView from '@/views/HomeView.vue'
import RegisterStoreView from '@/views/RegisterStoreView.vue'
import StoresView from '@/views/StoresView.vue'
import StoreView from '@/views/StoreView.vue'
import UserView from '@/views/UserView.vue'

const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
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
      component: StoreView,
    },
    {
      path: '/registerStore',
      name: 'store-register',
      component: RegisterStoreView,
    },
    {
      path: '/user',
      name: 'user',
      component: UserView,
    },
    {
      path: '/user/:storeId',
      name: 'user-check-in',
      component: CheckInView,
    },
  ],
})

export default router
