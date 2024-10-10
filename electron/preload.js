const { contextBridge, ipcRenderer } = require("electron");
const { console } = require("inspector");

// api桥
contextBridge.exposeInMainWorld("CoreApi", {
  getEnvInfo: () => {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onEnvInfo", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("getEnvInfo");
    });
  },
 
  uploadHap:(file)=>{
    console.log("uploadHap", file)
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onUploadHap", (event, data) => {
        resolve(data);
      });
      fileToBuffer(file.raw).then((buffer)=>{
        ipcRenderer.send("uploadHap", buffer, file.name);
      })
    });
  },
  getAccountInfo: () => {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onAccountInfo", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("getAccountInfo");
    });
  },
  getBuildInfo: (type) => {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onBuildInfo", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("getBuildInfo");
    });
  },
  onLoginFinish(callback){
  },

  githubBranchs(url){
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onGithubBranchs", (event, data) => {
        resolve(data);
      });
      ipcRenderer.on("onFailGithubBranchs", (event, data) => {
        reject(data);
      });
      ipcRenderer.send("githubBranchs",url);
    });
  },
  async checkAccountInfo(commonInfo) {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onCheckAccount", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("checkAccount", commonInfo);
    });
  },
  async startBuild(commonInfo) {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onStartBuild", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("startBuild", commonInfo);
    });
  },
  async downloadAndInstaller(url, onProgress) {
    downloadFile(url, onProgress);
  },
  toLogin: (text) => {
    //downloadDocker()
    ipcRenderer.send(
      "open-window",
      "https://developer.huawei.com/consumer/cn/service/josp/agc/index.html#/"
    );
  },
});
function fileToBuffer(file){
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
   
    reader.onload = () => {
      let buffer = Buffer.from(reader.result);
      resolve(buffer);
    }
    reader.onerror = () => reject(reader.error);
    reader.readAsArrayBuffer(file);
  });
}
function downloadFile(fileUrl, onProgress) {
  ipcRenderer.on("download-progress", (event, progress) => {
    if (onProgress) onProgress(progress);
  });
  console.log("downloadFile", fileUrl);
  ipcRenderer.send("download-file", fileUrl);
}
function downloadDocker() {
  let win =
    "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module&_gl=1*13dn9it*_gcl_au*Mzg3MDk4ODc5LjE3MjcxNTUwNzM.*_ga*MTI1ODE3OTcxNi4xNzIzNDQwMDY0*_ga_XJWPQMJYHQ*MTcyNzE1NTA3My4yLjEuMTcyNzE1NTA3OS41NC4wLjA.";
  let mac =
    "https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module&_gl=1*1jvi2eo*_gcl_au*Mzg3MDk4ODc5LjE3MjcxNTUwNzM.*_ga*MTI1ODE3OTcxNi4xNzIzNDQwMDY0*_ga_XJWPQMJYHQ*MTcyNzE1NTA3My4yLjEuMTcyNzE1NTA3OS41NC4wLjA.";
  downloadFile(process.platform !== "darwin" ? win : mac, (p) => {
    console.log("progress", p);
  });
}
