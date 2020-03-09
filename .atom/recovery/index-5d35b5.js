import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "home",
    component: Home
  },
  {
    path: "/about",
    name: "about",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue")
  },
  {
    path: "/news",
    name: "news",
    component: () => import("../views/News.vue")
  },
  {
    path: "/news/:id(\\d+)",
    name: "article",
    component: () => import("../views/Article.vue")
  },
  {
    path: "/contact",
    name: "contact",
    component: () => import("../views/Contact.vue")
  },
  {
    path: "/privacy",
    name: "privacy",
    component: () => import("../views/Privacy.vue")
  },
  {
    path: "/barth",
    name: "barth",
    component: () => import("../views/Barth.vue")
  },
  {
    path: "/sleepdays",
    name: "sleepdays",
    component: () => import("../views/Sleepdays.vue")
  },
  {
    path: "/admin/login",
    name: "login",
    component: () => import("../views/Login.vue")
  },
  {
    path: "/admin/mypage",
    name: "mypage",
    component: () => import("../views/User.vue")
    
  }
];

router.beforeEach((to, from, next) => {
  let currentUser = firebase.auth().currentUser
  let requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  if (requiresAuth && !currentUser) next('login')
  else if (!requiresAuth && currentUser) next()
  else next()
})

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,

  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { x: 0, y: 0 };
    }
  }
});

export default router;
