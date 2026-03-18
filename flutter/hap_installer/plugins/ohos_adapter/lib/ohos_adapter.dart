import 'ohos_adapter_platform_interface.dart';

class OhosAdapter {
  Future<String?> getPlatformVersion() {
    return OhosAdapterPlatform.instance.getPlatformVersion();
  }

  bool get isOhos {
    return OhosAdapterPlatform.instance.isOhos;
  }

  Future<void> openUrl(String url) {
    return OhosAdapterPlatform.instance.openUrl(url);
  }

  Future<String?> selectFile(List<String> filter) {
    return OhosAdapterPlatform.instance.selectFile(filter);
  }

  Future<String?> tempDir() {
    return OhosAdapterPlatform.instance.tempDir();
  }

  Future<String?> appDir() {
    return OhosAdapterPlatform.instance.appDir();
  }

  Future<String?> hdcCmd(String cmd) {
    return OhosAdapterPlatform.instance.hdcCmd(cmd);
  }

  Future<String?> signCmd(String cmd) {
    return OhosAdapterPlatform.instance.signCmd(cmd);
  }
  Future<String?> deviceType() {
    return OhosAdapterPlatform.instance.deviceType();
  }

  Future<bool?> hasJit(String cmd) {
    return OhosAdapterPlatform.instance.hasJit();
  }


  Future<void> startServer() {
    return OhosAdapterPlatform.instance.startServer();
  }
 Future<void> externalCmd(String device, String cmd) {
    return OhosAdapterPlatform.instance.externalCmd(device, cmd);
  }

  Future<void> setLocalUrl(String url) {
    return OhosAdapterPlatform.instance.setLocalKey("url", url);
  }
  Future<void> setLocalKey(String key,String value) async {
    await OhosAdapterPlatform.instance.setLocalKey(key, value);
  }
  Future<String> getLocalKey(String key) async {
    return await OhosAdapterPlatform.instance.getLocalKey(key) ?? "";
  }

  Future<bool> getFirstUse() async {
    return (await OhosAdapterPlatform.instance.getLocalKey("firstUse")) ==
        "ture";
  }

  Future<void> setFirstUse() {
    return OhosAdapterPlatform.instance.setLocalKey("firstUse", "ture");
  }

  Future<String?> getLocalUrl() {
    return OhosAdapterPlatform.instance.getLocalKey("url");
  }
  Future<bool> canOpenLink(String link) async {
    return await OhosAdapterPlatform.instance.canOpenLink(link);
  }
   Future<bool> addCalendar(String appName, int startTime) async {
    return await OhosAdapterPlatform.instance.addCalendar(appName, startTime) > 0;
  }
}

final ohosAdapter = OhosAdapter();
