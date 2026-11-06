import 'dart:async';
import 'dart:io';

// This PR1 check runs directly with Dart and has no Flutter dependencies.
// ignore: avoid_relative_lib_imports
import '../lib/core/debug_app_install_time.dart';
// ignore: avoid_relative_lib_imports
import '../lib/core/hap_renewal.dart'
    show isLoopbackDevice, isReadableHap, resolveSelfHap;

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

bool sameBytes(List<int> actual, List<int> expected) {
  if (actual.length != expected.length) return false;
  for (var i = 0; i < actual.length; i++) {
    if (actual[i] != expected[i]) return false;
  }
  return true;
}

Future<void> rejectsSelfCopy(String? cachedPath, String description) async {
  var rejected = false;
  try {
    await resolveSelfHap(() async => cachedPath);
  } on FormatException {
    rejected = true;
  }
  check(rejected, '$description was accepted as a self-renewal package');
}

Future<void> main() async {
  for (final device in [
    '127.0.0.1:12345',
    '127.0.0.2:12345',
    'localhost:12345',
    '[::1]:12345',
  ]) {
    check(isLoopbackDevice(device), 'Local device was rejected: $device');
  }
  for (final device in <String?>[
    null,
    '',
    'USB123',
    '192.0.2.1:12345',
    '[2001:db8::1]:12345',
    '127.0.0.1.example.com:12345',
    'localhost.example.com:12345',
  ]) {
    check(!isLoopbackDevice(device),
        'Remote device was treated as self: $device');
  }

  const milliseconds = 1774300000000;
  for (final output in [
    '{"installTime": $milliseconds,}',
    '  installTime: $milliseconds\n',
    'bundle: com.example.app\ninstallTime: $milliseconds\nupdateTime: 0',
  ]) {
    check(
      parseDebugAppInstallTime(output)?.millisecondsSinceEpoch == milliseconds,
      'Install time was not parsed: $output',
    );
  }
  for (final output in <String?>[
    null,
    '',
    '[Fail] Unauthorized',
    'updateTime: $milliseconds',
    'installTime: unknown',
    'installTime: -1',
    'installTime: 123invalid',
    'installTime: 999999999999999999',
  ]) {
    check(parseDebugAppInstallTime(output) == null,
        'Invalid install time was accepted: $output');
  }

  final temp = await Directory.systemTemp.createTemp('self_renewal_');
  try {
    final installed = File('${temp.path}/installed/current-entry.hap');
    await installed.parent.create(recursive: true);
    final payload = List<int>.generate(150000, (i) => i % 251);
    await installed.writeAsBytes(payload);
    check(
        await isReadableHap(installed), 'Readable installed HAP was rejected');

    final privateCopy = File('${temp.path}/private/self-renewal/base.hap');
    final copyStarted = Completer<void>();
    final finishCopy = Completer<void>();
    var resolvedBeforeCopyFinished = false;
    final resolving = resolveSelfHap(() async {
      await privateCopy.parent.create(recursive: true);
      // Model the native copy while it is still incomplete.
      await privateCopy.writeAsBytes(payload.take(100).toList());
      copyStarted.complete();
      await finishCopy.future;
      await installed.copy(privateCopy.path);
      return privateCopy.path;
    }).then((file) {
      resolvedBeforeCopyFinished = !finishCopy.isCompleted;
      return file;
    });
    await copyStarted.future;
    check(await privateCopy.length() == 100,
        'The asynchronous copy fixture did not pause with partial bytes');
    var resolved = false;
    unawaited(resolving.then((_) => resolved = true));
    await Future<void>.delayed(Duration.zero);
    check(!resolved, 'Self-renewal returned before the native copy completed');
    finishCopy.complete();
    final first = await resolving;
    check(
        !resolvedBeforeCopyFinished &&
            first.path == privateCopy.path &&
            sameBytes(await first.readAsBytes(), payload),
        'Self-renewal did not await the complete native copy');

    var nativeCopies = 0;
    Future<String?> copyCurrentInstalledHap() async {
      nativeCopies++;
      await installed.copy(privateCopy.path);
      return privateCopy.path;
    }

    await privateCopy.delete();
    final recreated = await resolveSelfHap(copyCurrentInstalledHap);
    check(sameBytes(await recreated.readAsBytes(), payload),
        'A deleted private cache was not recreated on the next click');

    // A package upgrade can change its contents without changing its size.
    final upgraded = List<int>.from(payload);
    upgraded[70000] = (upgraded[70000] + 1) % 251;
    await installed.writeAsBytes(upgraded);
    final refreshed = await resolveSelfHap(copyCurrentInstalledHap);
    check(
        nativeCopies == 2 &&
            await refreshed.length() == payload.length &&
            sameBytes(await refreshed.readAsBytes(), upgraded),
        'A same-size upgrade reused stale package bytes');

    final missing = File('${temp.path}/missing.hap');
    final empty = File('${temp.path}/empty.hap');
    await empty.writeAsBytes([]);
    check(!await isReadableHap(missing), 'Missing HAP was considered readable');
    check(!await isReadableHap(empty), 'Empty HAP was considered readable');
    await rejectsSelfCopy(null, 'A null native result');
    await rejectsSelfCopy(missing.path, 'A missing native copy');
    await rejectsSelfCopy('relative/base.hap', 'A nonabsolute native path');
    await rejectsSelfCopy(empty.path, 'An empty native copy');

    stdout.writeln(
      'PASS: awaited self copy, deleted cache, same-size upgrade, invalid copies, loopback targets and install times',
    );
  } finally {
    await temp.delete(recursive: true);
  }
}
