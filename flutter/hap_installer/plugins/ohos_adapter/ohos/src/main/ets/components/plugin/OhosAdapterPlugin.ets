import {
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  AbilityAware
} from '@ohos/flutter_ohos';

import fs from '@ohos.file.fs';
import  { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import { common, Context, Want } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { hdcUtils as HdcUtils} from './HdcUtils';
import { deviceInfo } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';




/** OhosAdapterPlugin **/
export default class OhosAdapterPlugin implements FlutterPlugin, AbilityAware, MethodCallHandler {
  private channel: MethodChannel | null = null;
  binding: AbilityPluginBinding | null  = null;
  constructor() {
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.binding = binding;
  }

  onDetachedFromAbility(): void {
  }


  getUniqueClassName(): string {
    return "OhosAdapterPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "ohos_adapter");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }
  async initDownloadDir(context: Context) : Promise<string | undefined>{
    try {
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      const path = await documentViewPicker.save(documentSaveOptions)
      const dir = new fileUri.FileUri(path[0]).path;
      return dir;
    } catch (e) {
      return undefined;
    }
  }
  downloadDir: string | undefined = undefined
  async  onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    const  context = this.binding!.getAbility().context;
    if(!this.downloadDir){
      this.downloadDir = await this.initDownloadDir(context);
    }
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if(call.method == "openUrl") {
      let url = call.argument("url") as string;
      requestBackground()
      openUrl(url, context)
      result.success("")
    }
    else if(call.method == "selectFile") {
      let filter = call.argument("filter") as string[];
      selectFile(context, filter).then((f)=>{
        result.success(f)
      })
    }
    else if(call.method == "tempDir") {
      result.success(this.downloadDir ?? context.tempDir)
    }
    else if(call.method == "deviceType") {
      result.success(deviceInfo.deviceType)
    }
    else if(call.method == "hasJit") {
      result.success(false)
    }
    else if(call.method == "appDir") {
      result.success(this.downloadDir ?? context.filesDir)
    }
    else if(call.method == "startServer") {
      HdcUtils.startHdc(this.downloadDir ?? context.filesDir).then((res)=>{
        result.success(res)
      })
    }
    else if(call.method == "canOpenLink") {
      try {
        let data: boolean = bundleManager.canOpenLink(call.argument("link"));
        console.info('testTag', 'canOpenLink successfully: %{public}s', JSON.stringify(data));
        result.success(true)
      } catch (err) {
        let message = (err as BusinessError).message;
        console.error('testTag', 'canOpenLink failed: %{public}s', call.argument("link"), message);
        result.success(false)
      }
    }
    else if(call.method == "externalCmd") {
      const hdcKeyPub = await fileIo.readText(this.downloadDir + "/hdckey.pub")
      const hdckey = await fileIo.readText(this.downloadDir + "/hdckey")
      let want: Want = {
        deviceId: '', // 空表示本地设备
        bundleName: 'com.xiaobai.autoinstaller',
        abilityName: 'EntryAbility',
        // 如果需要传参
        parameters: {
          device:  call.argument("device") as string,
          cmd:  call.argument("cmd") as string,
          "pub":hdcKeyPub,
          "key": hdckey
        }
      };
      context.startAbility(want).then((res)=>{
          result.success(res)
      }).catch((err: Error)=>{
          result.success(err.message)
      })
    }
    else if(call.method == "hdcCmd") {
      const args = call.argument("args") as string;
      HdcUtils.hdcCmd(context, args).then((res)=>{
        result.success(res)
      })
    }
     else if(call.method == "signCmd") {
      const args = call.argument("args") as string;

      HdcUtils.GoSign(args).then((res)=>{
        result.success(res)
      })
    }  else if(call.method == "getKey") {
      let ret = preferences.getPreferencesSync(context,{name:"hap_installer"})
      const key = call.argument("key") as string;
      result.success(ret.getSync(key,"127.0.0.1:12345") as string)
    } else if(call.method == "setKey") {
      let ret = preferences.getPreferencesSync(context,{name:"hap_installer"})
      const key = call.argument("key") as string;
      const value = call.argument("value") as string;
      ret.putSync(key, value);
      ret.flush().then(()=>{
        result.success(null)
      });
    }
    else {
      result.notImplemented()
    }
  }
}

async function selectFile(context: common.Context, filter: string[] | null = null) { // 需确保 context 由 UIAbilityContext 转换而来
  try {
    let documentSelectOptions = new picker.DocumentSelectOptions();
    documentSelectOptions.maxSelectNumber =1;
    documentSelectOptions.fileSuffixFilters = filter ?? ["hap","app","hsp"]
    let documentPicker = new picker.DocumentViewPicker(context);
    const documentSelectResult = await documentPicker.select(documentSelectOptions)
    console.info('testTag' + JSON.stringify(documentSelectResult));
    if(documentSelectResult.length > 0){
      const targetUri = documentSelectResult[0]
      const sl = targetUri.split("/")
      let hapPath =  context.filesDir + "/" + sl[sl.length - 1].replace(/\s+/g, '_')
      await fs.copy(targetUri, fileUri.getUriFromPath(hapPath))
      console.info('testTag selectFile' + hapPath);
      return hapPath
    }
    return null;
  } catch (err) {
    console.error('testTag err: ' + err.message, err.stack);
    return null;
  }
}

export function  openUrl(url: string, context:common.Context): void{
  let want: Want = {
    action: 'ohos.want.action.viewData',
    // entities can be omitted.
    entities: ['entity.system.browsable'],
    uri: url
  };
  try {
    (context as common.UIAbilityContext).startAbility(want)
  } catch (paramError) {
    console.error("openUrl error",paramError)
  }
}

function requestBackground(){
   try {
      let delayInfo = backgroundTaskManager.requestSuspendDelay("open url", () => {
        console.info("Request suspension delay will time out.");
      })
      let taskId = delayInfo.requestId;
    } catch (error) {
      console.error(`requestSuspendDelay failed. code is ${error.code} message is ${error.message}`);
    }
}