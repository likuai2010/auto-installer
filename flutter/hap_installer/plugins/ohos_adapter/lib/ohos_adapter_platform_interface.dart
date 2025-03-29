import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ohos_adapter_method_channel.dart';

abstract class OhosAdapterPlatform extends PlatformInterface {
  /// Constructs a OhosAdapterPlatform.
  OhosAdapterPlatform() : super(token: _token);

  static final Object _token = Object();

  static OhosAdapterPlatform _instance = MethodChannelOhosAdapter();

  /// The default instance of [OhosAdapterPlatform] to use.
  ///
  /// Defaults to [MethodChannelOhosAdapter].
  static OhosAdapterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OhosAdapterPlatform] when
  /// they register themselves.
  static set instance(OhosAdapterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> openUrl(String url) {
    throw UnimplementedError('openUrl() has not been implemented.');
  }

  Future<String?> selectFile(List<String> filter) async {
    throw UnimplementedError('selectFile() has not been implemented.');
  }

  bool get isOhos => false;

  Future<String?> tempDir() async {}

  Future<String?> appDir() async {}
  Future<String?> hdcCmd(String cmd) async {}

  Future<String?> signCmd(String cmd) async {}
  Future<void> startServer() async {}

  Future<void> setLocalKey(String key, String value) async {}
  Future<String?> getLocalKey(String key) async {
    throw UnimplementedError('getLocalUrl() has not been implemented.');
  }
}
