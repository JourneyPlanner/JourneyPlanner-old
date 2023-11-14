import { createRouter, createWebHistory } from 'vue-router';
import LandingPageView from "@/views/LandingPageView.vue";
import RegistrationView from "@/views/RegistrationView.vue";
import LoginView from "@/views/LoginView.vue";


const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: LandingPageView
        },
        {
            path: '/register',
            name: 'register',
            component: RegistrationView
        },
        {
            path: '/dashboard',
            name: 'dashboard',
            component: () => import('../views/UserDashboardView.vue')
        },
        {
            path: '/datenschutz',
            name: 'datenschutz',
            component: () => import('../views/DataProtectionView.vue')
        },
        {
            path: '/impressum',
            name: 'impressum',
            component: () => import('../views/ImprintView.vue')
        },
        {
            path: '/login',
            name: 'login',
            component: LoginView
        }
    ],
    scrollBehavior(to, form, savedPosition) {
        return { top: 0 }
    },
<<<<<<< HEAD
=======
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue')
    },
    {
      path: '/dashboard',
        name: 'dashboard',
        component: () => import('../views/UserDashboardView.vue')
    }
  ]
>>>>>>> 50f9d21 (wip: started dashboard)
})


export default router
