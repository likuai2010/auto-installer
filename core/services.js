const { AgcService } = require("./agcService");
const { EcoService } = require("./ecoService");
const { CmdService } = require("./cmdService");
const { DownloadHelper } = require("./downloadHelper");
const AdmZip = require('adm-zip');
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

const defaultIcon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACkAAAApCAYAAACoYAD2AAAABGdBTUEAALGPC/xhBQAAADhlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAKaADAAQAAAABAAAAKQAAAADj6KZlAAAKTElEQVRYCXWZTahdVxXH9znnvq/4akJak2pr07yaENsSqEkhVEqDA3USaUeBijMHhaKjQkDEgRMJBCdSEA34UVAEvzADHVipiCJatYQqz9CkJlLTtJiPvry83HfvPdv/b629zjlP627O2Xuv9V9r/ffaH2e/2yr9n3LwubVd7Vx9LOV8NKVqJVV5j6A79CzoGenZUnLe0k10K/2Xi8KqCkw1Vft2VeUbKVcX9VwQ6KXN1J45f+qOt7Z68Z6ZDRUHn8vvyXO3TuaUPys5hN61DEk5IWAiRSVlR6ojj04d6xPWembj4DSucnV6vtp24uypah03UbaQfPgLNw/K9gdSHggANQGrgnRyJUhHwNGuG1q6UWTTB5E9w+bXHWzJeEqrdZWO//3U8tnw1JEsBH8vxRLKIDYMbG3nV+xLdqwnRQH3Nq4fkgii1FY6p+RWxV8b0zodeb0QNSRT3M6tvyzIgWEALLo+qSwO+8xYmB5j002mKCLYG5ukS7wapjOg4xgIxW3UrqrVbfXSYaa+NgVrMAdBjIxeas0r2VBfHZPrRe0ZcawTwsbl2Dm24NRpza73Yesn9wQhh00MTv0DN6e3TpqEXTwbVZfUWXAQYg/C4D7+0Ch9ZG+d5htGJ0cICxAyG5spvfjXWfrLP1qJnSYEamGfPDSXVnZVaSRbGzDk5RvC9Nc2cvrFK7N08d/FrugVoQxYm2nU3jea1PWxKucFgxWsZymnrz69mB7fV6eZ5DjlCUhuGYqKPD55aJS+/ZtJ+savJiYYSfatZ5bSyl2V2wprtsU+xoKvpx4dpS//aJJ+e27mg9cAkRfMQp7Ux2r1jppAqfdUA8jp0fub9Pj+Ok0UYCJ7nin1NPuj9qbYb6o/1vP0Y3NpeUE+FOHTj43SXhHEdizetyc6GHmEox6X/nhTGZWfz31yTrEpvny6BEjS5uroKGcd1M7d3rGAH7lfGSwZmFKXtg5fwzFlFDLE8Jo6p/27q/Snizk9cHftA9IgGNxMj8wtO+Ap+KNgu6zTWMdOIg59IxuOc14Z+ZfEF7ApjUJK85ozSBpR1TgovEQsNoA7FQcj0YyYmJntCUiQeQjGIAs/I2gTh0CsKmFlangfREFS5bSHTO7w7VCIsiZEwogQ3NrIepLRxgfrVXvESM6IoH/TqcvV7NYkbVMDoaOnwC2L9G2aRdr0gnipto+kWzQDXhoWAX1Kg5jvTAyDeAQwJ8jV0GyLkWyoStbJpg1Iso6g2mCiz/EbSwm5Po0F4WyVwMWRzr/GzyzpVHSQFC9eGTl5jGBWA8Ej+Khpa4RkAxHyIGIkAKsYcdVh7/6KEyWJRJgDfLl4RCYte37GMQrPhukLXkInOewPZKwrHAcBMtuRCFzUxQdYim5D3WCCg+jJAU69jOiA776vtib7TLRkUfoYYNQRJDLJ7mSa8TTU0baMFh+Bd6/ul8/eTDycZAyQqF66e6GlmZQU3TsbAVEt2bsFCpklUph3biu0hLduF1vJLKMCQDaya2ubODzSsfs3dXZqE/fCcCFMbYHIQKS3OP75K9OSmeJL9uE3xkKfQvDrt1K68CaYKv36b1PDgmNjBDnDusbt9IbW6ht8UmlRPKM2g8Yla1OWSFQsekjj58qNnL70w8001jnXaD6YTj7fXS0YfXTXdEU98b2xBuWZ/MP5nL754sQOcvCcgfY02fDYmK3O4vNv53TyZxqUiECMx6lDVk2RrvZ+ft2adKMRxJERZPeOKs1pYTAIdQ3IwPXJSuvjnK6uueNY+OGpkfH73gtBNiMEZK/U2nS3Vbop27XBsoq4XhefsrPdHUoIWNuYeNo5rP911Q1MaRuL9QNhQkdxTBBlmvniXL42QFjT+zlObovptpaBjkCfSX1xCOKELFwhQZssPvuJ+fSArlu1psgOacmZEcyIs6EF/+fX2vTjP+ozY8V9zWkqH7ynSjuXG5vi2Lk+Fzio7GJy7nJOl6/jy/+scC7uCRsyb7s7Rk9tCmHI0XeeXUz77tY3PL6/+I4HDExVPrqvSR/6QJ1O/lSXSxXuj08dbtK9d/ItB2RTY7rhC92hlZTOvDxL5y6X/RAA883SULLiaHCCjmBMT3y4SftFcKIEcRWzKxnXrHI1sysXbWR6PvZQk3Zsg3iV9r2/Tvfs7KcrvFIP40Ae+k882NiAbUCQ0xPJoF3OyX6k7kTXLV27OL/8Dql7pNphGLVtRPlk/XETv/euOl3VPty+KGHJngUWwD8WQzltSpW2a3AsLT/QjWOx9qVT1qRvBDPBIUFlRZY5VuyqpSm3axujFNCIYkBHpWn0grX+sX7Rd8XFw27XDnsE/V7yE0AUzY+RZHF6NIjh3e+SNI0YZNU2FcgSNDLKsLkTtmpsnU6BS07cq0cxYhESCAUAldWOtlmQvabbiUE0hBZIjIAqtidInSA5rM2pdJWyBwAbD+RxjQtC5F75e9CxwcJDjY57OJGATGpr6G8yiywJKL2Am7GcoSKT+A1b23DRlw1yMhkAsBhYTbsU+oQwP9ZwhScIfPiAg0qbpyKZx5As7Oy8cp1foSBoDrEobfrW1cu/IqrlG+wWPI5KAW9GwaH0kcPVHfpsusxnRdrbXDB0lAqjyEZGJhwjdu0Cbd4VXE07zNU3MqxBhCpGTEDrF7xrSuyBn/AXemrUvuZpGWXJqBlRuq6NWF30qeunF7JX14RRoW36QsimXTLk+leWAS3dhOy3sCptaG5Mj9hVUfW15GAQcAbPNBXh022VNI1e6/RSrdgXCIDAbHip/PLsLN3QLwycX7YpJEPl4+wbcm1H1mtXcnpDv0Sw+M/pysahTzGfpVFcOznT+uvVi8yie4cHUfzqZtk83yw/8sWdEn9qEN6cjLWdfneuTQ9/UD+xzMGU0ZapVhdf9Pnj/9V/tukrP5kqI+ZUP73kdElXsDt1A5rX+QmWGxNnLp9YsjbVlNzSV/SsCJIQSGEdGweq1m7T16rdz+gX3WlzSZL+pxZHi5gaGmEZZBkhpuQPL55970vi/4q+x5ElpwAESwJgbl68b7aDviHSOFfT++orX9dPwG06beqCwdYf3+HuUDKbCrLST08QI7CbM1U+sPBhOnXcrte7nD7kKZAvfeOQT9984Y63OIJTPVk6IeAqQONhFg42EtGX3taKOShkkcnIBqApM4L/EwwSTkBw82E25pd+Pyg7r12+erNeOgHeSF55oVpvp+1xYTds6iBhzoAosN4YM+Ih6Rh11Ki97Vgy1+mMSJCR3L5wEAybvq1QG7mtjyfxQmskaVz77vLZPGuPyLEyKmKWUv9UdTtNDvFpD+2C6QOJhDZTELPaMCErs4N/7AcPCPqCr+qKfWT9+wvdb+YdSUAQnZ8tHRb6eeHHFlwNSkxjl1FkCkafjMHFghq2tJEVQnHwD6fW/XbYsU6Q5zdGi4eHBMH4NqP1X2X5M2u7mjQ6JqdH66pa0XLbIxL8fxxuiw3B/FKy1RCiUAvX4KKNRkXnTdJf6Pal0wGULmjmX6qb6Rk2iUO2vv8DX5ftBRz5g3UAAAAASUVORK5CYII="
const { BrowserWindow, ipcMain, app, dialog,shell   } = require("electron");
const { BuildService } = require("./buildService");
const { compile } = require("vue");
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
    
    ipcMain.on("openBigHap",async (_) => {
      const result = await dialog.showOpenDialog(main, {
        properties: ['openFile'],
        filters: [
            { name: 'hap', extensions: ['hap'] },
        ],
      });
      let filpath = result["filePaths"][0];
      console.log("testTag", filpath)
      main.webContents.send("onOpenBigHap",  await this.loadBigHap(filpath));
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
  async loadBigHap(filePath){
    const zip = new AdmZip(filePath);
    const fileNameToExtract = "module.json"
    let moduleInfo = {}
    if (zip.getEntries().some(entry => entry.entryName === fileNameToExtract)) {
      // 读取指定文件内容
      const fileEntry = zip.getEntry(fileNameToExtract);
      const fileContent = fileEntry.getData().toString('utf8');
      moduleInfo = JSON.parse(fileContent)
      console.log('File content:', fileContent);
    } else {
      console.log(`File "${fileNameToExtract}" not found in the ZIP archive.`);
    }
    return {
      packageName: moduleInfo?.app?.bundleName || "",
      appName: moduleInfo?.app?.vendor || moduleInfo?.app?.label,
      versionName: moduleInfo?.app?.versionName,
      hapPath: filePath,
      icon: defaultIcon,
    };
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
    const icon = this.parseIcon(moduleInfo, outPath)
    return {
      packageName: moduleInfo?.app?.bundleName || "",
      appName: moduleInfo?.app?.vendor || moduleInfo?.app?.label,
      versionName: moduleInfo?.app?.versionName,
      hapPath: filePath,
      icon: icon,
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
  async clearCerts(){
    await this.build.clearCerts()
  }
  childWindow = {};
  loginEco(
    url = "https://cn.devecostudio.huawei.com/console/DevEcoIDE/apply?port=3333&appid=1007&code=20698961dd4f420c8b44f49010c6f0cc"
  ) {
    shell.openExternal(url)
    
    // this.childWindow = new BrowserWindow({
    //   width: 800,
    //   height: 600,
    //   webPreferences: {
    //     contextIsolation: true,
    //     enableRemoteModule: false,
    //     nodeIntegration: false,
    //   },
    // });
    // this.childWindow.loadURL(url);
    // this.childWindow.webContents.on("did-finish-load", async () => {
    //   const cookies = await this.childWindow.webContents.session.cookies.get({
    //     url: "https://developer.huawei.com",
    //   });

    //   const authInfo = this.agc.findCookieValue(cookies, "ds-authInfo");
    //   if (authInfo) {
    //     const decoded = decodeURIComponent(authInfo);
    //     await this.eco.initCookie(JSON.parse(decoded));
    //   }
    // });
  }
  closeLoginEco() {
    this.childWindow.close();
  }
}

module.exports = { CoreService };
