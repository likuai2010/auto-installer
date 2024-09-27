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
    hdc = "tools/toolchains/hdc"
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
    async signHap(){
        let javaPath = 'java'
        let jarPath = 'jar'
        let cmd = `java -jar jar  sign-app -mode localSign -keyAlias "oh-app1-key-v1" -appCertFile "D:\OH\app-release-cert.cer" -profileFile "D:\OH\signed-profile.p7b" -inFile "D:\OH\app1-unsigned.hap" -signAlg SHA256withECDSA  -keystoreFile  "D:\OH\app-keypair.jks" -keystorePwd ****** -outFile "D:\OH\app1-signed.hap -compatibleVersion 8" -signCode "1"`
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