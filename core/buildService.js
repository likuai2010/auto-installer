
class BuildService{
    constructor(agc, core){
        this.agc = agc
        this.core = core
    }
    running = false
    async checkAccount(commonInfo){
        if(this.running)
            return 
        this.running = true
        if (this.agc.csrfToken == ""){
            // 未登录
            this.core.openChildWindiow();
        }else{
            // 已经登录
            
        }
        this.running = false;
    }

    async startBuild(commonInfo){

    }
}


module.exports = {
    BuildService
}