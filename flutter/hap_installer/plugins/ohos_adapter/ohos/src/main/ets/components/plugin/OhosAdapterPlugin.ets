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
import { addAndUpdateEvent, initMgr } from './CalendarUtils';
import { calendarManager } from '@kit.CalendarKit';


/** OhosAdapterPlugin **/
export default class OhosAdapterPlugin implements FlutterPlugin, AbilityAware, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private cacheSelfHapTask: Promise<string> | null = null;
  binding: AbilityPluginBinding | null  = null;
  constructor() {

  }
  private mgr?: calendarManager.CalendarManager = undefined

  async onAttachedToAbility(binding: AbilityPluginBinding): Promise<void> {
    this.binding = binding;
    const  context = this.binding!.getAbility().context;
    this.mgr = await initMgr(context);
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

  private addSelfHapCandidate(candidates: string[], candidate: string): void {
    if (candidate && !candidates.includes(candidate)) {
      candidates.push(candidate);
    }
  }

  private collectSelfHapFiles(candidate: string, depth: number, files: string[], diagnostics: string[]): void {
    if (files.length >= 16) return;
    try {
      const stat = fs.statSync(candidate);
      if (stat.isFile()) {
        if (candidate.toLowerCase().endsWith('.hap') && stat.size > 0 && !files.includes(candidate)) {
          files.push(candidate);
        }
        return;
      }
      if (!stat.isDirectory() || depth === 0) return;
      const names = fs.listFileSync(candidate, { recursion: false });
      names.sort((left: string, right: string): number => {
        const leftEntry = left.toLowerCase().includes('entry');
        const rightEntry = right.toLowerCase().includes('entry');
        if (leftEntry !== rightEntry) return leftEntry ? -1 : 1;
        return left.localeCompare(right);
      });
      // Installation directories are small; never recursively walk an arbitrary tree.
      for (const name of names.slice(0, 64)) {
        if (name === '.' || name === '..') continue;
        const child = candidate.replace(/\/$/, '') + '/' + name.replace(/^\//, '');
        this.collectSelfHapFiles(child, depth - 1, files, diagnostics);
      }
    } catch (err) {
      diagnostics.push(candidate + ': ' + (err as Error).message);
    }
  }

  private async cacheSelfHap(context: common.UIAbilityContext): Promise<string> {
    const candidates: string[] = [];
    const diagnostics: string[] = [];
    const currentModule = context.currentHapModuleInfo;
    if (currentModule) {
      this.addSelfHapCandidate(candidates, currentModule.codePath);
    }
    try {
      const info = await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE);
      for (const module of info.hapModulesInfo) {
        if (module.type === bundleManager.ModuleType.ENTRY) {
          this.addSelfHapCandidate(candidates, module.codePath);
        }
      }
    } catch (err) {
      diagnostics.push('获取模块信息: ' + (err as Error).message);
    }
    this.addSelfHapCandidate(candidates, context.bundleCodeDir);
    this.addSelfHapCandidate(candidates, '/data/storage/el1/bundle');

    const sources: string[] = [];
    for (const candidate of candidates) {
      this.collectSelfHapFiles(candidate, 2, sources, diagnostics);
    }
    const targetDir = context.filesDir + '/self-renewal';
    const targetPath = targetDir + '/base.hap';
    const pendingPath = targetPath + '.pending';
    for (const source of sources) {
      if (source === targetPath || source === pendingPath) continue;
      try {
        let targetDirExists = false;
        try {
          targetDirExists = fs.accessSync(targetDir);
        } catch (err) {
          diagnostics.push('检查缓存目录: ' + (err as Error).message);
        }
        if (!targetDirExists) {
          await fs.mkdir(targetDir, true);
        }
        const installed = fs.statSync(source);
        await fs.copyFile(source, pendingPath);
        const copied = fs.statSync(pendingPath);
        if (!copied.isFile() || copied.size === 0 || copied.size !== installed.size) {
          throw new Error('安装包复制不完整');
        }
        await fs.rename(pendingPath, targetPath);
        if (fs.statSync(targetPath).size !== installed.size) {
          throw new Error('安装包缓存大小不一致');
        }
        return targetPath;
      } catch (err) {
        diagnostics.push(source + ': ' + (err as Error).message);
      } finally {
        try {
          if (fs.accessSync(pendingPath)) await fs.unlink(pendingPath);
        } catch (err) {
          console.warn('清理自身安装包临时文件失败: ' + (err as Error).message);
        }
      }
    }
    throw new Error('无法读取本应用安装包，候选: ' + candidates.join(', ') +
      (diagnostics.length > 0 ? '；原因: ' + diagnostics.slice(-3).join('；') : '；未找到非空HAP文件'));
  }

  downloadDir: string | undefined = undefined
  async  onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    const  context = this.binding!.getAbility().context;
    if (call.method === 'cacheSelfHap') {
      const task = this.cacheSelfHapTask ?? this.cacheSelfHap(context as common.UIAbilityContext);
      this.cacheSelfHapTask = task;
      try {
        result.success(await task);
      } catch (err) {
        result.error('SELF_HAP_CACHE_FAILED', (err as Error).message, null);
      } finally {
        if (this.cacheSelfHapTask === task) this.cacheSelfHapTask = null;
      }
      return;
    }
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
    else if(call.method == "addCalendar") {

      if(this.mgr){
        let id = await addAndUpdateEvent(this.mgr, call.argument("startTime") as number, call.argument("appName") as string)
        result.success(id);
      }else{
        result.success(0);
      }
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
      try {
        const keyDir = this.downloadDir ?? context.filesDir;
        const hdcKeyPub = await fileIo.readText(keyDir + "/hdckey.pub")
        const hdckey = await fileIo.readText(keyDir + "/hdckey")
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
        await context.startAbility(want);
        result.success(null);
      } catch (err) {
        result.error('SELF_INSTALL_HANDOFF_FAILED', (err as Error).message, null);
      }
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
