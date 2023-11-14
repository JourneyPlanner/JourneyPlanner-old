import { createRouter, createWebHistory } from 'vue-router';
import LandingPageView from "@/views/LandingPageView.vue";


const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: LandingPageView
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
        }
    ]
})

export default router
