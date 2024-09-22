export default [
  {
    path: "/home-page",
    name: "HomePage",
    meta: {
      ignore: false,
      title: "首页概览",
      code: "home-page",
      icon: "icon-menu-home",
    },
    component: () => import("../../pages/home/index.vue"),
  },
];
