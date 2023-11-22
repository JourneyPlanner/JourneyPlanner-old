import {createRouter, createWebHistory} from 'vue-router';
import LandingPageView from "@/views/LandingPageView.vue";
import RegistrationView from "@/views/RegistrationView.vue";
import LoginView from "@/views/LoginView.vue";

import {supabase} from "@/lib/supabaseClient.js";


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
            component: () => import('../views/UserDashboardView.vue'),
            meta: {requiresAuth: true}
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
        },
        /*
        {
            path: '/einstellungen',
            name: 'einstellungen',
            component: () => import('../views/SettingsView.vue')
        },
        {
            path: '/reise/neu',
            name: 'new-journey',
            //component: () => import('../views/NewJourneyFormView.vue')
        }
         */
    ],
    scrollBehavior(to, form, savedPosition) {
        return {top: 0}
    }
});

async function getUser(next: any) {
    let localUser = await supabase.auth.getSession();
    if (localUser.data.session == null) {
        next(await router.push("/login" + "?unauthorized=true"))
    } else {
        next();
    }
}


router.beforeEach((to, from, next) => {
    if (to.meta.requiresAuth) {
        getUser(next);
    } else {
        next();
    }
})

export default router
