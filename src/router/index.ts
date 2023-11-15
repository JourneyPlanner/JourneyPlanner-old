<<<<<<< HEAD
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
=======
import {createRouter, createWebHistory} from 'vue-router'
import HomeView from '../views/HomeView.vue'
import RegistrationView from "../views/RegistrationView.vue";

const router = createRouter({
>>>>>>> 1722ddf428d110310f0aa173f8ea68ce3cc6df6b
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
<<<<<<< HEAD
>>>>>>> 1722ddf (added Registration Site)
=======
>>>>>>> 1722ddf428d110310f0aa173f8ea68ce3cc6df6b
})

export default router
