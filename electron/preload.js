const { contextBridge, ipcRenderer } = require('electron')
// const { CoreService } =  require('../core/services')

// var core = CoreService()

// api桥
contextBridge.exposeInMainWorld('CoreApi', {
  getEnvInfo: ()=>{
    //return core.getEnvInfo()
  },
  getAccountInfo: ()=>{
    //return core.getAccountInfo()
  },
  getBuildInfo: ()=>{
    //return core.getAccountInfo()
  },
  downloadFile(fileUrl, onProgress){
    ipcRenderer.on('download-progress', (event, progress) => {
      if (onProgress)
        onProgress(progress)
    })
    ipcRenderer.send('download-file', fileUrl);
  },
  toLogin: (text)=>{
    ipcRenderer.send('open-window', "https://developer.huawei.com/consumer/cn/service/josp/agc/index.html#/");
  }
})





