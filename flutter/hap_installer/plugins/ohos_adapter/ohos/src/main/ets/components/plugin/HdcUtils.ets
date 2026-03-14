import hdc from 'libhdc_napi.so';

import { common } from '@kit.AbilityKit';
import { go_sign } from 'libgo_signer.so';
import fileIo from '@ohos.file.fs';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function backgroundStartDaemon(workPath: string): Promise<boolean> {
  // const filesToDelete = ["hdc.socket", "hdc.pid", "hdc.out", ".HDCServer.pid"];
  // filesToDelete.forEach(fileName => {
  //   let filePath = workPath + fileName;
  //   try {
  //     if (fileIo.accessSync(filePath)) {
  //       fileIo.unlinkSync(filePath);
  //     }
  //   } catch (e) {
  //     // Ignore cleanup errors
  //   }
  // });
  try {
    return hdc.startDaemon();
  }catch (e) {
    return false;
  }

}

@Concurrent
async function backgroundExecuteCommand(cmd: string): Promise<string> {
  return hdc.executeCommand(cmd);
}

export class HdcUtils{
  workPath: string = ""
  async startHdc(context:common.Context){
    try {
      let task = new taskpool.Task(backgroundStartDaemon, this.workPath);
      const retCode = await taskpool.execute(task);
      console.warn('startDaemon returned: %{public}s', JSON.stringify(retCode));
      const isSuccess = (typeof retCode === 'number' && retCode === 0) || retCode === true;
      return isSuccess;
    } catch (error) {
      console.error('startDaemon error: %{public}s', JSON.stringify(error));
    }
    return false;
  }
  async hdcCmd(context: common.Context, cmd: string): Promise<string>{
    let task = new taskpool.Task(backgroundExecuteCommand, cmd);
    return await taskpool.execute(task) as string;
  }
  async GoSign( cmd: string): Promise<string>{
    return new Promise((res, rej)=>{
      go_sign(
        cmd.replace("signtool", ""), async (out: string)=>{
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

  async unHapCmd(source: string, file:string, out: string): Promise<string>{
    return new Promise((res, rej)=>{
      res("")
    })
  }

}

export const hdcUtils =  new HdcUtils()