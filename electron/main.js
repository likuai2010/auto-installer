const { app, BrowserWindow } = require('electron/main')
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
      contextIsolation: false,
    }
  })

  win.loadURL(process.env.VITE_DEV_SERVER_URL || `file://${indexHtml}`);
  win.webContents.openDevTools();
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