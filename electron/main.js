const { app, BrowserWindow, Menu, session  } = require('electron')
const path = require('node:path')


const preload = path.join(__dirname, 'preload.js')
const indexHtml = path.join(__dirname, '../dist/index.html')

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload,
      nodeIntegration: true, // 如果需要 Node.js API
      contextIsolation: true,
    }
  })
  Menu.setApplicationMenu(null)

  win.loadURL(process.env.VITE_DEV_SERVER_URL || `file://${indexHtml}`);
  win.webContents.openDevTools();

  const childWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true, // 启用 Node.js API
      contextIsolation: false, // 取消上下文隔离
    },
  });

  childWindow.loadURL('https://developer.huawei.com/consumer/cn/service/josp/agc/index.html#/');
  childWindow.webContents.on('did-finish-load', async () => {
    const cookies = await childWindow.webContents.session.cookies.get({ url: 'https://developer.huawei.com' });
    
    cookies.forEach(cookie => {
      console.log(`Name: ${cookie.name}, Value: ${cookie.value}`);
    });
  });
  childWindow.webContents.openDevTools();

  win.webContents.setWindowOpenHandler(({ url }) => {
    session.get
    return { action: 'deny' }
  })
}



app.whenReady().then(() => {
  createWindow()

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow()
    }
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})