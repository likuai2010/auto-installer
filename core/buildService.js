
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
            
            this.startStep("accountInfo", 0, async (i)=>{
                let result = await this.agc.userTeamList();
                let userTeam = result.teams.find((i)=> i.userType == 1)
                this.agcConfig.teamId = userTeam.id;
                this.agc.agcteamid = userTeam.id
                return {
                    value: userTeam.name,
                    message: "登陆成功"
                }
            }, "获取team失败")

            this.startStep("accountInfo", 1, async (i)=>{
                let result = await this.agc.projectList("xiaobai");
                console.debug("result", result.projectList.length, result)
                let project = {}
                let projectId = ""
                if(result.projectList.length > 0){
                    project = result.projectList[0]
                    projectId= project.projectId
                }else{
                    result =  await this.agc.createProject("xiaobai");
                    projectId= result.mapping.projectId
                    console.debug("create result", result);
                }
                console.debug("project", JSON.stringify(project));
                return {
                    value: projectId,
                    message: "创建成功"
                }
            },"创建失败")
        }
        this.running = false;
    }
    async startStep(key,i, callback, error=""){
        this.updateStep(key,i,{ loading: true, value: "", message:""})
        try{
            let result = await callback(i,key)
            this.finishStep(key, i, result.value, result.message)
        } catch(e){
            this.failStep(key, i, e, error)
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