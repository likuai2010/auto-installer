const { AgcService } = require("./agcService");
const { DownloadHelper } = require("./downloadHelper");
const simpleGit = require("simple-git");

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

const git = simpleGit();
class CoreService {
    dh = new DownloadHelper()
    agc = new AgcService()
    commonInfo = {
        packageName:"com.xx.xx",
        appName:"app",
        github: "https://github.com/likuai2010/ClashMeta.git",
        branch: "master",
        downloadUrl:"https://xxx"
    }
    envInfo =  {
        steps: [
            { name:"安装docker", finish: false, url: '', error:"未安装" },
            { name:"安装命令行工具", finish: false, url: '', error:"未安装"}
        ],
    }
   
    accountInfo =  {
        steps: [
            { name: "登陆华为账号", finish: false, value:'17611576573', loading: false, error:"未登录" },
            { name: "ClientID", finish: false, value:'xxx', loading: false, error:"获取失败" },
            { name: "ClientKey", finish: false, value:'xxx', loading: false, error:"获取失败" },
            { name: "创建应用", finish: false, value:'com.xx.xx', loading: false, error:"创建失败" },
            { name: "创建证书", finish: false, value:'',loading: false, error:"创建失败"},
            { name: "创建Profile", finish: false, value:'', loading: false, error:"创建失败"},
        ],
    }
    buildInfo =  {
        steps: [
            { name: "拉取代码", finish: false, value:'', loading: false, error:"拉取失败" },
            { name: "构建应用", finish: false, value:'', loading: false, error:"构建失败" },
            { name: "签名应用", finish: false, value:'', loading: false, error:"签名失败"  },
            { name: "上传应用", finish: false, value:'', loading: false, error:"上传失败" },
            { name: "发布版本", finish: false, value:'', loading: false, error:"发布版本失败" },
            { name: "版本审核", finish: false, value:'', loading: false, error:"审核失败"  },
        ],
        install: [
            { name: "拉取代码", finish: false, value:'', loading: false, error:"拉取失败" },
            { name: "构建应用", finish: false, value:'', loading: false, error:"构建引用失败"},
            { name: "签名应用", finish: false, value:'', loading: false, error:"签名失败" },
            { name: "连接设备", finish: false, value:'', loading: false, error:'请连接手机，并开启开发者模式'},
            { name: "安装应用", finish: false, value:'', loading: false, error:"安装失败" },
        ],
        type: 0, // 0 分发，1 本地安装 
    }
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
      // this.cloneGit("https://github.com/likuai2010/ClashMeta.git")
      this.repoBrank("https://github.com/likuai2010/ClashMeta.git");
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
  async repoBrank(repoUrl) {
    git.raw(["ls-remote", "--heads", repoUrl], (err, result) => {
      if (err) {
        console.error("获取远程分支失败:", err);
      } else {
        const branches = result.split("\n").map((line) => line);
        console.log("远程分支列表:", branches);
      }
    });
  }
  async cloneGit(repoUrl, branch = "master") {
    git.clone(repoUrl, "./local-repo", ["--branch", branch]);
    const tags = await git.tags();
    console.log(tags.all);
  }
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
