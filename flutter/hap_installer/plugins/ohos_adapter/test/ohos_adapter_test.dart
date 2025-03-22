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
}
