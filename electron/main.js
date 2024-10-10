const { app, BrowserWindow, Menu, globalShortcut } = require("electron");
const http = require("http");

const path = require("node:path");
const { CoreService } = require("../core/services");
const core = new CoreService();
const preload = path.join(__dirname, "preload.js");
const indexHtml = path.join(__dirname, "../dist/index.html");

function createWindow() {
  const win = new BrowserWindow({
    width: 1000,
    height: 600,
    webPreferences: {
      preload,
      nodeIntegration: true, // 如果需要 Node.js API
      contextIsolation: true,
    },
  });

  core.registerIpc(win);
  Menu.setApplicationMenu(null);

  win.loadURL(process.env.VITE_DEV_SERVER_URL || `file://${indexHtml}`);

  globalShortcut.register("F12", () => {
    // 打开开发者工具
    win.webContents.openDevTools();
  });
  win.webContents.openDevTools();
}

app.whenReady().then(() => {
  createWindow();

  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on("window-all-closed", () => {
  server.closeAllConnections();
  server.close();
  app.quit();
});
const server = http.createServer((req, res) => {
  console.debug("request", req.method, req.url, req.params);
  if (req.url == "/callback" && req.method == "POST") {
    let body = "";
    req.on("data", (chunk) => {
      body += chunk.toString(); // 将Buffer转换为字符串并拼接
    });
    req.on("end", async () => {
      console.log(body); // 打印POST请求的数据
      let uesrInfo = await core.eco.getTokenBytempToken(body);
      core.dh.writeObjToFile("ds-authInfo.json", uesrInfo);
      await core.eco.initCookie(uesrInfo);
      core.build.checkEcoAccount(core.commonInfo);
      res.statusCode = 200;
      res.setHeader("Content-Type", "text/plain");
      res.end("login success\n" + body);
      core.closeLoginEco();
    });
  } else {
    res.end("hello word\n");
  }
});

server.listen(3333, () => {
  console.log("服务器运行在 http://localhost:3333/");
});
