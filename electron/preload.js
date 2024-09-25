const { contextBridge, ipcRenderer } = require("electron");

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
  getAccountInfo: () => {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onAccountInfo", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("getAccountInfo");
    });
  },
  getBuildInfo: () => {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onBuildInfo", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send("getBuildInfo");
    });
  },
  async checkAccountInfo(commonInfo) {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("onCheckAccount", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send(
        "checkAccount",commonInfo
      );
    });
  },
  async startBuild(commonInfo) {
    return new Promise((resolve, reject) => {
      ipcRenderer.on("startBuild", (event, data) => {
        resolve(data);
      });
      ipcRenderer.send(
        "startBuild",
        buildInfo
      );
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
