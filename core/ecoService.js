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
                "oauth2Token": this.oauth2Token || '',
                teamId: this.agcteamid || '',
                uid: this.userId || '',
                ...headers
            },
        })
        console.error('baseGet url is ', url)
    return new Promise((resolve, reject)=>{
            request.on('response', (response) => {
                response.on('data', (chunk) => {
                    try{
                        let data = JSON.parse(chunk.toString())
                        if (data.ret?.code == 0){
                            resolve(data)
                        } else if(data.ret) {
                            reject(new Error(data.ret.msg))
                        }else{
                            resolve(data)
                        }
                    }catch(e){
                        console.error('baseGet response', e.message || e)
                        resolve(chunk.toString())
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
    agcteamid = ""
    userId = ""
    nickName = ""
    async initCookie(authInfo){
        this.oauth2Token = authInfo.accessToken
        this.userId = authInfo.userId
        this.agcteamid = authInfo.userId
        this.nickName = authInfo.nickName
        console.log("authInfo", authInfo)
    }
    async getTokenBytempToken(tempToken){
        let token = tempToken.split("&").find(p=>p.indexOf("tempToken=") > -1)
        token = token.replace("tempToken=","")
        let uri = `https://cn.devecostudio.huawei.com/authrouter/auth/api/temptoken/check?site=CN&tempToken=${token}&appid=1007&version=0.0.0`
        let result = await this.base(uri, {}, {}, "GET")
        let jwtToken = result
        uri = `https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check`
        result = await this.base(uri, {},{refresh:false, jwtToken: jwtToken}, "GET")
        console.debug("userInfo", result.userInfo)
        return result.userInfo
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
    deleteCertList(certIds){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/delete"
        return this.base(uri, {"certIds":certIds}, {}, "DELETE")
    }
    // type 1 debug 2 prod
    createCert(name, type, csr){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/add"
        let params = {"csr":csr,"certName":name,"certType":type}
        return this.base(uri, params, {})
    }
   
    createProfile(name, certId, packageName="com.xiaobai.testgo", deviceIds=[]){
        let uri = "https://connect-api.cloud.huawei.com/api/cps/provision-manage/v1/ide/test/provision/add"
        let params = {
            "provisionName": name,
            "aclPermissionList": [
                "ohos.permission.READ_AUDIO",
                "ohos.permission.WRITE_AUDIO",
                "ohos.permission.READ_IMAGEVIDEO",
                "ohos.permission.WRITE_IMAGEVIDEO",
                "ohos.permission.SHORT_TERM_WRITE_IMAGEVIDEO",
                "ohos.permission.READ_CONTACTS",
                "ohos.permission.WRITE_CONTACTS",
                "ohos.permission.SYSTEM_FLOAT_WINDOW",
                "ohos.permission.ACCESS_DDK_USB",
                "ohos.permission.ACCESS_DDK_HID",
                "ohos.permission.INPUT_MONITORING",
                "ohos.permission.INTERCEPT_INPUT_EVENT",
                "ohos.permission.READ_PASTEBOARD"
            ],
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

  

}









module.exports = {
    EcoService
}