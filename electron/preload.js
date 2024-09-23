const { contextBridge } = require('electron')

// api桥
contextBridge.exposeInMainWorld('Api', {
  toLogin: (text)=>{
      console.log("xxxxx")
     
  }
})



window.addEventListener('DOMContentLoaded', () => {
    const replaceText = (selector, text) => {
      const element = document.getElementById(selector)
      if (element) element.innerText = text
    }
  
    for (const type of ['chrome', 'node', 'electron']) {
      replaceText(`${type}-version`, process.versions[type])
    }
  })



