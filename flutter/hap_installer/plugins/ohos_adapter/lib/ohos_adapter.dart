import 'ohos_adapter_platform_interface.dart';

class OhosAdapter {
  Future<String?> getPlatformVersion() {
    return OhosAdapterPlatform.instance.getPlatformVersion();
  }

  Future<bool> isOhos() {
    return OhosAdapterPlatform.instance.isOhos();
  }

  Future<void> openUrl(String url) {
    return OhosAdapterPlatform.instance.openUrl(url);
  }

  Future<String?> sleectFile() {
    return OhosAdapterPlatform.instance.sleectFile();
  }
}
