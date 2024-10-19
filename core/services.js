const { AgcService } = require("./agcService");
const { EcoService } = require("./ecoService");
const { CmdService } = require("./cmdService");
const { DownloadHelper } = require("./downloadHelper");
const path = require("node:path");
const fs = require("node:fs");
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
const { BrowserWindow, ipcMain, app } = require("electron");
const { BuildService } = require("./buildService");
const git = simpleGit();
class CoreService {
  dh = new DownloadHelper();
  agc = new AgcService();
  cmd = new CmdService();
  eco = new EcoService(this);
  build = new BuildService(this);

  commonInfo = {
    packageName: "com.xx.xx",
    appName: "app",
    github: "https://github.com/likuai2010/ClashMeta.git",
    branch: "master",
    downloadUrl: "https://xxx",
    deviceIp: "",
    type: 0,
  };
  envInfo = {
    steps: [
      {
        name: "环境检查",
        finish: true,
        value: "正常",
        url: "",
        message: "通过",
      },
      {
        name: "命令行工具",
        finish: true,
        value: "已内置",
        url: "",
        message: "通过",
      },
    ],
  };
  accountInfo = {
    steps: [
      {
        name: "华为账号",
        finish: false,
        value: "",
        loading: true,
        message: "未登录",
      },
    ],
  };
  buildInfo = {
    steps: [
      {
        name: "拉取代码",
        finish: false,
        value: "",
        loading: false,
        message: "拉取失败",
      },
      {
        name: "构建应用",
        finish: false,
        value: "",
        loading: false,
        message: "构建失败",
      },
      {
        name: "签名应用",
        finish: false,
        value: "",
        loading: false,
        message: "签名失败",
      },
      {
        name: "上传应用",
        finish: false,
        value: "",
        loading: false,
        message: "上传失败",
      },
      {
        name: "发布版本",
        finish: false,
        value: "",
        loading: false,
        message: "发布版本失败",
      },
      {
        name: "版本审核",
        finish: false,
        value: "",
        loading: false,
        message: "审核失败",
      },
    ],
    install: [
      {
        name: "构建应用",
        finish: false,
        value: "",
        loading: false,
        message: "构建引用失败",
      },
      {
        name: "签名应用",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
      {
        name: "连接设备",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
      {
        name: "安装应用",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
    ],
  };
  constructor() {
    let win =
      "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module&_gl=1*13dn9it*_gcl_au*Mzg3MDk4ODc5LjE3MjcxNTUwNzM.*_ga*MTI1ODE3OTcxNi4xNzIzNDQwMDY0*_ga_XJWPQMJYHQ*MTcyNzE1NTA3My4yLjEuMTcyNzE1NTA3OS41NC4wLjA.";
    let mac =
      "https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module&_gl=1*1jvi2eo*_gcl_au*Mzg3MDk4ODc5LjE3MjcxNTUwNzM.*_ga*MTI1ODE3OTcxNi4xNzIzNDQwMDY0*_ga_XJWPQMJYHQ*MTcyNzE1NTA3My4yLjEuMTcyNzE1NTA3OS41NC4wLjA.";
    this.envInfo.steps[0].url = process.platform !== "darwin" ? win : mac;
    this.envInfo.steps[1].url = process.platform !== "darwin" ? win : mac;
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
  async registerIpc(main) {
    try {
      let cookies = this.dh.readFileToObj("hw_cookies.json");
      this.agc.initCookie(cookies);
    } catch (e) {
      console.error("hw_cookies.json 不存在 \n");
    }
    try {
      let authInfo = this.dh.readFileToObj("ds-authInfo.json");
      await this.eco.initCookie(authInfo);
    } catch (e) {
      console.error("ds-authInfo.json 不存在 \n", e);
    }

    ipcMain.on("download-file", (_, fileUrl) => {
      this.dh.downloadAndInstallFile(main, fileUrl);
    });
    ipcMain.on("open-window", (_, fileUrl) => {
      // this.cloneGit("https://github.com/likuai2010/ClashMeta.git")
      // this.repoBrank("https://github.com/likuai2010/ClashMeta.git");
      this.loginAgc(fileUrl);
      // this.loginEco()
    });

    ipcMain.on("getEnvInfo", (_) => {
      let info = this.getEnvInfo();
      main.webContents.send("onEnvInfo", info);
    });
    ipcMain.on("getAccountInfo", (_) => {
      let info = this.getAccountInfo();
      main.webContents.send("onAccountInfo", info);
    });
    ipcMain.on("githubBranchs", (_, url) => {
      this.repoBranch(url)
        .then((data) => {
          main.webContents.send("onGithubBranchs", data);
        })
        .catch((e) => {
          main.webContents.send("onFailGithubBranchs", e);
        });
    });

    ipcMain.on("getBuildInfo", (_) => {
      let info = this.getBuildInfo();
      main.webContents.send("onBuildInfo", info);
    });
    ipcMain.on("uploadHap", async (_, file, fileName) => {
      let hapInfo = await this.saveFileToLocal(file, fileName);
      main.webContents.send("onUploadHap", hapInfo);
    });

    this.commonInfo;
    ipcMain.on("checkAccount", async (_, commonInfo) => {
      this.commonInfo = commonInfo;
      await this.build.checkEcoAccount(this.commonInfo);
      let info = this.getAccountInfo();
      main.webContents.send("onCheckAccount", info);
    });
    ipcMain.on("startBuild", async  (_, commonInfo) => {
      await this.build.startBuild(commonInfo);
      let info = this.getBuildInfo();
      main.webContents.send("onStartBuild", info);
    });
    // setInterval(() => {
    //   try {
    //     let cookies = this.dh.readFileToObj("hw_cookies.json");
    //     this.agc.initCookie(cookies);
    //   } catch (e) {
    //     console.error("hw_cookies.json 不存在 \n");
    //   }
    // }, 10000);
  }
  childWindow = {};

  async repoBranch(repoUrl) {
    return new Promise((resolve, reject) => {
      git.raw(["ls-remote", "--heads", repoUrl], (err, result) => {
        if (err) {
          reject(new Error(err));
        } else {
          const branches = result.split("\n").map((line) => line);
          resolve(branches);
        }
      });
    });
  }

  async saveFileToLocal(buffer, filename) {
    console.log("saveHap", filename, buffer.length);
    let filePath = path.join(this.dh.hapDir, filename);
    const outPath = path.join(this.dh.hapDir, "hap_unpack_out");
    const appOutPath = path.join(this.dh.hapDir, "app_unpack_out");
    await new Promise((resolve, reject) => {
      fs.writeFile(filePath, buffer, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
    let moduleInfo = {};
    if (filename.endsWith(".app")) {
      await this.cmd.unpackApp(filePath, appOutPath);
      await this.cmd.unpackHap(
        this.dh.hapDir + "/app_unpack_out/entry-default.hap",
        outPath
      );
      moduleInfo = this.dh.readFileToObj(
        "hap_unpack_out/module.json",
        this.dh.hapDir
      );
      moduleInfo.app.debug = true;
      this.dh.writeObjToFile(
        "hap_unpack_out/module.json",
        moduleInfo,
        this.dh.hapDir
      );
      await this.cmd.packHap(
        this.dh.hapDir + "/hap_unpack_out",
        this.dh.hapDir + `/${filename.replace(".app", ".hap")}`
      );
      filePath = this.dh.hapDir + `/${filename.replace(".app", ".hap")}`;
    } else {
      await this.cmd.unpackHap(filePath, outPath);
      moduleInfo = this.dh.readFileToObj(
        "hap_unpack_out/module.json",
        this.dh.hapDir
      );
    }
    console.debug("moduleInfo", moduleInfo);
    return {
      packageName: moduleInfo?.app?.bundleName || "",
      appName: moduleInfo?.app?.vendor || moduleInfo?.app?.label,
      versionName: moduleInfo?.app?.versionName,
      hapPath: filePath,
      icon: this.parseIcon(moduleInfo, outPath),
    };
  }
  parseIcon(moduleInfo, outPath) {
    const icon = moduleInfo.app.icon;
    const iconPath = path.join(
      outPath,
      "/resources/base/media/" + icon.replace("$media:", "")
    );
    let filePath = "";
    if (fs.existsSync(iconPath + ".json")) {
      iconJson = this.dh.readFileToObj(
        "hap_unpack_out/module.json",
        this.dh.hapDir
      );
      // TODO
      filePath = iconJson["layered-image"].foreground + ".png";
    } else {
      if (fs.existsSync(iconPath + ".png")) {
        filePath = iconPath + ".png";
      }
    }
    const iconraw = this.dh.readPng(filePath);
    console.log("iconPath", filePath);
    return `data:image/png;base64,${iconraw}`;
  }
  loginAgc(
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
      console.log("cookie", cookies);
      const authInfo = this.agc.findCookieValue(cookies, "authInfo");
      if (authInfo) {
        this.agc.initCookie(cookies);
        this.dh.writeObjToFile("hw_cookies.json", cookies);
        this.build.checkAccount();
        childWindow.close();
      }
    });
  }
  childWindow = {};
  loginEco(
    url = "https://cn.devecostudio.huawei.com/console/DevEcoIDE/apply?port=3333&appid=1007&code=20698961dd4f420c8b44f49010c6f0cc"
  ) {
    this.childWindow = new BrowserWindow({
      width: 800,
      height: 600,
      webPreferences: {
        contextIsolation: true,
        enableRemoteModule: false,
        nodeIntegration: false,
      },
    });
    this.childWindow.loadURL(url);
    this.childWindow.webContents.on("did-finish-load", async () => {
      const cookies = await this.childWindow.webContents.session.cookies.get({
        url: "https://developer.huawei.com",
      });

      const authInfo = this.agc.findCookieValue(cookies, "ds-authInfo");
      if (authInfo) {
        const decoded = decodeURIComponent(authInfo);
        await this.eco.initCookie(JSON.parse(decoded));
      }
    });
  }
  closeLoginEco() {
    this.childWindow.close();
  }
}

module.exports = { CoreService };
