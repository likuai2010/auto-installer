const { AgcService } = require("./agcService");
const { DownloadHelper } = require("./downloadHelper");

class EnvStep {
  name;
  finish = false;
  error;
  progress = "";
}

class EnvInfo {
  steps = [];
}
class AccountStep {
  name;
  value = "";
  finish = false;
  error;
}

class AccountInfo {
  steps = [];
}

class buildStep {
  name;
  value;
  finish = false;
  error;
}

class buildInfo {
  steps = [];
}
const { BrowserWindow, ipcMain } = require("electron");

class CoreService {
  dh = new DownloadHelper();
  agc = new AgcService();
  envInfo = {
    steps: [
      { name: "安装docker", finish: false, progress: 10 },
      { name: "命令行工具", finish: false, progress: 20 },
    ],
  };

  accountInfo = {
    steps: [
      { name: "登陆华为账号", finish: false, value: "" },
      { name: "ClientID", finish: false, value: "" },
      { name: "ClientKey", finish: false, value: "" },
      { name: "创建应用", finish: false, value: "" },
    ],
  };
  buildInfo = {
    steps: [
      { name: "构建应用", finish: false, value: "" },
      { name: "上传应用", finish: false, value: "" },
      { name: "发布版本", finish: false, value: "" },
      { name: "版本审核", finish: false, value: "" },
    ],
  };

  getEnvInfo() {
    return this.envInfo;
  }
  getAccountInfo() {
    return this.accountInfo;
  }
  getBuildInfo() {
    return this.buildInfo;
  }
  registerIpc(main) {
    ipcMain.on("download-file", (_, fileUrl) => {
      this.dh.downloadAndInstallFile(main, fileUrl);
    });
    ipcMain.on("open-window", (_, fileUrl) => {
      this.createChildWindiow(fileUrl);
      let cookieObj = this.dh.readFileTo("hw_cookies.json");
      const cookie = cookieObj.reduce((n, c) => {
        return (n += c.name + "=" + c.value + ";");
      }, "");
      this.agc.get(cookie);
    });
    ipcMain.on("getEnvInfo", (_) => {
      let info = this.getEnvInfo();
      main.webContents.send("onEnvInfo", info);
    });
    ipcMain.on("getAccountInfo", (_) => {
      let info = this.getAccountInfo();
      main.webContents.send("onAccountInfo", info);
    });
    ipcMain.on("getBuildInfo", (_) => {
      let info = this.getBuildInfo();
      main.webContents.send("onBuildInfo", info);
    });
  }
  childWindow = {};
  huaweiCoockes = {};
  createChildWindiow(
    url = "https://developer.huawei.com/consumer/cn/service/josp/agc/index.html#/"
  ) {
    const childWindow = new BrowserWindow({
      width: 800,
      height: 600,
      webPreferences: {
        nodeIntegration: true, // 启用 Node.js API
        contextIsolation: false, // 取消上下文隔离
      },
    });
    childWindow.loadURL(url);
    childWindow.webContents.on("did-finish-load", async () => {
      const cookies = await childWindow.webContents.session.cookies.get({
        url: "https://developer.huawei.com",
      });
      this.huaweiCoockes = cookies;
      // this.dh.writeObjToFile("hw_cookies.json", cookies)
    });
    childWindow.webContents.on("will-navigate", async () => {});
  }
}

module.exports = { CoreService };
