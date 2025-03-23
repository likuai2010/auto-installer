import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ohos_adapter_platform_interface.dart';

/// An implementation of [OhosAdapterPlatform] that uses method channels.
class MethodChannelOhosAdapter extends OhosAdapterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ohos_adapter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  bool get isOhos {
    return true;
  }

  @override
  Future<void> openUrl(String url) async {
    await methodChannel.invokeMethod<void>('openUrl', {"url": url});
  }

  @override
  Future<String?> selectFile() async {
    return await methodChannel.invokeMethod<String>('selectFile');
  }

  @override
  Future<String?> tempDir() async {
    return await methodChannel.invokeMethod<String>('tempDir');
  }

  @override
  Future<String?> appDir() async {
    return await methodChannel.invokeMethod<String>('appDir');
  }
}
