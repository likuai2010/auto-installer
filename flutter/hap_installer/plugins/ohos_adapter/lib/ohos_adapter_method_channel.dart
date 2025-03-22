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
  Future<bool> isOhos() async {
    return true;
  }

  @override
  Future<void> openUrl(String url) async {
    await methodChannel.invokeMethod<void>('openUrl');
  }

  @override
  Future<String?> sleectFile() async {
    return await methodChannel.invokeMethod<String>('sleectFile');
  }
}
