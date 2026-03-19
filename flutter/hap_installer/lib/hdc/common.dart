import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const JavaVersion = "17.0.15_6";

Future<String> getJavaDir() async {
  final temp = await getTempDir();
  return path.join(temp, "jdk-${JavaVersion.replaceAll("_", "+")}-jre");
}

Future<String> getTempDir() async {
  var tempDir = "";
  if (ohosAdapter.isOhos) {
    tempDir = (await ohosAdapter.tempDir()) ?? "";
  } else {
    if (Platform.isLinux) {
      tempDir = (await getApplicationCacheDirectory()).path;
    } else {
      tempDir = (await getTemporaryDirectory()).path;
      if (Platform.isWindows) {
        if (containsChinese(tempDir)) {
          final dir = Directory("C:\\Temp");
          if (!await dir.exists()) {
            await dir.create();
          }
          tempDir = dir.path;
        }
      }
    }
  }

  final appDir = Directory(path.join(tempDir, "hap_installer"));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path + "/";
}
Future<String> getHome() async {
  if (ohosAdapter.isOhos){
    return await ohosAdapter.tempDir() ?? "";
  }
  final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  return "${homeDir ?? ""}/.harmony";
}
bool containsChinese(String path) {
  // 正则匹配中文字符（包括简体、繁体、标点符号等）
  final RegExp chineseRegex = RegExp(r'[\u4e00-\u9fa5]'); // Unicode 范围：常用汉字
  return chineseRegex.hasMatch(path);
}

Future<String> getExternalDir() async {
  final path = (await getDownloadsDirectory())?.path;
  print("getExternalDir $path");
  return path ?? "";
}

Future<String> getHdcDir() async {
  var tempDir = await getTempDir();
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
    return await ohosAdapter.selectFile(["app", "hsp", "hap", "hnp"]);
  }
  if (Platform.isAndroid) {
    result = await FilePicker.platform.pickFiles(type: FileType.any);
  } else {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["app", "hsp", "hap", "hnp"],
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

Future<String?> selectDir() async {
  String? result;
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.selectFile([]);
  }
  result = await FilePicker.platform.getDirectoryPath();
  return result;
}

Future<String?> selectStoreFile() async {
  FilePickerResult? result;
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.selectFile([]);
  }
  result = await FilePicker.platform.pickFiles(type: FileType.any);
  final filePath = result?.files.first.path;
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
  return;
}

Future<void> setLocalUrl(url) async {
  if (ohosAdapter.isOhos) {
    return await ohosAdapter.setLocalUrl(url);
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('url', url);
}

/// 获取自动连接设置
/// 默认返回 true (开启)
Future<bool> getAutoConnect() async {
  if (ohosAdapter.isOhos) {
    final value = await ohosAdapter.getLocalKey("autoConnect");
    return value != "false"; // 默认 true
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('autoConnect') ?? true;
}

/// 保存自动连接设置
/// TODO 后续需对接实际的功能
Future<void> setAutoConnect(bool value) async {
  if (ohosAdapter.isOhos) {
    await ohosAdapter.setLocalKey("autoConnect", value.toString());
    return;
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('autoConnect', value);
}
