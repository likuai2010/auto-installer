import App from "./App.vue";
import store from "./store";
import router from "./router";
import CONFIG from "./config";
import mixins from "@/mixins";
import { createApp } from "vue";
import ElementPlus from "element-plus";
import locale from "element-plus/dist/locale/zh-cn";
import "element-plus/theme-chalk/index.css";

import "./assets/styles/index.css";
import "./assets/iconfont/iconfont.js";
import "./assets/iconfont/iconfont.css";
const app = createApp(App);

document.title = CONFIG.title;
app
  .mixin(mixins)
  .use(store)
  .use(router)
  .use(ElementPlus, { locale })
  .mount("#app");
