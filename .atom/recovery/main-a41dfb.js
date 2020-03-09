import Vue from "vue";
import App from "./App.vue";
import VueHead from "vue-head";

import router from "./router";
import store from "./store";

Vue.config.productionTip = false;

import firebase from 'firebase'

const firebaseConfig = {
  apiKey: "AIzaSyBo_jsnabAkiW2KR9szkP4yHLQ-cRgQBSA",
  authDomain: "backend-two2-development.firebaseapp.com",
  databaseURL: "https://backend-two2-development.firebaseio.com",
  projectId: "backend-two2-development",
  storageBucket: "backend-two2-development.appspot.com",
  messagingSenderId: "94229091586",
  appId: "1:94229091586:web:21b67ae659924bf3951e1b"
};
firebase.initializeApp(firebaseConfig);

// vue-head
Vue.use(VueHead);

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");

// Components
require("two-design-components/src/js/modules.js");

// v-scroll
Vue.directive("scroll", {
  inserted: function(el, binding) {
    let f = function(evt) {
      if (binding.value(evt, el)) {
        window.removeEventListener("scroll", f);
      }
    };
    window.addEventListener("scroll", f);
  }
});

mounted: function () {
  firebase.auth().onAuthStateChanged((user) => {
    this.isAuth = !!user
    this.user = user.displayName
  })
},



