import {createApp} from 'vue'
import {createPinia} from 'pinia'

import App from './App.vue'
import router from './router'

import PrimeVue from 'primevue/config';
import Button from "primevue/button"
import Dialog from "primevue/dialog";
import Tooltip from 'primevue/tooltip';
import ToastService from 'primevue/toastservice';
import ConfirmationService from 'primevue/confirmationservice';

import 'primevue/resources/themes/lara-light-green/theme.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(PrimeVue);
app.use(ToastService);
app.use(ConfirmationService);
app.component('Button', Button);
app.component('Dialog', Dialog);
app.directive('tooltip', Tooltip);

app.mount('#app')
