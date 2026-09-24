import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hap_installer/utils/bundled_asset_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Opt-in macOS regression: all signing material stays local and is never logged.
  final env = Platform.environment;
  final configured = ['CLASHBOX_HAP', 'SIGNING_STORE', 'LEGACY_SIGNER']
      .every((name) => env.containsKey(name));

  test(
      'upgrades legacy signer and signs and verifies the original ClashBox HAP',
      () async {
    for (final name in ['CLASHBOX_HAP', 'LEGACY_SIGNER']) {
      expect(await File(env[name]!).exists(), isTrue,
          reason: '$name must point to an existing file');
    }
    final root = await Directory.systemTemp.createTemp('signer-upgrade-');
    try {
      final signer =
          await File(env['LEGACY_SIGNER']!).copy('${root.path}/signer');
      await Process.run('chmod', ['+x', signer.path]);
      final store = env['SIGNING_STORE']!;
      final output = '${root.path}/signed.hap';
      final args = [
        'sign-app',
        '-mode',
        'localSign',
        '-keyAlias',
        'xiaobai',
        '-appCertFile',
        '$store/xiaobai-debug.cer',
        '-profileFile',
        '$store/org_xbgroup_clashboxLTS.p7b',
        '-inFile',
        env['CLASHBOX_HAP']!,
        '-signAlg',
        'SHA256withECDSA',
        '-keystoreFile',
        '$store/key.pem',
        '-outFile',
        output,
        '-signCode',
        '1',
      ];
      final before = await Process.run(signer.path, args);
      expect(before.exitCode, isNot(0));
      expect(
          '${before.stdout}${before.stderr}'.contains('nil pointer'), isTrue);

      final bundled = await rootBundle.load('assets/macos/signer');
      expect(
          await syncBundledAsset(
              signer,
              bundled.buffer
                  .asUint8List(bundled.offsetInBytes, bundled.lengthInBytes),
              refresh: true),
          isTrue);
      await Process.run('chmod', ['+x', signer.path]);
      final after = await Process.run(signer.path, args);
      expect(after.exitCode, 0);
      expect('${after.stdout}${after.stderr}'.contains('sign-app success'),
          isTrue);

      final verification = await Process.run(signer.path, [
        'verify-app',
        '-inFile',
        output,
        '-outCertChain',
        '${root.path}/verified.cer',
        '-outProfile',
        '${root.path}/verified.p7b',
      ]);
      expect(verification.exitCode, 0);
      expect(
          '${verification.stdout}${verification.stderr}'
              .contains('verify-app success'),
          isTrue);
    } finally {
      await root.delete(recursive: true);
    }
  },
      skip: !Platform.isMacOS || !configured,
      timeout: const Timeout(Duration(minutes: 2)));
}
