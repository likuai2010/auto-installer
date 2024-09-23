const { contextBridge } = require('electron')
import { CoreService } from '../core/services'

var core = CoreService()

// api桥
contextBridge.exposeInMainWorld('Api', {
  toLogin: (text)=>{
      console.log("xxxxx")
  }
})



// api桥
contextBridge.exposeInMainWorld('CoreApi', {
  getEnvInfo: ()=>{
    return core.getEnvInfo()
  },
  getAccountInfo: ()=>{
    return core.getAccountInfo()
  },
  getBuildInfo: ()=>{
    return core.getAccountInfo()
  }
})





