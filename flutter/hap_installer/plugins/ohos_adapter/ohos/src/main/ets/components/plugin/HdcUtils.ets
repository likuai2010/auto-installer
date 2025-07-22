import { hdcCmd, hdcServer } from 'libhdc_z.so';
import { signHap } from 'libsigntool.so';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';

class HdcUtils{
  startHdc(context:common.Context){
    hdcServer(context.tempDir + "/")
  }
  async hdcCmd(context: common.Context, cmd: string): Promise<string>{
    let outPath = context.tempDir + "/hdc.out";
    return new Promise((res, rej)=>{
      fs.unlink(outPath)
      hdcCmd(cmd, context.tempDir + "/", async ()=>{
        let out = await fs.readText(outPath)
        res(out)
      })
    })
  }
  async signCmd(context: common.Context, cmd: string): Promise<string>{
    let outPath = context.tempDir + "/sign.out";
    return new Promise((res,rej)=>{
      fs.unlink(outPath)
      signHap(cmd, async ()=>{
        let out = await fs.readText(outPath)
        res(out)
      })
    })
  }
  async getPackageInfo(context: common.Context){
    let result = await this.hdcCmd(context, "hdc shell bm dump --all")
    let list = result.split("\n");
    list.shift();
    for (let info of list) {
      let pn = info.trim();
      let packageInfo = await this.hdcCmd(context, "hdc shell bm dump -n " + pn);
      console.error(packageInfo);
    }


  }
}

export default new HdcUtils()