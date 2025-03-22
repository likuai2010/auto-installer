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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
