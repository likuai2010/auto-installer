const { exec } = require('child_process');
const path = require('node:path')
const fs = require('node:fs')

class CmdService{
    constructor(){
        this.JavaHome = "tools/jbr/Contents/Home"
        this.SdkHome = "/Users/likuai/Library/Huawei/Sdk/openharmony/9/toolchains/"
    }
    exeCmd(cmd, opt={}){
        return new Promise((resolve, reject)=>{
            exec(cmd,  {  ...opt }, (error, stdout, stderr) => {
                if (error) {
                    reject(error)
                }else{
                    resolve(stdout)
                }
            });
        })
    }
    hdc = "G:/git/auto-publish-harmonyos/tools/toolchains/hdc"
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
    async sendAndInstall(device, filePath){
        await this.sendFile(device, filePath)
        await this.installHap(device)
    }
    async sendFile(device = '127.0.0.1:5557', filePath = "entry-default-unsigned.hap",){
        let deviceT = ""
        if (device) {
            deviceT = "-t " + device
        }
        await this.exeCmd(`${this.hdc} ${deviceT} shell mkdir -p data/local/tmp/hap`)
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} file send ${filePath} data/local/tmp/hap/`)
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
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} shell bm install -p data/local/tmp/hap/singned.hap`)
        console.log("installHap", result)
        if(result.indexOf("successfully") > -1)
            return true
        else 
            return false
    }
    sginJar = "G:/git/auto-publish-harmonyos/tools/toolchains/lib/hap-sign-tool.jar"
    async signHap(signConfig = {
        keystoreFile:"store/xiaobai.p12",
        keystorePwd: "123456Abc",
        keyAlias:"xiaobai",
        certFile: "store/xiaobai.cer",
        profilFile: "store/testgoDebug.p7b",
        inFile: "D:/pack.hap",
        outFile: "./singned.hap"        
    }){
        let javaPath = this.JavaHome + "/bin/java"
        let signParam = `-mode "localSign" -keyAlias "${signConfig.keyAlias}" -appCertFile "${signConfig.certFile}" -profileFile "${signConfig.profilFile}" -inFile "${signConfig.inFile}" -signAlg "SHA256withECDSA"   -keystoreFile  "${signConfig.keystoreFile}" -keystorePwd "${signConfig.keystorePwd}" -keyPwd "${signConfig.keystorePwd}" -outFile "${signConfig.outFile}" -signCode "1"`
        let cmd = `${javaPath} -jar ${this.sginJar}  sign-app ${signParam}`
        let result =  await this.exeCmd(cmd)
        console.log("signHap", result)
    }
    async ceraeteCsr(keystore, csrpath, alias="xiaobai", storepass="xiaobai123"){
        let keytool = this.JavaHome + "/bin/keytool"
        let prams = `${keytool} -certreq -alias ${alias} -keystore ${keystore} -storetype pkcs12 -file ${csrpath} -storepass ${storepass}`
        await this.exeCmd(prams)
    }
    async readcsr(csrpath){
        const filePath = path.join(this.configDir || "", csrpath);
        const data = fs.readFileSync(filePath, 'utf8');
        return data
    }
    async createKeystore(keystore, storepass="xiaobai123", alias="xiaobai", cn="xiaobai"){
        let keytool = this.JavaHome + "/bin/keytool"
        let prams = `${keytool} -genkeypair -alias ${alias} -keyalg EC -sigalg SHA256withECDSA -dname "C=CN,O=HUAWEI,OU=HUAWEI IDE,CN=${cn}"  -keystore ${keystore} -storetype pkcs12 -validity 9125 -storepass ${storepass} -keypass ${storepass}`
        await this.exeCmd(prams)
    }

    async verifyApp(signConfig = {
        keystoreFile:"store/xiaobai.p12",
        keystorePwd: "123456Abc",
        profilFile: "store/testgoDebug.p7b",
        inFile: "./singned.hap",
        outFile: "./singned.hap",
        outCertChain:'./outCertChain.cer'        
    }){
        let javaPath = this.JavaHome + "/bin/java"
        let signParam = ` -inFile "${signConfig.inFile}" -outCertChain "${signConfig.outCertChain}" -outProfile "${signConfig.profilFile}"`
        let cmd = `${javaPath} -jar ${this.sginJar} verify-app ${signParam}`
        let result =  await this.exeCmd(cmd)
        console.log("signHap", result)
    }

    async buildApp(workdir="C://Users//Administrator//AppData//Roaming//auto-publish-harmonyos//codetestgo/"){
        try{
            const hvigorw = 'D:\\command-line-tools\\bin\\hvigorw'
            const ohpm = 'D:\\command-line-tools\\bin\\ohpm'
            // let result = await this.exeCmd(`${ohpm} install --all`, {
            //     cwd:workdir
            // })
            // console.log(result)
            let result2 = await this.exeCmd(`${hvigorw} assembleHap  -p product=default`, {
                cwd:workdir,
            })
            console.log(result2)
        }catch(e){
            console.error("buildApp", e.message || e, )
        }
    }

    unpack(){
        //java -jar app_unpacking_tool.jar --mode hap --hap-path D:\entry-default-unsigned.hap --out-path D:\out3 --force true
        //java -jar app_packing_tool.jar --mode hap  --json-path D:\out3\module.json --lib-path  D:\out3\libs --resources-path d:\out3\resources --ets-path d:\out3\ets --pack-info-path D:\out3\pack.info --index-path D:\out3\resources.index --force true --out-path D:\pack.hap
    }
}


module.exports = {
    CmdService
}
async function  test(){
    const cmd  = new CmdService()
    // let target = await cmd.deviceList()
    // console.log("tagetList",target)
    // await cmd.getUdid(null)
    // await cmd.signHap()
    // await cmd.verifyApp()
    // await cmd.sendFile(null, "./singned.hap")
    // await cmd.installHap(null)
    // await cmd.buildApp()
    try{
        // await cmd.createKeystore("store/xiaobai.p12")
        await cmd.ceraeteCsr("store/xiaobai.p12", "store/xioabi.csr")
        const csr = await cmd.readcsr("store/xioabi.csr")
        console.log(csr)
    }catch(e){
        console.error("error", e.message || e, e.stack)
    }
   
}
test()