
class BuildService{
    constructor(core){
        this.agc = core.agc
        this.core = core
        this.dh = core.dh
    }
    running = false

    agcConfig= {
        clientId:"",
        clientKey:"",
        teamId: "",
        projectId: "",
        appId: "",
        prodCertId: "",
        debugCertId: "",
    }
    async checkAccount(commonInfo){
        if(this.running)
            return 
        this.running = true
        if (this.agc.csrfToken == ""){
            // 未登录
            this.core.openChildWindiow();
        }else{
            // 已经登录
            let result = await this.startStep("accountInfo", 0, async (i)=>{
                let result = await this.agc.userTeamList();
                let userTeam = result.teams.find((i)=> i.userType == 1)
                this.agcConfig.teamId = userTeam.id;
                this.agc.agcteamid = userTeam.id
                return {
                    value: userTeam.name,
                    message: "登陆成功"
                }
            }, "失败")
            if(!result){
                this.core.openChildWindiow();
            }
            const appName = "xiaobai-app"
            const packageName = "com.xiaobai.app"

            await this.startStep("accountInfo", 1, async (i)=>{
                let projectName = "xiaobai-project"
                let result = await this.agc.projectList(projectName);
                let project = {}
                let projectId = ""
                if(result.projectList.length > 0){
                    project = result.projectList[0]
                    projectId= project.projectId
                }else{
                    result =  await this.agc.createProject(projectName);
                    projectId= result.mapping.projectId
                }
                this.agcConfig.projectId = projectId
                result = await this.agc.appList()
                const appList = result.appList
                let app = appList.find((a)=> a.packageName == packageName)
                if (!app){
                    let result = await this.agc.createApp(appName, packageName, projectId)
                    const appId = result.appId
                    await this.agc.orderApp(projectId, appId)
                    result = await this.agc.appList()
                    app = result.appList.find((a)=>a.appId == appId)
                    console.debug("new app", app);
                }
                this.agcConfig.appId = app.appId
                return {
                    value: app.appName + `(${app.packageName})`,
                    message: "完成"
                }
            },"失败")
            await this.startStep("accountInfo", 2, async (i)=>{
                let clientName = "xiaobai-api"
                let result = await this.agc.clientApiList()
                const api = result.clients.find(a=> a.name == clientName)
                if (!api) {
                    result = await this.agc.createApi(clientName)
                    const clientId = result.clientId
                    result = await this.agc.clientApiList()
                    api = result.clients.find(a=> a.clientId == clientId)
                }
                this.agcConfig.clientId = api.clientId
                this.agcConfig.clientId = api.secrets[0].name
                return {
                    value: `${api.clientId}(${api.secrets[0].name.substring(0,8)}...)`,
                    message: "完成"
                }
            },"失败")
            await this.startStep("accountInfo", 3, async (i)=>{
                let result = await this.agc.getCertList()
                let debugCert = result.certList.find(a=> a.certName == "xiaobai-debug")
                if (!debugCert) {
                    result = await this.agc.createCert("xiaobai-debug",1)
                    debugCert = result.harmonyCert
                }
                console.debug("cert ", debugCert);
                this.agcConfig.prodCertId = debugCert.id
                return {
                    value: `${debugCert.certName}`,
                    message: "完成"
                }
            },"失败")
            await this.startStep("accountInfo", 4, async (i)=>{
                const pordName = "moonlight-prod"
                let result = await this.agc.getCertList()
                let debugCert = result.certList.find(a=> a.certName == pordName)
                if (!debugCert) {
                    result = await this.agc.createCert(pordName, 2)
                    debugCert = result.harmonyCert
                }
                console.debug("cert ", debugCert);
                this.agcConfig.prodCertId = debugCert.id
                return {
                    value: `${debugCert.certName}`,
                    message: "完成"
                }
            },"失败")
            await this.startStep("accountInfo", 5, async (i)=>{
                const pordName = "xiaobai-prod"
                let result = await this.agc.profileList(packageName)
                let profile = result.list.find(a=> a.packageName == packageName && a.provisionType == 2)
                if (!profile) {
                    console.debug("agcConfig", this.agcConfig);
                    result = await this.agc.createProfile("xiaobai-prod", this.agcConfig.prodCertId, this.agcConfig.appId, 2)
                    console.debug("create profile ", result);
                    profile = result.provisionInfo
                }
                console.debug("profile ", profile);
                return {
                    value: `${packageName}(${profile.provisionName})`,
                    message: "完成"
                }
            },"失败")
            
        }
        this.running = false;
    }



    async startStep(key,i, callback, error=""){
        this.updateStep(key,i,{ loading: true, value: "", message:""})
        try{
            let result = await callback(i,key)
            this.finishStep(key, i, result.value, result.message)
            return true
        } catch(e){
            this.failStep(key, i, e, error)
            return false
        }
    }
    finishStep(key, i, value, message){
        this.updateStep(key,i,{ loading: false, finish: true, value: value, message: message})
    }
    failStep(key, i, value, message){
        this.updateStep(key,i,{ loading: false, finish: false, value: value, message:message})
    }
    updateStep(key, i, obj){
        let old = this.core[key].steps[i]
        this.core[key].steps[i] = {
            ...old,
            ...obj
        }
    }

    async startBuild(commonInfo){

    }
}


module.exports = {
    BuildService
}