import homePage from "./modules/home";
import Layout from "@/components/layout/Layout.vue";
import { createRouter, createWebHashHistory } from "vue-router";

const asyncRoutes = [
  {
    path: "/",
    meta: {
      ignore: true,
    },
    redirect: "/layout",
  },
  {
    path: "/layout",
    name: "layout",
    meta: {
      ignore: true,
    },
    component: Layout,
    redirect: "/home-page",
    children: [...homePage],
  },
];

const defaultRoutes = [
  {
    path: "/:pathMatch(.*)",
    redirect: "/404",
    meta: {
      ignore: true,
    },
  },
  {
    path: "/404",
    name: "404",
    meta: {
      title: "找不到页面",
      ignore: true,
    },
    component: () => import("@/components/layout/404.vue"),
  },
  {
    path: "/403",
    name: "403",
    meta: {
      title: "没有权限",
      ignore: true,
    },
    component: () => import("@/components/layout/403.vue"),
  },
];

const router = createRouter({
  strict: true,
  history: createWebHashHistory(),
  routes: [...asyncRoutes, ...defaultRoutes],
  scrollBehavior: () => ({ left: 0, top: 0 }),
});

export default router;
