import vue from "@vitejs/plugin-vue";
const path = require("path");
const packageConfig = require("./package.json");
const version = packageConfig.version;

export default {
  base: "",
  plugins: [vue()],
  resolve: {
    alias: {
      "@": path.join(__dirname, "./src"),
    },
  },
  server: {
    port: 5173, // Electron dev server 依赖此端口
  },
  define: {
    projectVersion: JSON.stringify(version),
  },
};
