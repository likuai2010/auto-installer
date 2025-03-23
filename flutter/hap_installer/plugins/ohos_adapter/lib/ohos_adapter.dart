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

  Future<String?> selectFile() {
    return OhosAdapterPlatform.instance.selectFile();
  }

  Future<String?> tempDir() {
    return OhosAdapterPlatform.instance.tempDir();
  }

  Future<String?> appDir() {
    return OhosAdapterPlatform.instance.appDir();
  }
}

final ohosAdapter = OhosAdapter();
