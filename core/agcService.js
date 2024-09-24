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
            "x-hd-csrf":"21063C854C72DAAA2C53DC98E75A521794552879259CE1DD93"
        }
        console.error("cookie", cookie)
        this.base("https://agc-drcn.developer.huawei.com/agc/edge/amis/version-manage/v1/app/test/version/list",headers )
    }   
}

function getCookie(){

}
module.exports = {
    AgcService
}