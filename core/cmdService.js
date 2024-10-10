const { exec } = require('child_process');
const path = require('node:path')
const fs = require('node:fs')
const { app } = require('electron');


class CmdService{
    hdc = "tools/toolchains/hdc"
    constructor(){
        if(process.platform !== "darwin"){
            let dev = app.isPackaged
            if(dev){
                this.JavaHome = path.join(path.dirname(app.getPath('exe')), "tools/jbr")
                this.SdkHome = path.join(path.dirname(app.getPath('exe')), "tools/toolchains")
            }else{
                this.JavaHome =  path.join(path.dirname(__dirname), "tools/jbr")
                this.SdkHome = path.join(path.dirname(__dirname), "tools/toolchains")
            }
           
        }else{
            this.JavaHome = path.dirname(app.getPath('exe')) + "/../tools/jbr/Contents/Home"
            this.SdkHome = path.dirname(app.getPath('exe'))  + "/../tools/toolchains"
        }
        this.hdc = this.SdkHome + "/hdc"
        this.sginJar = this.SdkHome + "/lib/hap-sign-tool.jar"
    }
    exeCmd(cmd, opt={}){
        return new Promise((resolve, reject)=>{
            exec(cmd,  {  ...opt }, (error, stdout, stderr) => {
                console.error(stderr, stdout)
                if (error) {
                    reject(error)
                }else{
                    resolve(stdout)
                }
            });
        })
    }
    
    async deviceList(){
        let result =  await this.exeCmd(`${this.hdc} list targets `)
        if (result.indexOf("[Empty]") > -1){
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
    async sendAndInstall( filePath, deviceIp){
        let devicekey = ""
        if (deviceIp && deviceIp !== "") 
            devicekey = deviceIp
        else {
            let device = await this.deviceList()
            if (device.length == 0) 
                throw new Error("请连接手机, 并开启开发者模式和usb调试!")
            devicekey = device[0].trim()
        }
        await this.sendFile(devicekey, filePath)
        await this.installHap(devicekey)
    }
    async sendFile(device = '127.0.0.1:5557', filePath = "entry-default-unsigned.hap",){
        let deviceT = ""
        if (device) {
            deviceT = "-t " + device
        }
        await this.exeCmd(`${this.hdc} ${deviceT} shell mkdir -p data/local/tmp/hap`)
        let result =  await this.exeCmd(`${this.hdc} ${deviceT} file send ${filePath} data/local/tmp/hap/`)
        
        if(result.indexOf("finish") > -1)
            return true
        else 
            throw Error("安装失败: " + result)
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
            throw Error("安装失败: " + result)
    }
    
    async signHap(signConfig = {
        keystoreFile:"store/xiaobai.p12",
        keystorePwd: "123456Abc",
        keyAlias:"xiaobai",
        certFile: "store/xiaobai.cer",
        profilFile: "store/testgoDebug.p7b",
        inFile: "D:/pack.hap",
        outFile: "./singned.hap"        
    }){
        let javaPath = path.join(this.JavaHome, "/bin/java")
        let signParam = `-mode "localSign" -keyAlias "${signConfig.keyAlias}" -appCertFile "${signConfig.certFile}" -profileFile "${signConfig.profilFile}" -inFile "${signConfig.inFile}" -signAlg "SHA256withECDSA"   -keystoreFile  "${signConfig.keystoreFile}" -keystorePwd "${signConfig.keystorePwd}" -keyPwd "${signConfig.keystorePwd}" -outFile "${signConfig.outFile}" -signCode "1"`
        let cmd = `${javaPath} -jar ${this.sginJar}  sign-app ${signParam}`
        let result =  await this.exeCmd(cmd)
        console.log("signHap", result)
    }
    async createCsr(keystore, csrpath, alias="xiaobai", storepass="xiaobai123"){
        if (fs.existsSync(csrpath))
            return csrpath
        let keytool = this.JavaHome + "/bin/keytool"

        let prams = `${keytool} -certreq -alias ${alias} -keystore ${keystore} -storetype pkcs12 -file ${csrpath} -storepass ${storepass}`
        await this.exeCmd(prams)
        return csrpath
    }
    async readcsr(csrpath){
        const filePath = path.join(this.configDir || "", csrpath);
        const data = fs.readFileSync(filePath, 'utf8');
        return data
    }
    async createKeystore(keystore, storepass="xiaobai123", alias="xiaobai", cn="xiaobai"){
        if (fs.existsSync(keystore))
            return true
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
    async unpackApp(hapFilePath, outPath){
        let javaPath = this.JavaHome + "/bin/java"
        let unpackTool = this.SdkHome + "/lib/app_unpacking_tool.jar"
        let cmd = `${javaPath} -jar ${unpackTool} --mode app --app-path ${hapFilePath} --out-path ${outPath} --force true`
        await this.exeCmd(cmd)
    }
    async unpackHap(hapFilePath, outPath){
        let javaPath = this.JavaHome + "/bin/java"
        let unpackTool = this.SdkHome + "/lib/app_unpacking_tool.jar"
        let cmd = `${javaPath} -jar ${unpackTool} --mode hap --hap-path ${hapFilePath} --out-path ${outPath} --force true`
        await this.exeCmd(cmd)
    }
    //java -jar app_packing_tool.jar --mode hap  --json-path D:\out3\module.json --lib-path  D:\out3\libs --resources-path d:\out3\resources --ets-path d:\out3\ets --pack-info-path D:\out3\pack.info --index-path D:\out3\resources.index --force true --out-path D:\pack.hap

    async packHap(hapFilePath, outpath = "pack.hap"){
        let javaPath = this.JavaHome + "/bin/java"
        let unpackTool = this.SdkHome + "/lib/app_packing_tool.jar"
        let params = await new Promise((resolve, reject)=>{
            let params = ""
            fs.readdir(hapFilePath, (err, files) => {
                if (err) throw err;
                files.forEach(file => {
                    const fullPath = path.join(hapFilePath, file);
                    if(file == "resources.index"){
                        params += ` --index-path ${fullPath}`
                    }
                    else if(file == "pack.info"){
                        params += ` --pack-info-path ${fullPath}`
                    }
                    else if(file == "module.json"){
                        params += ` --json-path ${fullPath}`
                    }
                    else if (file == "libs"){
                        params += ` --lib-path ${fullPath}`
                    }
                    else{
                        params += ` --${file}-path ${fullPath}`
                    }
                });
                resolve(params)
            });
        })
        let cmd = `${javaPath} -jar ${unpackTool} --mode hap  ${params} --force true --out-path  ${outpath}`
        console.debug("packHap params", params)
        await this.exeCmd(cmd)
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
        // await cmd.ceraeteCsr("store/xiaobai.p12", "store/xioabi.csr")
        // const csr = await cmd.readcsr("store/xioabi.csr")
        // console.log(csr)
    }catch(e){
        console.error("error", e.message || e, e.stack)
    }
   
}
test()