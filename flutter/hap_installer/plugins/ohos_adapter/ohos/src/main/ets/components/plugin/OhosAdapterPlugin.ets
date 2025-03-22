import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

import  { picker } from '@kit.CoreFileKit';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

/** OhosAdapterPlugin **/
export default class OhosAdapterPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
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

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if(call.method == "openUrl") {
      //openUrl("")
      result.success(null)
    }
    else if(call.method == "selectFile") {
      //selectFile()
      result.success("")
    }
    else {
      result.notImplemented()
    }
  }
}

async function selectFile(context: common.Context) { // 需确保 context 由 UIAbilityContext 转换而来
  try {
    let documentSelectOptions = new picker.DocumentSelectOptions();
    let documentPicker = new picker.DocumentViewPicker(context);
    const documentSelectResult = documentPicker.select(documentSelectOptions)
    console.info('testTag' + JSON.stringify(documentSelectResult));
    if(documentSelectResult.length > 0){
      const targetUri = documentSelectResult[0]
      let hapPath =  context.filesDir + "/unsigned.hap"
      await fs.copy(targetUri, fileUri.getUriFromPath(hapPath))
      return hapPath
    }
    return null;
  } catch (error) {
    console.error('testTag err: ' +err.message, err.stack);
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
  }
}