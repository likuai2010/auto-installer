const { exec } = require('child_process');

class CmdService{
    exeCmd(cmd){
        return new Promise((resolve, reject)=>{
            exec(cmd, (error, stdout, stderr) => {
                if (error) {
                    reject(error)
                }else{
                    resolve(stdout)
                }
            });
        })
    }
    hdc = "/Volumes/Macintosh\\ HD\\ 1/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc"
    async deviceList(){
        let result =  await this.exeCmd(`${this.hdc} list targets `)
        if (result == "[Empty]"){
            return []
        } else {
            return result.split("\n").filter(d=>d != '')
        }
    }
    async getUdid(device = '127.0.0.1:5557'){
        let deviceT = ""
        if (device) {
            deviceT = "-t " + device
        }
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} shell bm get --udid`)
        let udid = result.split("\n")[1]
        console.log(udid)
        return udid
    }
    async sendFile(device = '127.0.0.1:5557', filePath = "/Users/fiber/DevEcoStudioProjects/MyApplication/entry/build/default/outputs/default/entry-default-unsigned.hap",){
        let deviceT = ""
        if (device) {
            deviceT = "-t " + device
        }
         await this.exeCmd(`${this.hdc} ${deviceT} shell mkdir -p data/local/tmp/hap`)
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} file send ${filePath} data/local/tmp/hap/unsigned.hap`)
        console.log("sendFile",result)
        if(result.indexOf("finish") > -1)
            return true
        else 
            return false
    }
    async installHap(device = '127.0.0.1:5557'){
        let deviceT = ""
        if (device) 
            deviceT = "-t " + device
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} shell bm install -p data/local/tmp/hap/unsigned.hap`)
        console.log("installHap", result)
        if(result.indexOf("successfully") > -1)
            return true
        else 
            return false
    }
}


module.exports = {
    CmdService
}
async function  test(){
    const cmd  = new CmdService()
    let target = await cmd.deviceList()
    console.log("tagetList",target)
    await cmd.getUdid()
    await cmd.sendFile()
    await cmd.installHap()
}
test()