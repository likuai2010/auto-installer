import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohos_adapter/ohos_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('ohos_adapter');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test(
      'self HAP copy returns the native private path without requesting storage',
      () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method != 'cacheSelfHap')
        throw StateError('Unexpected storage request');
      return '/data/storage/el2/base/haps/entry/files/self-renewal/base.hap';
    });
    expect(
        await OhosAdapter().cacheSelfHap(), endsWith('/self-renewal/base.hap'));
    expect(calls, ['cacheSelfHap']);
  });

  test('native read failure retains diagnostics for the renewal error',
      () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(
          code: 'SELF_HAP_CACHE_FAILED',
          message: '无法读取本应用安装包：Permission denied');
    });
    await expectLater(
        OhosAdapter().cacheSelfHap(),
        throwsA(isA<PlatformException>()
            .having((e) => e.code, 'code', 'SELF_HAP_CACHE_FAILED')
            .having(
                (e) => e.message, 'message', contains('Permission denied'))));
  });
}
