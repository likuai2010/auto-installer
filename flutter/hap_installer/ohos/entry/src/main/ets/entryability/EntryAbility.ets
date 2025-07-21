
import { FlutterAbility, FlutterEngine, JSONMethodCodec, MethodChannel } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import { fileUri } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';

export default class EntryAbility extends FlutterAbility {
  chanel?: MethodChannel;
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    this.chanel = new MethodChannel(flutterEngine.dartExecutor, "com.xiaobai.hap_instaler/openFile");
  }
  openFile(){

    this.chanel?.invokeMethod("openFile", {url: "test"},{
      success:() =>{
        console.log('openFile', "success");
      },
      error: ()=>{
        console.log('openFile', "error");
      },
      notImplemented: ()=>{
        console.log('openFile', "notImplemented");
      }
    });
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    super.onNewWant(want,launchParams)
    let uri = want.uri;
    if (uri && uri != "") {
      this.sendFileUrl(uri)
    }
  }

  async sendFileUrl(targetUri: string){
    console.log('openFile', 'onNewWant' + targetUri);
    const sl = targetUri.split("/")
    let hapPath = this.context.filesDir + "/" + sl[sl.length - 1].trim()
    await fs.copy(targetUri, fileUri.getUriFromPath(hapPath))
    this.chanel?.invokeMethod("openFile", hapPath);
  }
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    await super.onCreate(want, launchParam)
    let uri = want.uri;
    if (uri && uri != "") {
      this.sendFileUrl(uri)
    }
  }
}
