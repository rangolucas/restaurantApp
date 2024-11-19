import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

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
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/StoresView.vue'),
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
