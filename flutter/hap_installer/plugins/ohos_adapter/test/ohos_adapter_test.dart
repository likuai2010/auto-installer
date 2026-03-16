import 'package:flutter_test/flutter_test.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:ohos_adapter/ohos_adapter_platform_interface.dart';
import 'package:ohos_adapter/ohos_adapter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOhosAdapterPlatform
    with MockPlatformInterfaceMixin
    implements OhosAdapterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<String?> appDir() {
    // TODO: implement appDir
    throw UnimplementedError();
  }
  
  @override
  Future<String?> hdcCmd(String cmd) {
    // TODO: implement hdcCmd
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement isOhos
  bool get isOhos => throw UnimplementedError();
  
  @override
  Future<void> openUrl(String url) {
    // TODO: implement openUrl
    throw UnimplementedError();
  }
  
 
  
  @override
  Future<String?> signCmd(String cmd) {
    // TODO: implement signCmd
    throw UnimplementedError();
  }
  
  @override
  Future<void> startServer() {
    // TODO: implement startServer
    throw UnimplementedError();
  }
  
  @override
  Future<String?> tempDir() {
    // TODO: implement tempDir
    throw UnimplementedError();
  }
  
  @override
  Future<String?> deviceType() {
    // TODO: implement deviceType
    throw UnimplementedError();
  }
  
  @override
  externalCmd(String device, String cmd) {
    // TODO: implement externalCmd
    throw UnimplementedError();
  }
  
  @override
  Future<String?> getLocalKey(String key) {
    // TODO: implement getLocalKey
    throw UnimplementedError();
  }
  
  @override
  Future<bool?> hasJit() {
    // TODO: implement hasJit
    throw UnimplementedError();
  }
  
  @override
  Future<String?> selectFile(List<String> filter) {
    // TODO: implement selectFile
    throw UnimplementedError();
  }
  
  @override
  Future<void> setLocalKey(String key, String value) {
    // TODO: implement setLocalKey
    throw UnimplementedError();
  }
}

void main() {
  final OhosAdapterPlatform initialPlatform = OhosAdapterPlatform.instance;

  test('$MethodChannelOhosAdapter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOhosAdapter>());
  });

  test('getPlatformVersion', () async {
    OhosAdapter ohosAdapterPlugin = OhosAdapter();
    MockOhosAdapterPlatform fakePlatform = MockOhosAdapterPlatform();
    OhosAdapterPlatform.instance = fakePlatform;

    expect(await ohosAdapterPlugin.getPlatformVersion(), '42');
  });
  test('test args parse', (){
    const cmd = 'signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile "111 11" -profileFile "222 22" -inFile "333 22" -signAlg SHA256withECDSA -keystoreFile "222 22" -outFile "11 11" -signCode 1';
    RegExp regExp = RegExp(r'([^\s"]+)|"([^"]*)"');
    List<String> matches = [];
    for (var match in regExp.allMatches(cmd)) {
      matches.add(match.group(2) ?? match.group(1)!);
    }
    print("signHap $matches");
  });
}
