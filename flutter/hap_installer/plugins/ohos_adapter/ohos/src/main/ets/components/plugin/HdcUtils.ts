import { hdcCmd, hdcServer } from 'libhdc_z.so';

import { unHap, unApp } from 'libunhap.so';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import { javaCmd } from 'libjavacmd.so';
import { go_sign } from 'libgo_signer.so';
import signtool from 'libsigntool.so';

class HdcUtils{
  startHdc(context:common.Context){
    hdcServer(context.tempDir + "/")
  }
  async hdcCmd(context: common.Context, cmd: string): Promise<string>{
    let outPath = context.tempDir + "/hdc.out";
    return new Promise((res, rej)=>{
      fs.unlink(outPath)
      hdcCmd(cmd, context.tempDir + "/", async ()=>{
        try {
          let out = await fs.readText(outPath)
          res(out)
        }catch (e) {
          res(e.message)
        }
      })
    })
  }
  async signCmd(context: common.Context, cmd: string): Promise<string>{
    let outPath = context.tempDir + "/sign.out";
    return new Promise((res,rej)=>{
      fs.unlink(outPath)
      signtool.signHap(cmd, async (ret)=>{
        if(ret == 0){
          res("签名成功")
        }else{
          try {
            let out = await fs.readText(outPath)
            res(out)
          }catch (e) {
            res(e.message)
          }
        }
      })
    })
  }
  async GoSign( cmd: string): Promise<string>{

    return new Promise((res, rej)=>{
      console.debug("signCmd", cmd)
      go_sign(
        cmd.replace("signtool", ""), async (out)=>{
        try {
          if(out.indexOf("success") > -1){
            res("签名成功")
          } else {
            res(out)
          }
        }catch (e) {
          res(e.message)
        }
      })
    })
  }
  async JavaSign(context: common.Context, cmd: string, jarPath: String | undefined = undefined): Promise<string>{
    let outPath = context.tempDir + "/output.txt";
    let errorPath = context.tempDir + "/error.txt";
    return new Promise((res, rej)=>{
      fs.unlink(outPath)
      let jar = `${jarPath ? jarPath : (context.resourceDir)}/hap-sign-tool.jar`;
      javaCmd(
        `-Djava.class.path=${context.resourceDir}:${jar}`,
        "com/ohos/hapsigntool/HapSignTool",
        cmd.replace("signtool", ""), async ()=>{
          try {
            let out = await fs.readText(outPath)
            let error = await fs.readText(errorPath)
            if(out.indexOf("success") > -1){
              res("签名成功")
            } else {
              res(out + error)
            }
          }catch (e) {
            res(e.message)
          }
      })
    })
  }


  async unHapCmd(source: string, file:string, out: string): Promise<string>{
    return new Promise((res, rej)=>{
      unHap(source,file, out)
      res("")
    })
  }


  async getPackageInfo(context: common.Context){
    let result = await this.hdcCmd(context, "hdc shell bm dump --all")
    let list = result.split("\n");
    list.shift();
    return list;
  }
}

export default new HdcUtils()