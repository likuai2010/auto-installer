const { CmdService } = require("./cmdService");
const fs = require('node:fs')


class BuildService {
  constructor(core) {
    this.agc = core.agc;
    this.core = core;
    this.dh = core.dh;
    this.cmd = core.cmd;
    this.eco = core.eco
  }
  running = false;

  agcConfig = {
    clientId: "",
    clientKey: "",
    teamId: "",
    projectId: "",
    appId: "",
    prodCert: {},
    prodProfile:{}
  };
  ecoConfig = {
    teamId: "",
    uid: "",
    keystore: "store/xiaobai.p12",
    storepass:"xiaobai123",
    keyAlias:"xiaobai",
    outPath:"",
    debugCert: {},
    debugProfile:{}
  };

  async checkAgcAccount(commonInfo) {
    this.agcConfig = this.dh.readFileToObj("agc_config.json")
    
    if (this.running) return;
    this.running = true;

    this.core.accountInfo.steps = [
      {
        name: "华为账号",
        finish: false,
        value: "17611576573",
        loading: false,
        message: "未登录",
      },
      {
        name: "创建应用",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
      {
        name: "ClientApi",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
      {
        name: "证书(发布)",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
      {
        name: "Profile(发布)",
        finish: false,
        value: "",
        loading: false,
        message: "",
      },
    ]
    // 已经登录
    let result = await this.startStep(
      "accountInfo",
      0,
      async (i) => {
        if (this.agcConfig.teamId) {
          return {
            value: "未登录",
            message: "完成",
          };
        }
        let result = await this.agc.userTeamList();
        let userTeam = result.teams.find((i) => i.userType == 1);
        this.agcConfig.teamId = userTeam.id;
        this.agc.agcteamid = userTeam.id;
        let userInfo = (await this.agc.userInfo()).body.getDetailInfo;
        return {
          value: userTeam.name || userInfo.baseInfo.nickName,
          message: "登录成功",
        };
      },
      "失败"
    );
    if (!result) {
      this.running = false;
      this.core.openChildWindiow();
      return;
    }

    const appName = commonInfo?.appName || "xiaobai-app";
    const packageName = commonInfo?.packageName || "com.xiaobai.app";

    await this.startStep(
      "accountInfo",
      1,
      async (i) => {
        if (this.agcConfig.appId && this.agcConfig.appName) {
          return {
            value: this.agcConfig.appName + `(${packageName})`,
            message: "完成",
          };
        }
        let projectName = "xiaobai-project";
        let result = await this.agc.projectList(projectName);
        let project = {};
        let projectId = "";
        if (result.projectList.length > 0) {
          project = result.projectList[0];
          projectId = project.projectId;
        } else {
          result = await this.agc.createProject(projectName);
          projectId = result.mapping.projectId;
        }
        this.agcConfig.projectId = projectId;
        result = await this.agc.appList();
        const appList = result.appList || [];
        let app = appList.find((a) => a.packageName == packageName);
        if (!app) {
          let result = await this.agc.createApp(
            appName,
            packageName,
            projectId
          );
          const appId = result.appId;
          await this.agc.orderApp(projectId, appId);
          result = await this.agc.appList();
          app = result.appList.find((a) => a.appId == appId);
          console.debug("new app", app);
        }
        this.agcConfig.appId = app.appId;
        this.agcConfig.appName = app.appName
        return {
          value: app.appName + `(${packageName})`,
          message: "完成",
        };
      },
      "失败"
    );
    // clientApi
    await this.startStep(
      "accountInfo",
      2,
      async (i) => {
        if (this.agcConfig.clientId && this.agcConfig.clientKey) {
          return {
            value: `${this.agcConfig.clientId}(${this.agcConfig.clientKey.substring(0, 8)}...)`,
            message: "完成",
          };
        }
        let clientName = "xiaobai-api";
        let result = await this.agc.clientApiList();
        const api = result.clients.find((a) => a.name == clientName);
        if (!api) {
          result = await this.agc.createApi(clientName);
          const clientId = result.clientId;
          result = await this.agc.clientApiList();
          api = result.clients.find((a) => a.clientId == clientId);
        }
        this.agcConfig.clientId = api.clientId;
        this.agcConfig.clientKey = api.secrets[0].name;
        return {
          value: `${api.clientId}(${api.secrets[0].name.substring(0, 8)}...)`,
          message: "完成",
        };
      },
      "失败"
    );
    // prodCert
    await this.startStep(
      "accountInfo",
      3,
      async (i) => {
        if (this.agcConfig.prodCert.path) {
          return {
            value: `${this.agcConfig.prodCert.name}`,
            message: "完成",
          };
        }
        const pordName = "moonlight-prod";
        let prodCert = await this.createAndDownloadCert(pordName, 2)
        this.agcConfig.prodCert = prodCert
        return {
          value: `${pordName}`,
          message: "完成",
        };
      },
      "失败"
    );
    // prod profile
    await this.startStep(
      "accountInfo",
      4,
      async (i) => {
        if (this.agcConfig.prodProfile.path) {
          return {
            value: `${this.agcConfig.prodProfile.name}`,
            message: "完成",
          };
        }
        const profileName = "xiaobai-prod";
        this.agcConfig.prodProfile = await this.createAndDownloadProfile(packageName, profileName, 2)
        return {
          value: `${profileName}`,
          message: "完成",
        };
      },
      "失败"
    );
    this.dh.writeObjToFile("agc_config.json", this.agcConfig)
    this.running = false;
  }

  async checkEcoAccount(commonInfo) {
    this.ecoConfig = this.dh.readFileToObj("eco_config.json")
    this.core.accountInfo.steps = [
      {
        name: "华为账号",
        finish: false,
        value: "",
        loading: true,
        message: "",
      },
      {
        name: "证书(debug)",
        finish: false,
        value: "",
        loading: true,
        message: "",
      },
      {
        name: "Profile(debug)",
        finish: false,
        value: "",
        loading: true,
        message: "",
      },
    ]
    // 已经登录
    let result = await this.startStep(
      "accountInfo",
      0,
      async (i) => {
       
        let result = await this.eco.userTeamList();
        let userTeam = result.teams[0];
        return {
          value: userTeam?.name || this.nickName,
          message: "登录成功",
        };
      },
      "失败"
    );
    if(!result){
      this.core.loginEco()
    }
    const packageName = commonInfo?.packageName || "com.xiaobai.app";

    // debugCert
    await this.startStep(
      "accountInfo",
      1,
      async (i) => {
        if (this.ecoConfig.debugCert?.path) {
          return {
            value: `${this.ecoConfig.debugCert.name}`,
            message: "完成",
          };
        }
        const pordName = "xiaobai-debug";
        let debugCert = await this.createAndDownloadDebugCert(pordName)
        this.ecoConfig.debugCert = debugCert
        return {
          value: `${pordName}`,
          message: "完成",
        };
      },
      "失败"
    );
    // debug profile
    await this.startStep(
      "accountInfo",
      2,
      async (i) => {
        const profileName = "xiaobai-debug";
        this.ecoConfig.debugProfile = await this.createAndDownloadDebugProfile(packageName, profileName)
        return {
          value: `${this.ecoConfig.debugProfile.name}`,
          message: "完成",
        };
      },
      "失败"
    );
    this.dh.writeObjToFile("eco_config.json", this.ecoConfig)
  }

  async startBuild(commonInfo) {
    this.sginAndInstall(commonInfo)
  }
  async sginAndInstall(commonInfo) {
   this.core.buildInfo.steps=[
    {
      name: "签名应用",
      finish: false,
      value: "",
      loading: true,
      message: "",
    },
    {
      name: "安装应用",
      finish: false,
      value: "",
      loading: true,
      message: "",
    },
   ]
   
    await this.startStep(
      "buildInfo", 0,
      async (i) => {
        this.ecoConfig.outFile = "singned.hap"
        await this.cmd.signHap({
          keystoreFile: this.ecoConfig.keystore,
          keystorePwd: this.ecoConfig.storepass,
          keyAlias: this.ecoConfig.keyAlias,
          certFile: this.ecoConfig.debugCert.path,
          profilFile: this.ecoConfig.debugProfile.path,
          inFile: commonInfo.hapPath,
          outFile: this.ecoConfig.outFile        
        })
        // await this.cmd.verifyApp({
        //   keystoreFile: this.ecoConfig.keystore,
        //   keystorePwd: this.ecoConfig.storepass,
        //   profilFile: this.ecoConfig.debugProfile.path,
        //   inFile: this.ecoConfig.outFile,
        //   outCertChain:'./outCertChain.cer'        
        // })
        return {
          value: `签名成功`,
          message: "完成",
        };
      },
      "失败"
    );
    await this.startStep(
      "buildInfo", 1,
      async (i) => {
        await this.cmd.sendAndInstall(this.ecoConfig.outFile)
        return {
          value: `安装完成`,
          message: "完成",
        };
      },
      "失败"
    );
  }
  async buildAndInstaller(commonInfo) {
    // git clone 
    // await this.startStep(
    //   "buildInfo", 0,
    //   async (i) => {
    //     await this.dh.cloneGit(commonInfo.github, commonInfo.branch)
    //     return {
    //       value: `下载完成`,
    //       message: "完成",
    //     };
    //   },
    //   "失败"
    // );
    // build
    await this.startStep(
      "buildInfo", 1,
      async (i) => {
        this.cmd.buildApp()
        return {
          value: ``,
          message: "完成",
        };
      },
      "失败"
    );

    // // signApp
    // await this.startStep(
    //   "buildInfo", 2,
    //   async (i) => {
    //     await this.cmd.signHap()
    //     await this.cmd.verifyApp()
    //     return {
    //       value: `签名成功(debug)`,
    //       message: "完成",
    //     };
    //   },
    //   "失败"
    // );
    // // installApp
    // await this.startStep(
    //   "buildInfo", 3,
    //   async (i) => {
    //     let devices = this.cmd.deviceList()
    //     if(devices == 0){
    //       throw new Error("请开启手机开发者模式,并连接手机到电脑上")
    //     }
    //     let deviceId = devices[0]
    //     await this.cmd.sendFile(deviceId, "./singned.hap")
    //     await this.cmd.installHap(deviceId)
    //     return {
    //       value: `安装完成`,
    //       message: "完成",
    //     };
    //   },
    //   "失败"
    // );
  }

  async checkPackageName(packageName) {
    try {
      let result = await this.agc.checkPackageName(packageName);
      if (result.ret.code == 0)
        return true
      else {
        console.log("create result", result)
      }
      return false
    } catch (e) {
      if (e == "401") {
        this.core.openChildWindiow();
      }
      return false;
    }
  }
  async createPackageName(appName) {
    try {
      let userInfo = (await this.agc.userInfo()).body.getDetailInfo;
      let userId = userInfo.userID
      let packageName = `com.${userId}.${appName}`
      console.log("create tpackageName", packageName)
      this.checkPackageName(packageName)

      return packageName;
    } catch (e) {
      if (e == "401") {
        this.core.openChildWindiow();
      }
      return false;
    }
  }
  async createAndDownloadDebugCert(name, type = 1) {
    let result = await this.eco.getCertList();
    let debugCerts= result.certList.filter(
      (a) => a.certType == 1
    );
    let debugCert= result.certList.find(
      (a) => a.certName == name
    );
    if(!debugCert && debugCerts.length > 1){
      await this.eco.deleteCertList(debugCerts[0].id)
    }
    const config = this.dh.configDir
    this.ecoConfig.keystore = config + "/xiaobai.p12"
    await this.cmd.createKeystore(this.ecoConfig.keystore)
    const csrPath = await this.cmd.createCsr(this.ecoConfig.keystore, config + "/xiaobai.csr")
    this.ecoConfig.csrPath = csrPath
    if (!debugCert) {
      const csr = await this.cmd.readcsr(csrPath)
      result = await this.eco.createCert(name, type, csr);
      debugCert = result.harmonyCert;
    }
    console.log("debug cert", debugCert)
    result = await this.eco.downloadObj(debugCert.certObjectId)
    const debugCertUrl = result.urlsInfo[0].newUrl
    console.log("url", debugCertUrl)
    const filePath = await this.dh.downloadFile(debugCertUrl, name + ".cer")
    return {
      id: debugCert.id,
      name,
      objId: debugCert.certObjectId,
      url: debugCertUrl,
      path: filePath
    }
  }
  async createAndDownloadDebugProfile(packageName, name,) {
    let profileName =  name +"_"+ packageName.replace(".","_") + ".p7b"
    if(fs.existsSync(this.dh.configDir + profileName)){
      return {
        name: profileName,
        path: this.dh.configDir + profileName
      }
    }
    let result = await this.eco.deviceList()
    let deviceIds = result.list.map(d=>d.id)
    if (deviceIds.length == 0){
      let device = this.cmd.deviceList()
      if (device.length == 0) {
        throw new Error("请连接手机, 并开启开发者模式")
      }
      const udid = await this.cmd.getUdid(null)
      result = await this.eco.createDevice("xiaobai-device", udid)
      result = await this.eco.deviceList()
      deviceIds = result.list.map(d=>d.id)
    }
    
    result = await this.eco.createProfile(name, this.ecoConfig.debugCert.id, packageName, deviceIds)
    const profilePath = await this.dh.downloadFile(result.provisionFileUrl, profileName)
    console.log("profile", result)
    return {
      name: profileName,
      path: profilePath
    }
  }

  async createAndDownloadCert(name, type = 1) {
    let result = await this.agc.getCertList();
    let debugCert = result.certList.find(
      (a) => a.certName == name
    );
    if (!debugCert) {
      result = await this.agc.createCert(name, type);
      debugCert = result.harmonyCert;
    }
    console.debug("cert ", debugCert);
    result = await this.agc.downloadObj(debugCert.certObjectId, name + ".cer")
    let urlnfo = result.urlInfo;
    let filePath = this.dh.downloadFile(urlnfo.url, name + ".cer")

    return {
      id: debugCert.id,
      name,
      objId: debugCert.certObjectId,
      url: urlnfo.url,
      path: filePath
    }
  }


  async createAndDownloadProfile(packageName, name, type = 1) {
    let result = await this.agc.profileList(packageName);
    let profile = result.list.find(
      (a) => a.packageName == packageName && a.provisionType == type
    );
    if (!profile) {
      // debug 需要注册设备
      if (type == 1) {
        result = await this.agc.deviceList("xiaobai-device")
        let deviceList = result.list || []
        if (deviceList.length == 0) {
          let device = this.cmd.deviceList()
          if (device.length == 0) {
            throw new Error("请连接手机")
          }
          const udid = await this.cmd.getUdid(null)

          await this.agc.createDevice("xiaobai-device", deviceUdid)
          result = await this.agc.deviceList("xiaobai-device")
          console.debug("devicelist", result);
          deviceList = result.list
        }
        result = await this.agc.createProfile(
          name,
          this.agcConfig.debugCert.id,
          this.agcConfig.appId,
          type,
          deviceList.map((d) => d.id)
        );

      } else {
        result = await this.agc.createProfile(
          name,
          this.agcConfig.prodCert.id,
          this.agcConfig.appId,
          type,
        );
      }
      profile = result.provisionInfo;
    }
    console.debug("profile ", profile);
    result = await this.agc.downloadObj(profile.provisionObjectId, name + ".p7b")
    let urlnfo = result.urlInfo;
    let filePath = this.dh.downloadFile(urlnfo.url, name + ".p7b")
    return {
      id: profile.id,
      name: name,
      path: filePath
    }
  }

  async startStep(key, i, callback, error = "") {
    this.updateStep(key, i, { loading: true, value: "", message: "" });
    try {
      let result = await callback(i, key);
      this.finishStep(key, i, result.value, result.message);
      return true;
    } catch (e) {
      console.error(`startStep ${i} error`, e.message || e, e.stack)
      this.failStep(key, i, e, error);
      return false;
    }
  }
  finishStep(key, i, value, message) {
    this.updateStep(key, i, {
      loading: false,
      finish: true,
      value: value,
      message: message,
    });
  }
  failStep(key, i, value, message) {
    this.updateStep(key, i, {
      loading: false,
      finish: false,
      value: value,
      message: message,
    });
  }
  updateStep(key, i, obj) {
    let old = this.core[key].steps[i];
    this.core[key].steps[i] = {
      ...old,
      ...obj,
    };
  }

}

module.exports = {
  BuildService,
};
