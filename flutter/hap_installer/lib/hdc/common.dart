import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:ohos_adapter/ohos_adapter.dart';

Future<String> getTempDir() async {
  var tempDir = "";
  if (ohosAdapter.isOhos) {
    tempDir = (await ohosAdapter.tempDir()) ?? "";
  } else {
    tempDir = (await getApplicationCacheDirectory()).path;
  }

  final appDir = Directory(path.join(tempDir, "hap_installer"));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path;
}

Future<String> getHdcDir() async {
  var tempDir = "";
  if (ohosAdapter.isOhos) {
    tempDir = (await ohosAdapter.tempDir()) ?? "";
  } else {
    tempDir = (await getApplicationCacheDirectory()).path;
  }
  final appDir = Directory(path.join(tempDir, "hdc_tools"));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path;
}

Future<String> getAppDir() async {
  var tempDir = "";
  if (ohosAdapter.isOhos) {
    tempDir = (await ohosAdapter.appDir()) ?? "";
  } else {
    tempDir = (await getApplicationDocumentsDirectory()).path;
  }
  final appDir = Directory(path.join(tempDir, 'hap_installer'));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path;
}

Future<String?> selectFile() async {
  FilePickerResult? result = null;
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.selectFile();
  }
  if (Platform.isAndroid) {
    result = await FilePicker.platform.pickFiles(type: FileType.any);
  } else {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["app", "hsp", "hap"],
    );
  }

  return result?.files.first.path;
}
