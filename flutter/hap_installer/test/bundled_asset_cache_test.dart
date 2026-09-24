import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hap_installer/utils/bundled_asset_cache.dart';

void main() {
  late Directory root;
  setUp(
      () async => root = await Directory.systemTemp.createTemp('asset-cache-'));
  tearDown(() async => root.delete(recursive: true));

  test('replaces a stale cached signer with the bundled executable', () async {
    final target = File('${root.path}/signer');
    await target.writeAsBytes([1, 2, 3]);
    expect(
        await syncBundledAsset(target, Uint8List.fromList([4, 5, 6]),
            refresh: true),
        isTrue);
    expect(await target.readAsBytes(), [4, 5, 6]);
    expect(await root.list().length, 1);
  });

  test('leaves identical tools untouched', () async {
    final target = File('${root.path}/signer');
    await target.writeAsBytes([1, 2, 3]);
    final oldTime = DateTime(2020);
    await target.setLastModified(oldTime);
    expect(
        await syncBundledAsset(target, Uint8List.fromList([1, 2, 3]),
            refresh: true),
        isFalse);
    expect(await target.lastModified(), oldTime);
  });

  test('preserves existing private keys and profiles by default', () async {
    for (final name in ['key.pem', 'xiaobai.p12', 'xiaobai-debug.p7b']) {
      final target = File('${root.path}/$name');
      await target.writeAsString('user-owned material');
      expect(await syncBundledAsset(target, Uint8List.fromList([9])), isFalse);
      expect(await target.readAsString(), 'user-owned material');
    }
  });

  test('installs into an empty cache', () async {
    final target = File('${root.path}/new-cache/signer');
    expect(
        await syncBundledAsset(target, Uint8List.fromList([7]), refresh: true),
        isTrue);
    expect(await target.readAsBytes(), [7]);
  });

  test('reports replacement errors and removes staging files', () async {
    final directory = await Directory('${root.path}/signer').create();
    await File('${directory.path}/keep').writeAsString('keep');
    await expectLater(
        syncBundledAsset(File(directory.path), Uint8List.fromList([7]),
            refresh: true),
        throwsA(isA<FileSystemException>()));
    expect(await File('${directory.path}/keep').readAsString(), 'keep');
    expect(await root.list().length, 1);
  });
}
