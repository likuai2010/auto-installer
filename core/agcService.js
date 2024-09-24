const { net } = require('electron')

class AgcService{

    base(url, headers) {
        const request = net.request({
            url,
            method:"POST",
            headers,
            
        })
        request.on('response', (response) => {
            console.log(`STATUS: ${response.statusCode}`)
            response.on('data', (chunk) => {
              console.log(`BODY: ${chunk}`)
            })
            response.on('end', () => {
              console.log('No more data in response.')
            })
          })
          const data = JSON.stringify({
                fromPage: 1,
                pageSize: 20,
                queryType: 1
            });
            request.write(data);
            request.end();
    }
    get(cookie){
        let headers = {
            "agcteamid":"2850086000506643987",
            "appid":"5765880207855175251",
            "content-type":"application/json",
            "Cookie":cookie,
            "x-hd-csrf":"645D1FA8BC027A50A48F0842EF97658BA5FE002FC9F8FB79A6"
        }
        console.error("cookie", cookie)
        this.base("https://agc-drcn.developer.huawei.com/agc/edge/amis/version-manage/v1/app/test/version/list",headers )
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