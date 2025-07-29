import { hdcCmd, hdcServer } from 'libhdc_z.so';
import { signHap } from 'libsigntool.so';
import { unHap, unApp } from 'libunhap.so';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import List from '@ohos.util.List';
import { javaCmd } from 'libjavacmd.so';

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
      signHap(cmd, async (ret)=>{
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

  async JavaSign(context: common.Context, jarPath: String, cmd: string): Promise<string>{
    let outPath = context.tempDir + "/sign.out";
    return new Promise((res, rej)=>{
      fs.unlink(outPath)
      javaCmd(
        `-Djava.class.path=/data/storage/el1/bundle/entry/resources/resfile:${jarPath}/hap-sign-tool.jar`,
        "com/ohos/hapsigntool/HapSignTool",
        cmd, ()=>{
      })
      signHap(cmd, async (ret)=>{
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