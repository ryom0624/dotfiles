import Vue from "vue";
import App from "./App.vue";
import VueHead from "vue-head";

import router from "./router";
import store from "./store";

Vue.config.productionTip = false;

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
