import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getTempDir() async {
  var tempDir = "";
  if (ohosAdapter.isOhos) {
    tempDir = (await ohosAdapter.tempDir()) ?? "";
  } else {
    if (Platform.isLinux) {
      tempDir = (await getApplicationCacheDirectory()).path;
    } else {
      tempDir = (await getTemporaryDirectory()).path;
    }
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
    if (Platform.isLinux) {
      tempDir = (await getApplicationCacheDirectory()).path;
    } else {
      tempDir = (await getTemporaryDirectory()).path;
    }
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
  FilePickerResult? result;
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
  final filePath = result?.files.first.path;
  if (filePath != null && Platform.isWindows) {
    final tempHap = File(
      path.join(await getTempDir(), "temp${path.extension(filePath)}"),
    );
    if (await tempHap.exists()) {
      tempHap.delete();
    }
    await File(filePath).copy(tempHap.path);
    return tempHap.path;
  }
  return filePath;
}

Future<String?> getLocalUrl() async {
  if (ohosAdapter.isOhos) {
    return ohosAdapter.getLocalUrl();
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('url');
}

Future<bool?> getFirstUse() async {
  if (ohosAdapter.isOhos) {
    return ohosAdapter.getFirstUse();
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('firstUse');
}

Future<void> setFirstUse() async {
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.setFirstUse();
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstUse', false);
}

Future<void> setLocalUrl(url) async {
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.setLocalUrl(url);
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('url', url);
}
