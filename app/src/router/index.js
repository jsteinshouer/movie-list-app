
import { createRouter, createWebHistory } from 'vue-router'
import axios from "axios";
import store from '../store.js';
import Login from '../views/Login.vue'
import Signup from '../views/Signup.vue'
import SignupConfirmation from '../views/SignupConfirmation.vue'
import Home from '../views/Home.vue'
import Search from '../views/Search.vue'
import MyMovies from '../views/MyMovies.vue'
import Movie from '../views/Movie.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { requiredAuth: true }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { requiredAuth: false }
  },
  {
    path: '/signup',
    name: 'Signup',
    component: Signup,
    meta: { requiredAuth: false }
  },
  {
    path: '/signup/confirm',
    name: 'SignupConfirmation',
    component: SignupConfirmation,
    meta: { requiredAuth: false }
  },
  {
    path: '/search',
    name: 'Search',
    component: Search,
    meta: { requiredAuth: true }
  },
  {
    path: '/mymovies',
    name: 'MyMovies',
    component: MyMovies,
    meta: { requiredAuth: true }
  },
  {
    path: '/view/:imdbID',
    name: 'ViewMovie',
    component: Movie,
    meta: { requiredAuth: true }
  }
]

const router = createRouter({
	// 4. Provide the history implementation to use. We are using the hash history for simplicity here.
	history: createWebHistory(),
	routes, // short for `routes: routes`
})

router.beforeEach(async (to, from, next) => {
  if (to.meta.requiredAuth) {
    var isLoggedIn = store.isLoggedIn;
    if (!isLoggedIn) {
      // Check with server to be sure
      axios.get( "/api/whoami" )
        .then((response) => {
          if ( response.status == 200 ) {
            store.isLoggedIn = true;
						return next();
          }
          else {
            return next({ path: "/login" });
          }
        })
        .catch( () => {
					return next({ path: "/login" });
				});
    } else {
      return next();
    }
  }
  return next();
});

export default router
