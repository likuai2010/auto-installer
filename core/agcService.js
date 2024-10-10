const { net } = require('electron')
const { resolve } = require('path')

class AgcService{

    async base(url, data={}, headers={},  method = "POST") {
        const request = net.request({
            url,
            method: method,
            headers:{
                "content-type": "application/json",
                "Cookie": this.cookie,
                "x-hd-csrf": this.csrfToken,
                "agcteamid":this.agcteamid,
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
    cookie = ""
    csrfToken = ""
    agcteamid = "2850086000506643987"

    initCookie(cookieObj){
        const cookie = cookieObj.reduce((n, c) => {
            return (n += c.name + "=" + c.value + ";");
        }, "");
        this.cookie = cookie
        this.csrfToken = this.findCookieValue(cookieObj, "csrfToken")
    }
    findCookieValue(cookies, key){
        let ck = cookies.find((d)=>d.name == key)
        if(!ck)
            return undefined
        return ck.value
    }
    userInfo(){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/apios/invokeService/AGCHomePageOrchestration/getUserInfo"
        return this.base(uri, {"inputParameters":{}}, {})
    }

    userTeamList(){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/ups/user-permission-service/v1/user-team-list"
        return this.base(uri, {}, {}, "GET")
    }

    createProject(name){
        let uri = " https://agc-drcn.developer.huawei.com/agc/edge/cpms/project-management-service/v1/projects"
        let params  = {"name":name,"createDevProjectFlag":0,"createTenantProjectFlag":0,"createAllianceProjectFlag":1}
        return this.base(uri, params, {})
    }
    projectList(name){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cpms/project-management-service/v1/projectList"
        let params  = {"fromPage":1,"pageSize":40,"projectIds":[],"projectName":name,"queryFlag":1}
        return this.base(uri, params, {})
    }
    appList(){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/amis/app-manage/v1/app/list?maxReqCount=20&packageType=7&fromRecCount=1"
        let params  = {}
        return this.base(uri, params, {},"GET")
    }
    checkPackageName(packageName){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/amis/app-manage/v1/app/check/package-name"
        let params  = {"packageName": packageName}
        return this.base(uri, params, {})
    }
    createApp(appName, packageName, projectId){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/amis/app-manage/v1/app"
        let params  = {"appName":appName,"packageName":packageName,"defaultLang":"zh-CN","parentType":13,"createCountry":"CN","projectId":projectId,"packageType":7,"deviceTypes":[{"deviceType":4}],"appDevelopStatus":0,"installationFree":0,"createChannel":0}
        return this.base(uri, params, {})
    }
    orderApp(projectId, appId){
        let uri = `https://agc-drcn.developer.huawei.com/agc/edge/cpms/project-service/v1/services/order?projectId=${projectId}&appID=${appId}&serviceName=`
        let params  = {}
        return this.base(uri, params, {},"GET")
    }
    //https://agc-drcn.developer.huawei.com/agc/edge/aps/api-permission-service/v1/client-list?type=1&page=1&limit=20&productId=
    
    clientApiList(){
        let uri = `https://agc-drcn.developer.huawei.com/agc/edge/aps/api-permission-service/v1/client-list?type=1&page=1&limit=20&productId=`
        let params  = {}
        return this.base(uri, params, {},"GET")
    }

    createApi(name){
        let uri = `https://agc-drcn.developer.huawei.com/agc/edge/aps/api-permission-service/v1/client`
        let params  = {"name": name,"type":1,"roles":["com.huawei.connect.role.appmanager","com.huawei.connect.role.operator","com.huawei.connect.role.developer","com.huawei.connect.role.financial","com.huawei.connect.role.support"],"products":[]}
        return this.base(uri, params, {})
    }

    getCertList(){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/harmony-cert-manage/v1/cert/list"
        return this.base(uri, {}, {}, "GET")
    }

    deleteCertList(certId){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/harmony-cert-manage/v1/cert"
        return this.base(uri, {"certIds":[certId]}, {}, "DELETE")
    }
    // type 1 debug 2 prod
    createCert(name, type, csr){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/harmony-cert-manage/v1/cert"
        let params = {"csr":"-----BEGIN NEW CERTIFICATE REQUEST-----\nMIIBNTCB2wIBADBJMQkwBwYDVQQGEwAxCTAHBgNVBAgTADEJMAcGA1UEBxMAMQkw\r\nBwYDVQQKEwAxCTAHBgNVBAsTADEQMA4GA1UEAxMHeGlhb2JhaTBZMBMGByqGSM49\r\nAgEGCCqGSM49AwEHA0IABAp4GDxNyOOgPqa/Tzprp5IktG3i2x+PAUSgA/yUzRga\r\nm2vIF9Zlq2E89nIe+e1vLlki1SoChwfErVRSaYTpsjygMDAuBgkqhkiG9w0BCQ4x\r\nITAfMB0GA1UdDgQWBBT1Fjs3jS1SmLWZN+ACrGQMfLaqUDAKBggqhkjOPQQDAgNJ\r\nADBGAiEA8Edq1GI1CZZpMS/ECd5/tVgqFZqLCIv8bMORLE/wTPoCIQCrucAEi4hm\r\nQz016dCtv3taIi2Wiijk1Bo0LvIv7oNbKQ==\n-----END NEW CERTIFICATE REQUEST-----\n","certName":name,"certType":type}
        return this.base(uri, params, {})
    }
    profileList(packageName){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/provision-manage/v1/provision/list?start=1&pageSize=5&packageName=" + packageName
        return this.base(uri, {}, {}, "GET")
    }
    createProfile(name, certId, appId, type = 2, deviceIds=[]){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/provision-manage/v1/provision"
        let params  = {"provisionName":name,"certList":[certId],"provisionType":type,"appId":appId,"deviceList":deviceIds,"permissionList":[]}
        return this.base(uri, params, {})
    }
    downloadObj(objId, fileName){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cfs/file_service/v1/download/object/url?objectId="+objId+"&downloadFileName="+fileName
        let params  = {}
        return this.base(uri, params, {})
    }
    deviceList(name=""){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/device-manage/v1/device/list?start=1&pageSize=10&deviceName="+name
        return this.base(uri, {}, {}, "GET")
    }
    createDevice(deviceName, uuid){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/cps/device-manage/v1/device"
        let params  = {"deviceName":deviceName,"udid":uuid,"deviceType":4}
        return this.base(uri, params, {})
    }

    vesrionList(appid="5765880207855175251"){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/amis/version-manage/v1/app/test/version/list"
        let params = {
            fromPage: 1,
            pageSize: 20,
            queryType: 1
        }
        return this.base(uri, params, { appid })
    }
    GetApplistInitInfo(appid="5765880207855175251"){
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/apios/invokeService/AGCDistOrchestration/GetApplistInitInfo"
        let params = {"inputParameters":{"configNames":["app.distribution.device.config","app.package.name.sensitive.words","app.reserved.package.name.list","app.category.sensitive.words"],"checkedGroups":{"checkedGroups":[{"id":"noApk.whiteList","userType":1},{"id":"app.pc.user.allow.list","userType":1},{"id":"app.pc.internal.vmp.team.list","userType":1},{"id":"sysUrlCfg.whitelistUsers","userType":1},{"id":"app.cloudpc.user.whitelist","userType":1},{"id":"smart.cockpit.user.allow.list"},{"id":"harmony.app.support.2in1.allow.list"},{"id":"authorized.app.allow.operate.list"}]},"langType":"zh_CN","appDevelopStatus":1}}
        return this.base(uri, params, { appid })
    }
    groupCheck(){
        let headers = {
            "appid":"5765880207855175251",
        }
        let uri = "https://agc-drcn.developer.huawei.com/agc/edge/sfs/group-management/v1/group/check?id=harmony.reserved.package.name.allow.list&item=x.x.dddd"
        return this.base(uri, {}, headers, "GET")
    }

    
}


/**
 * 
 * {"inputParameters":{"configNames":["app.distribution.device.config","app.package.name.sensitive.words","app.reserved.package.name.list","app.category.sensitive.words"],"checkedGroups":{"checkedGroups":[{"id":"noApk.whiteList","userType":1},{"id":"app.pc.user.allow.list","userType":1},{"id":"app.pc.internal.vmp.team.list","userType":1},{"id":"sysUrlCfg.whitelistUsers","userType":1},{"id":"app.cloudpc.user.whitelist","userType":1},{"id":"smart.cockpit.user.allow.list"},{"id":"harmony.app.support.2in1.allow.list"},{"id":"authorized.app.allow.operate.list"}]},"langType":"zh_CN","appDevelopStatus":1}}
 * https://agc-drcn.developer.huawei.com/agc/edge/apios/invokeService/AGCDistOrchestration/GetApplistInitInfo
 * 
 * get
 * https://agc-drcn.developer.huawei.com/agc/edge/sfs/group-management/v1/group/check?id=harmony.reserved.package.name.allow.list&item=x.x.dddd
 * 
 * {"packageName":"x.x.dddd"}
 * https://agc-drcn.developer.huawei.com/agc/edge/amis/app-manage/v1/app/check/package-name
 * 
 * {"fromPage":1,"pageSize":100,"projectIds":[],"projectName":"","queryFlag":1}
 * https://agc-drcn.developer.huawei.com/agc/edge/cpms/project-management-service/v1/projectList
 * 
 * 
 * {"name":"xiaobai","createDevProjectFlag":0,"createTenantProjectFlag":0,"createAllianceProjectFlag":1}
 * https://agc-drcn.developer.huawei.com/agc/edge/cpms/project-management-service/v1/projects
 * 
 * 
 * {"appName":"12412","packageName":"x.x.dddd","defaultLang":"zh-CN","parentType":13,"createCountry":"CN","projectId":"388421841222508849","packageType":7,"deviceTypes":[{"deviceType":4}],"appDevelopStatus":0,"installationFree":0,"createChannel":0}
 * https://agc-drcn.developer.huawei.com/agc/edge/amis/app-manage/v1/app
 * 
 * GET
 * https://agc-drcn.developer.huawei.com/agc/edge/aps/api-permission-service/v1/client-list?type=1&page=1&limit=20&productId=
 * 
 * {"name":"1111","type":1,"roles":["com.huawei.connect.role.appmanager","com.huawei.connect.role.operator","com.huawei.connect.role.developer","com.huawei.connect.role.financial","com.huawei.connect.role.support"],"products":[]}
 * https://agc-drcn.developer.huawei.com/agc/edge/aps/api-permission-service/v1/client
 *  */ 








module.exports = {
    AgcService
}