const {
  app,
  BrowserWindow,
  Menu,
  session,
  globalShortcut,
} = require("electron");
const http = require('http');

const path = require("node:path");
const { CoreService } = require("../core/services");

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
  const core = new CoreService();
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
  server.closeAllConnections()
  server.close()
  if (process.platform !== "darwin") {
    app.quit();
  }

});
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
});
 
server.listen(33333, () => {
  console.log('服务器运行在 http://localhost:33333/');
});