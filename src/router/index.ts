import { createRouter, createWebHistory } from 'vue-router'
import LandingPageView from "@/views/LandingPageView.vue";
import RegistrationView from "@/views/RegistrationView.vue";


const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: LandingPageView
        }, {
            path: '/register',
            name: 'register',
            component: RegistrationView
        }
    ]
})


export default router
