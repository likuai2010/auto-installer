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
     sginJar = "tools/toolchains/lib/hap-sign-tool.jar"
    async signHap(signConfig = {
        keystoreFile:"store/xiaobai.p12",
        keystorePwd: "xiaobai123",
        keyAlias:"xiaobai",
        certFile: "store/xiaobai-debug.cer",
        profilFile: "store/xiaobai-debugDebug.p7b",
        inFile: "/Users/fiber/DevEcoStudioProjects/MyApplication/entry/build/default/outputs/default/entry-default-unsigned.hap",
        outFile: "./singned.hap"        
    }){
        let javaPath = 'java'
        let signParam = `-mode localSign -keyAlias "${signConfig.keyAlias}" -appCertFile "${signConfig.certFile}" -profileFile "${signConfig.profilFile}" -inFile "${signConfig.inFile}" -signAlg SHA256withECDSA  -keystoreFile  "${signConfig.keystoreFile}" -keystorePwd "${signConfig.keystorePwd}" -outFile "${signConfig.outFile} -compatibleVersion 8" -signCode "1"`
        let cmd = `${javaPath} -jar ${this.sginJar}  sign-app ${signParam}`
        let result =  await this.exeCmd(cmd)
        console.log("signHap", result)
    }
    async verifyApp(signConfig = {
        keystoreFile:"store/xiaobai.p12",
        keystorePwd: "xiaobai123",
        certFile: "",
        profilFile: "store/xiabai-debugDebug.p7b",
        inFile: "/Users/fiber/DevEcoStudioProjects/MyApplication/entry/build/default/outputs/default/entry-default-unsigned.hap",
        outFile: "./singned.hap",
        outCertChain:'./outCertChain.cer'        
    }){
        let javaPath = 'java'
        let signParam = ` -inFile "${signConfig.inFile}" -outCertChain "${signConfig.outCertChain}" -outProfile "${signConfig.profilFile}"`
        let cmd = `${javaPath} -jar ${this.sginJar} verify-app ${signParam}`
        let result =  await this.exeCmd(cmd)
        console.log("signHap", result)
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
    await cmd.signHap()
    //await cmd.verifyApp()
}
test()