import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:native_core/native_core.dart';
import 'package:path_provider/path_provider.dart';

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
  file.writeAsString(json);
}

Future<String> getTempDir() async {
  final temp = await getTemporaryDirectory();
  return temp.path;
}

Future<String> getAppDir() async {
  final temp = await getApplicationDocumentsDirectory();
  return temp.path;
}

class CmdService {
  Future<ModuleInfo> readModuleInfo(String hapPath) async {
    final modulePath = "${await getTempDir()}/module.json";
    final error = await unHap(hapPath, "module.json", modulePath);
    if (error != "") throw Exception(error);
    final json = await File(modulePath).readAsString();
    return ModuleInfo.fromJson(jsonDecode(json));
  }

  Future<String> signHapDefault() async {
    final inFile = "${await getTempDir()}/unsigned.hap";
    return signHap(inFile, null);
  }

  Future<String> signHap(String inFile, SignConfig? signConfig) async {
    if (!await File(inFile).exists()) {
      return "hap文件不存在";
    }
    if (signConfig == null) {
      final storeDir = "${await getTempDir()}/store";
      signConfig = await readSignConfigFromFile("$storeDir/signConfig.json");
    }
    if (signConfig == null) {
      return "签名配置不存在";
    }
    final outFile = "${await getTempDir()}/signed.hap";
    if (await File(outFile).exists()) {
      await File(outFile).delete();
    }
    final cmd =
        "signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile ${signConfig!.certPath} -profileFile ${signConfig.profilePath} -inFile ${inFile} -signAlg SHA256withECDSA -keystoreFile ${signConfig.keystoreFile} -keystorePwd ${signConfig.keystorePwd} -keyPwd ${signConfig.keystorePwd} -outFile ${outFile} -signCode 1";
    final error = await signCmd(cmd, await getTempDir());
    if (error == "") {
      return "签名成功";
    } else {
      return "签名失败: $error";
    }
  }

  Future<String> installHap(String? filePath) async {
    final outFile = filePath ?? "${await getTempDir()}/signed.hap";
    final result = await baseCmd("hdc install $outFile");
    if (result == "") {
      return "调试成功";
    } else {
      return "调试失败";
    }
  }

  Future<String> connectHdc(String url) async {
    if (url.length <= 5) {
      url = "127.0.0.1:${url}";
    }
    final cmd = "hdc 111";
    return await baseCmd(cmd);
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
