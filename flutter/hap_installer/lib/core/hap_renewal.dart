import 'dart:io';

bool isLoopbackDevice(String? device) {
  if (device == null) return false;
  final host = Uri.tryParse('tcp://$device')?.host;
  if (host == null) return false;
  return host == 'localhost' ||
      InternetAddress.tryParse(host)?.isLoopback == true;
}

Future<bool> isReadableHap(File file) async {
  try {
    if (!await file.exists() || await file.length() == 0) return false;
    final handle = await file.open();
    try {
      return (await handle.read(1)).isNotEmpty;
    } finally {
      await handle.close();
    }
  } on FileSystemException {
    return false;
  }
}

/// The native side locates the installed module and makes an atomic private copy.
Future<File> resolveSelfHap(Future<String?> Function() cacheSelfHap) async {
  final cachedPath = await cacheSelfHap();
  if (cachedPath == null ||
      !File(cachedPath).isAbsolute ||
      !await isReadableHap(File(cachedPath))) {
    throw const FormatException('无法读取本应用的安装包副本，请重试');
  }
  return File(cachedPath);
}
