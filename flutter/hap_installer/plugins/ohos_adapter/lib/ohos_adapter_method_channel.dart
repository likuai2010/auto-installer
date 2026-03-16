import 'dart:io';

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
    return Platform.operatingSystem == "ohos";
  }

  @override
  Future<void> openUrl(String url) async {
    await methodChannel.invokeMethod<void>('openUrl', {"url": url});
  }

  @override
  Future<String?> selectFile(List<String> filter) async {
    return await methodChannel
        .invokeMethod<String>('selectFile', {"filter": filter});
  }

  @override
  Future<String?> tempDir() async {
    return await methodChannel.invokeMethod<String>('tempDir');
  }

  @override
  Future<String?> appDir() async {
    return await methodChannel.invokeMethod<String>('appDir');
  }

  @override
  Future<String?> hdcCmd(String cmd) async {
    return await methodChannel.invokeMethod<String>('hdcCmd', {"args": cmd});
  }
  @override
  Future<String?> deviceType() async {
      return await methodChannel.invokeMethod<String>('deviceType');
  }
  @override
  Future<bool?> hasJit() async {
    return await methodChannel.invokeMethod<bool>('hasJit');
  }
  @override
  Future<String?> signCmd(
    String cmd,
  ) async {
    return await methodChannel.invokeMethod<String>('signCmd', {"args": cmd});
  }

  @override
  Future<void> startServer() async {
    methodChannel.invokeMethod<void>('startServer');
  }
  @override
  Future<void> externalCmd(String device, String cmd) async {
    return await methodChannel
        .invokeMethod<void>('externalCmd', {"device": device, "cmd": cmd});
  }

  @override
  Future<String?> getLocalKey(String key) async {
    return await methodChannel.invokeMethod<String>('getKey', {
      "key": key,
    });
  }

  @override
  Future<void> setLocalKey(String key, String value) async {
    return await methodChannel
        .invokeMethod<void>('setKey', {"key": key, "value": value});
  }
  @override
  Future<bool> canOpenLink(String link) async {
    return await methodChannel
        .invokeMethod<bool>('canOpenLink', {"link": link}) ??  false;
  }
}
