class BuildService {
  constructor(core) {
    this.agc = core.agc;
    this.core = core;
    this.dh = core.dh;
  }
  running = false;

  agcConfig = {
    clientId: "",
    clientKey: "",
    teamId: "",
    projectId: "",
    appId: "",
    prodCertId: "",
    debugCertId: "",
  };
  async checkAccount(commonInfo) {
    if (this.running) return;
    this.running = true;
    if (this.agc.csrfToken == "") {
      // 未登录
      this.core.openChildWindiow();
    } else {
      // 已经登录
      let result = await this.startStep(
        "accountInfo",
        0,
        async (i) => {
        
          let result = await this.agc.userTeamList();
          let userTeam = result.teams.find((i) => i.userType == 1);
          this.agcConfig.teamId = userTeam.id;
          this.agc.agcteamid = userTeam.id;
          console.debug("userTeam", userTeam, result.teams)
          let userInfo = (await this.agc.userInfo()).body.getDetailInfo;
          return {
            value: userTeam.name || userInfo.baseInfo.nickName,
            message: "登录成功",
          };
        },
        "失败"
      );
      if (!result) {
        this.core.openChildWindiow();
      }
      const appName = commonInfo?.appName || "xiaobai-app";
      const packageName = commonInfo?.packageName || "com.xiaobai.app";

      console.log("commonInfo", commonInfo);

      await this.startStep(
        "accountInfo",
        1,
        async (i) => {
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
          return {
            value: app.appName + `(${app.packageName})`,
            message: "完成",
          };
        },
        "失败"
      );
      await this.startStep(
        "accountInfo",
        2,
        async (i) => {
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
          this.agcConfig.clientId = api.secrets[0].name;
          return {
            value: `${api.clientId}(${api.secrets[0].name.substring(0, 8)}...)`,
            message: "完成",
          };
        },
        "失败"
      );
      await this.startStep(
        "accountInfo",
        3,
        async (i) => {
          let result = await this.agc.getCertList();
          let debugCert = result.certList.find(
            (a) => a.certName == "xiaobai-debug"
          );
          if (!debugCert) {
            result = await this.agc.createCert("xiaobai-debug", 1);
            debugCert = result.harmonyCert;
          }
          console.debug("cert ", debugCert);
          this.agcConfig.debugCertId = debugCert.id;
          return {
            value: `${debugCert.certName}`,
            message: "完成",
          };
        },
        "失败"
      );
      await this.startStep(
        "accountInfo",
        4,
        async (i) => {
          const pordName = "moonlight-prod";
          let result = await this.agc.getCertList();
          let debugCert = result.certList.find((a) => a.certName == pordName);
          if (!debugCert) {
            result = await this.agc.createCert(pordName, 2);
            debugCert = result.harmonyCert;
          }
          console.debug("cert ", debugCert);
          this.agcConfig.prodCertId = debugCert.id;
          return {
            value: `${debugCert.certName}`,
            message: "完成",
          };
        },
        "失败"
      );
      await this.startStep(
        "accountInfo",
        5,
        async (i) => {
          const profileName = "xiaobai-debug";
          let result = await this.agc.profileList(packageName);
          let profile = result.list.find(
            (a) => a.packageName == packageName && a.provisionType == 1
          );
          if (!profile) {
            let deviceUdid = "2CE6542BA4A186D329CC9C1B38CA1565C63BCDC1F703EBC4B496BB343338EAB4"
            result = await this.agc.deviceList("xiaobai-device")
            let deviceList = result.list || []
            console.debug("device", deviceList);
            if (deviceList.length == 0) {
                await this.agc.createDevice("xiaobai-device", deviceUdid)
                result = await this.agc.deviceList("xiaobai-device")
                deviceList = result.list
            }
            result = await this.agc.createProfile(
                profileName,
                this.agcConfig.debugCertId,
                this.agcConfig.appId,
                1,
                deviceList.map((d)=>d.id)
            );
            console.debug("create profile ", result);
            profile = result.provisionInfo;
          }
          console.debug("profile ", profile);
          return {
            value: `${packageName}(${profile.provisionName})`,
            message: "完成",
          };
        },
        "失败"
      );
      await this.startStep(
        "accountInfo",
        6,
        async (i) => {
          const profileName = "xiaobai-prod";
          let result = await this.agc.profileList(packageName);
          let profile = result.list.find(
            (a) => a.packageName == packageName && a.provisionType == 2
          );
          if (!profile) {
            result = await this.agc.createProfile(
            profileName,
              this.agcConfig.prodCertId,
              this.agcConfig.appId,
              2
            );
            profile = result.provisionInfo;
          }
          console.debug("profile ", profile);
          return {
            value: `${packageName}(${profile.provisionName})`,
            message: "完成",
          };
        },
        "失败"
      );
    }
    console.debug("agcConfig", this.agcConfig);
    this.dh.writeObjToFile("agc_config.json", this.agcConfig)
    this.running = false;
  }

  async startStep(key, i, callback, error = "") {
    this.updateStep(key, i, { loading: true, value: "", message: "" });
    try {
      let result = await callback(i, key);
      this.finishStep(key, i, result.value, result.message);
      return true;
    } catch (e) {
      console.error("startStep error", e.message, e.stack)
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

  async startBuild(commonInfo) {}
}

module.exports = {
  BuildService,
};
