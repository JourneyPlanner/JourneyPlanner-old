<<<<<<< HEAD
import { createRouter, createWebHistory } from 'vue-router'
import LandingPageView from "@/views/LandingPageView.vue";


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: LandingPageView
    },


  ]
=======
import {createRouter, createWebHistory} from 'vue-router'
import HomeView from '../views/HomeView.vue'
import RegistrationView from "../views/RegistrationView.vue";

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: HomeView
        },
        {
            path: '/about',
            name: 'about',
            // route level code-splitting
            // this generates a separate chunk (About.[hash].js) for this route
            // which is lazy-loaded when the route is visited.
            component: () => import('../views/AboutView.vue')
        }, {
            path: '/registration',
            name: 'registration',
            component: RegistrationView
        }
    ]
>>>>>>> 1722ddf (added Registration Site)
})

export default router
