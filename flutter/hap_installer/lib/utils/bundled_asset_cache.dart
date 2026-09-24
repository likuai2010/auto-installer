import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show listEquals;

/// Refresh executable assets without replacing user-owned signing material.
/// Returns true only when a file was installed or updated.
Future<bool> syncBundledAsset(
  File target,
  Uint8List bytes, {
  bool refresh = false,
}) async {
  if (await target.exists()) {
    if (!refresh || listEquals(await target.readAsBytes(), bytes)) {
      return false;
    }
  }

  await target.parent.create(recursive: true);
  final staging = await target.parent.createTemp('.asset-update-');
  try {
    final stagedFile = File('${staging.path}/asset');
    await stagedFile.writeAsBytes(bytes, flush: true);
    // Keep the previous executable intact until the replacement is complete.
    await stagedFile.rename(target.path);
  } finally {
    await staging.delete(recursive: true);
  }
  return true;
}
