const { app, BrowserWindow, Menu, ipcMain, globalShortcut, dialog } = require("electron");
const http = require("http");
const fs = require('fs');
const path = require("node:path");
const mammoth = require('mammoth');
const { CoreService } = require("../core/services");

const preload = path.join(__dirname, "preload.js");
const indexHtml = path.join(__dirname, "../dist/index.html");
const helpHtml = path.join(__dirname, "../assets/docs/help.docx");



const core = new CoreService();
const createMenu = () => {
  const menuTemplate = [
    {
      label: '选项',
      submenu: [
        {
          label: '清理本地证书',
          click: () => {
            // 打开文件的逻辑
            console.log('删除文件');
            core.clearCerts();
          },
        },
      ],
    },
    {
      label: '帮助',
      submenu: [
        {
          label: '常见问题',
          click: () => {
            openDocWindow(helpHtml)
          },
        },
      ],
    },
  ];

  const menu = Menu.buildFromTemplate(menuTemplate);
  Menu.setApplicationMenu(menu);
};


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
  createMenu()
  core.registerIpc(win);

  win.loadURL(process.env.VITE_DEV_SERVER_URL || `file://${indexHtml}`);

  globalShortcut.register("F12", () => {
    // 打开开发者工具
    win.webContents.openDevTools();
  });
  // win.webContents.openDevTools();
  return win
}


let root = undefined
app.whenReady().then(() => {
  root = createWindow();
  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      root = createWindow();
    }
  });
});

app.on("window-all-closed", () => {
  server.closeAllConnections();
  server.close();
  app.quit();
});

ipcMain.handle('open-docx', async () => {
  const result = await dialog.showOpenDialog({
    filters: [{ name: 'Word Documents', extensions: ['docx'] }],
    properties: ['openFile'],
  });

  if (result.canceled) return null;

  const filePath = result.filePaths[0];
  const fileContent = fs.readFileSync(filePath);

  const { value: html } = await mammoth.convertToHtml({ buffer: fileContent });
  return html;
});


async function openDocWindow(filePath) {
  const fileContent = fs.readFileSync(filePath);
  const { value: html } = await mammoth.convertToHtml({ buffer: fileContent });
  const docxWindow = new BrowserWindow({
    parent: root,
    width: 800,
    height: 600,
    title: '常见问题',
    webPreferences: {
      contextIsolation: true,
      enableRemoteModule: false,
      nodeIntegration: false,
    },
  });
  docxWindow.removeMenu();
  const zoomedHTML = `
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DOCX Viewer</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        transform: scale(1); /* 默认缩放比例 */
        transform-origin: top left;
        transition: transform 0.3s ease;
      }
      #zoom-controls {
        position: fixed;
        top: 10px;
        right: 10px;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
      }
      #zoom-controls button {
        margin: 0 5px;
        padding: 5px;
        background: #fff;
        color: #000;
        border: none;
        border-radius: 3px;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <div id="zoom-controls">
      <button onclick="zoomIn()">Zoom In</button>
      <button onclick="zoomOut()">Zoom Out</button>
      <button onclick="resetZoom()">Reset</button>
    </div>
    <div id="content">${html}</div>
    <script>
      let scale = 1;

      function zoomIn() {
        scale += 0.1;
        document.body.style.transform = \`scale(\${scale})\`;
      }

      function zoomOut() {
        scale = Math.max(0.1, scale - 0.1);
        document.body.style.transform = \`scale(\${scale})\`;
      }

      function resetZoom() {
        scale = 1;
        document.body.style.transform = 'scale(1)';
      }
    </script>
  </body>
  </html>
`;
  docxWindow.loadURL(`data:text/html;charset=utf-8,${encodeURIComponent(zoomedHTML)}`);
}

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
      res.end("登录成功，请返回");
      core.closeLoginEco();
    });
  } else {
    res.end("hello word\n");
  }
});
let port = 0
server.listen(0, () => {
  port = server.address().port
  core.port = port
  console.log("服务器运行在 http://localhost:" + port);
});