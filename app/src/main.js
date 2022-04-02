import { createApp } from 'vue'
import axios from '@/plugins/axios'
import App from '@/App.vue'
import router from '@/router'
import '@/assets/tailwind.css';

const app = createApp(App)
// Make sure to _use_ the router instance to make the
// whole app router-aware.
app.use(router)
app.use(axios)

app.mount('#app')