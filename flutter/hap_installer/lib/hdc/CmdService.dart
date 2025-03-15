import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:native_core/native_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<SignConfig?> readSignConfigFromFile(String filePath) async {
  if (!await File(filePath).exists()) return null;
  final json = await File(filePath).readAsString();
  final config = SignConfig.fromJson(jsonDecode(json));
  return config;
}

Future<AuthInfo?> readUserInfoFromFile(String filePath) async {
  if (!await File(filePath).exists()) return null;
  final json = await File(filePath).readAsString();
  final config = AuthInfo.fromJson(jsonDecode(json));
  return config;
}

Future saveJsonToFile(String json, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(json, flush: true);
}

Future<String> getTempDir() async {
  final temp = await getTemporaryDirectory();

  final appDir = Directory(path.join(temp.path, "hap_installer"));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path;
}

Future<String> getAppDir() async {
  final temp = await getApplicationDocumentsDirectory();
  final appDir = Directory(path.join(temp.path, 'hap_installer'));
  if (!await appDir.exists()) {
    appDir.create(recursive: true);
  }
  return appDir.path;
}

class CmdService {
  Future<ModuleInfo> readModuleInfo(String hapPath) async {
    final modulePath = "${await getTempDir()}/module.json";
    final error = await unHap(hapPath, "module.json", modulePath);
    if (error != "") throw Exception(error);
    final json = await File(modulePath).readAsString();
    return ModuleInfo.fromJson(jsonDecode(json));
  }

  Future<String> getOutPath(String inPath) async {
    final outFile = path.join(
      await getTempDir(),
      "${path.basenameWithoutExtension(inPath)}_signed${path.extension(inPath)}",
    );
    return outFile;
  }

  Future<String> signHap(String inPath, SignConfig signConfig) async {
    if (!await File(inPath).exists()) {
      return "hap文件不存在";
    }
    final outPath = await getOutPath(inPath);
    final cmd =
        "signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile ${signConfig.certPath} -profileFile ${signConfig.profilePath} -inFile $inPath -signAlg SHA256withECDSA -keystoreFile ${signConfig.keystoreFile} -keystorePwd ${signConfig.keystorePwd} -keyPwd ${signConfig.keystorePwd} -outFile $outPath -signCode 1";
    print("signCmd: $cmd");
    final error = await signCmd(cmd, await getTempDir());
    if (error == "") {
      return "签名成功";
    } else {
      return "签名失败: $error";
    }
  }

  Future<String> installHap(String filePath) async {
    if (!File(filePath).existsSync()) {
      return "文件不存在";
    }
    final result = await baseCmd("hdc install $filePath");
    if (result == "") {
      return "调试成功";
    } else {
      return "调试失败: ${result}";
    }
  }

  Future<String> connectHdc(String url) async {
    if (url.length <= 5) {
      url = "127.0.0.1:${url}";
    }
    final cmd = "hdc tconn $url";
    try {
      return await baseCmd(cmd);
    } catch (e) {
      return "$e";
    }
  }

  Future<String> targetList() async {
    final cmd = "hdc list targets";
    return await baseCmd(cmd);
  }

  Future<String> getUdid() async {
    final cmd = "hdc shell bm get --udid";
    final result = await baseCmd(cmd);
    final udid = result.split(":")[1];
    if (udid != "") {
      return udid.trim();
    } else {
      return "获取udid失败: ${result}";
    }
  }

  Future<String> openApp(String packageName) async {
    final cmd = "hdc shell aa start -a EntryAbility -b $packageName";
    return await baseCmd(cmd);
  }

  Future<String> baseCmd(cmd) async {
    return await hdcCmd(cmd, await getTempDir());
  }

  test() {}
}

final cmd = CmdService();
