"use strict";

import axios from "axios";
import router from '../router';
import store from '../store';

// Full config:  https://github.com/axios/axios#request-config
// axios.defaults.baseURL = process.env.baseURL || process.env.apiUrl || '';
// axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
// axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

let config = {
  // baseURL: process.env.baseURL || process.env.apiUrl || ""
  // timeout: 60 * 1000, // Timeout
  // withCredentials: true, // Check cross-site Access-Control
};

const _axios = axios.create(config);

_axios.interceptors.request.use(
  function(config) {
    // Do something before request is sent
    return config;
  },
  function(error) {
    // Do something with request error
    return Promise.reject(error);
  }
);

// Add a response interceptor
_axios.interceptors.response.use(
  function(response) {
    // Do something with response data
    return response;
  },
  function(error) {
    // Do something with response error
    console.log( error.request );
    if ( error.request.url != '/api/whoami' && error.request.url != '/api/authorize' && error.response.status === 401 ) {
      store.isLoggedIn = false;
      router.push( "/login" ).catch(err => { console.log(err) });
    }
    return Promise.reject(error);
  }
);

let install = function(app) {
  app.config.globalProperties.axios = _axios;
};

export default { install };
