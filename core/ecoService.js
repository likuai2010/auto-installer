const { net } = require('electron')
const { resolve } = require('path')

class EcoService{
    constructor(core){
        this.core = core
        this.dh = core.dh
        this.cmd = core.cmd
    }
    async base(url, data={}, headers={},  method = "POST") {
        const request = net.request({
            url,
            method: method,
            headers:{
                "content-type": "application/json",
                "oauth2Token": this.oauth2Token,
                teamId: this.agcteamid,
                uid: this.userId,
                ...headers
            },
        })
    return new Promise((resolve, reject)=>{
            request.on('response', (response) => {
                response.on('data', (chunk) => {
                    try{
                        let data = JSON.parse(chunk.toString())
                        if (data.ret.code != 0){
                            reject(new Error(data.ret.msg))
                        } else {
                            resolve(data)
                        }
                    }catch(e){
                        console.log('baseGet response', e.mesage)
                    }
                   
                })
                if(response.statusCode != 200){
                    console.error('baseGet error', response.statusCode)
                    if(response.statusCode * 1 == 401){
                        reject("登陆信息过期或无效")
                    }
                }
                response.on('end', () => {
                    if(response.statusCode != 200){
                        reject(response.statusCode)
                    }else{
                        console.log('baseGet', 'No more data in response.')
                    }
                })
              })
            const str = JSON.stringify(data);
            request.write(str);
            request.end();
        })
    }
    oauth2Token = ""
    agcteamid = "2850086000506643987"
    userId = "2850086000506643987"
    async initCookie(token){
        this.oauth2Token = token
        try{
            let team = await this.userTeamList()
            if (team.teams)
                console.log("team", team, team.teams[0])
        }catch(e){
            this.core.loginEco()
        }
 
    }
    userTeamList(){
        let uri = "https://connect-api.cloud.huawei.com/api/ups/user-permission-service/v1/user-team-list"
        return this.base(uri, {}, {}, "GET")
    }
    getCertList(){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/list"
        return this.base(uri, {}, {
        }, "GET")
    }
    deleteCertList(certId){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/delete"
        return this.base(uri, {"certIds":[certId]}, {}, "DELETE")
    }
    // type 1 debug 2 prod
    createCert(name, type, csr){
        let uri = "connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/add"
        let params = {"csr":csr,"certName":name,"certType":type}
        return this.base(uri, params, {})
    }
   
    createProfile(name, certId, packageName="com.xiaobai.testgo", deviceIds=[]){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/provision-manage/v1/ide/test/provision/add"
        let params = {
            "provisionName": name,
            "aclPermissionList": [],
            "deviceList": deviceIds,
            "certList": [certId],
            "packageName": packageName
        }
        return this.base(uri, params, {})
    }
    downloadObj(objId){
        let uri = "https://connect-api.cloud.huawei.com/api/amis/app-manage/v1/objects/url/reapply"
        let params  = { sourceUrls:objId }
        return this.base(uri, params, {})
    }
    deviceList(){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/list?start=1&pageSize=100&encodeFlag=0"
        return this.base(uri, {}, {}, "GET")
    }
    createDevice(deviceName, uuid){
        let uri = " https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/add"
        let params  = {"deviceName":deviceName,"udid":uuid,"deviceType":4}
        return this.base(uri, params, {})
    }

  
    async autoCreateProile(packageName){
        let result = await this.getCertList()
        let debugCert = result.certList.filter(d=>d.certType == 1)[0]
        if(!debugCert){
            await cmd.ceraeteCsr("store/xiaobai.p12", "store/xioabi.csr")
            const csr = await cmd.readcsr("store/xioabi.csr")
            this.createCert("xiaobai-debug", 1, csr)
        }
        result = await this.downloadObj(debugCert.certObjectId)
        const debugCertUrl = result.urlsInfo[0].newUrl
        const certPath = await this.dh.downloadFile(debugCertUrl, "xiabai-debug.cer")
        console.log("url", result.urlsInfo[0].newUrl)
        result = await this.deviceList()
        let deviceIds = result.list.map(d=>d.id)
        if(deviceIds.length == 0){
            let device = this.cmd.deviceList()
            if (device.length == 0) {
              throw new Error("请连接手机")
            }
            const udid = await this.cmd.getUdid(null)
            result = await this.createDevice("xiaobai-device", udid)
        }
        result = await this.createProfile("xiaobai-debug", debugCert.id, packageName, deviceIds)
        const profilePath = await this.dh.downloadFile(result.provisionFileUrl, "xiabai-debug.p7b")
        console.log("profile", result.provisionFileUrl)
        await this.cmd.signHap({
            keystoreFile:"store/xiaobai.p12",
            keystorePwd: "xiaobai123",
            keyAlias:"xiaobai",
            certFile: certPath,
            profilFile: profilePath,
            inFile: "entry-default-unsigned.hap",
            outFile: "./singned.hap"        
        })
       
        await this.cmd.sendAndInstall(null, "./singned.hap")
        
    }

}









module.exports = {
    EcoService
}