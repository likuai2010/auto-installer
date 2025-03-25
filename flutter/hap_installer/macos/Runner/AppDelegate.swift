import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  override func application(_ application: NSApplication, open urls: [URL]) {
    super.application(application, open: urls)
    
    if let url = urls.first {
      print("打开文件: \(url.path)")
      // 通过 MethodChannel 传递文件路径
       if let flutterVC = mainFlutterWindow?.contentViewController as? FlutterViewController {
            let methodChannel = FlutterMethodChannel(
                name: "com.example.hap_instaler/openFile",
                binaryMessenger: flutterVC.engine.binaryMessenger
            )
            // 通过 MethodChannel 发送文件路径到 Dart 端
            methodChannel.invokeMethod("handleFileOpen", arguments: ["filePath": url.path])
        }
    }
  }
}
