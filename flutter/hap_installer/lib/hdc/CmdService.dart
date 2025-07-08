import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:hap_installer/pages/Home.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';

import 'package:native_core/native_core.dart';

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

class CmdService {
  String _t = "";

  startServer() async {
    if (ohosAdapter.isOhos) {
      ohosAdapter.startServer();
    }
    if (Platform.isAndroid) {
      final temp = await getTempDir();
      startHdcServer(temp);
    }
  }

  unzip_App(String hapPath, String debugPath) {
    return unApp(hapPath, debugPath);
  }

  unzip_Hap(String first, String s, String join) {
    return unHap(first, s, join);
  }

  unpackage(String hapPath,){

  }
  buildHap(String hapPath){

  }

  changeTarget(String device) {
    _t = "-t $device";
  }

  Future<ModuleInfo> readModuleInfo(String debugDir) async {
    final modulePath = File(path.join(debugDir, "module.json"));
    try {
      final json = await modulePath.readAsString();
      final dict = jsonDecode(json);
      return ModuleInfo.fromJson(dict);
    } catch (e) {
      print("readModuleInfo: $e");
      throw FormatException("加载modlue.json失败: $e");
    }
  }

  Future<String> getOutPath(String inPath) async {
    final outFile = path.join(
      await getTempDir(),
      "${path.basenameWithoutExtension(inPath).trim()}_signed${path.extension(inPath)}",
    );
    return outFile;
  }

  Future<String?> signHap(String inPath, SignConfig signConfig) async {
    if (!await File(inPath).exists()) {
      return "hap文件不存在";
    }
    final outPath = await getOutPath(inPath);
    var cmd = "";
    if (ohosAdapter.isOhos) {
      cmd =
          'signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile ${signConfig.certPath} -profileFile ${signConfig.profilePath} -inFile $inPath -signAlg SHA256withECDSA -keystoreFile ${signConfig.keystoreFile} -keystorePwd ${signConfig.keystorePwd} -keyPwd ${signConfig.keystorePwd} -outFile $outPath -signCode 1';
    } else {
      cmd =
          'signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile "${signConfig.certPath}" -profileFile "${signConfig.profilePath}" -inFile "$inPath" -signAlg SHA256withECDSA -keystoreFile "${signConfig.keystoreFile}" -keystorePwd "${signConfig.keystorePwd}" -keyPwd "${signConfig.keystorePwd}" -outFile "$outPath" -signCode 1';
    }
    final error = await baseSign(cmd);
    if (error.contains("success")) {
      return null;
    } else {
      return "签名失败: $error";
    }
  }

  Future<String?> installHap(String filePath) async {
    if (!await File(filePath).exists()) {
      return "文件不存在 $filePath";
    }
    print("installHap $filePath");
    final result = await baseCmd('hdc $_t install "$filePath"');
    if (result.contains("success")) {
      return null;
    } else if (result.contains("9568322")) {
      return "Profile验证失败: 请检查Profile文件 (tip: Profile中未包含该调试设备的UDID; 签名证书和创建Profile的证书不一致; 签名时使用了发布证书和发布profile文件)";
    } else if (result.contains("9568289")) {
      return "权限请求失败导致安装失败! (tip: 如果使用了system_basic或system_core等级的权限，将导致报错)";
    } else if (result.contains("9568297")) {
      return "由于设备sdk版本较低导致安装失败! (tip: 该问题是由于编译打包所使用的SDK版本与设备镜像版本不匹配)";
    } else if (result.contains("9568332")) {
      return "签名不一致导致安装失败! (tip: 设备上已安装的应用与新安装的应用中签名不一致或者多个包（HAP和HSP）之间的签名存在差异)";
    } else if (result.contains("9568329")) {
      return "签名信息中的包名与应用的包名(bundleName)不一致! (tip: 用户导入了三方提供的HSP模块，且该HSP既非集成态HSP，又非同包名的HSP，造成包名不一致)";
    } else if (result.contains("9568320")) {
      return "不能安装未签名的HAP包! (tip: HAP包没有签名)";
    } else if (result.contains("9568263")) {
      return "不支持降级安装! (tip: 设备上已有新版)";
    } else {
      return "调试失败: $result";
    }
  }

  Future<String> connectHdc(String url) async {
    if (url.length <= 5) {
      url = "127.0.0.1:$url";
    }
    final cmd = "hdc tconn $url";
    try {
      return await baseCmd(cmd);
    } catch (e) {
      return "$e";
    }
  }

  Future<String> targetList() async {
    const cmd = "hdc list targets";
    return await baseCmd(cmd);
  }

  Future<String> getUdid() async {
    final cmd = "hdc $_t shell bm get --udid";
    final result = await baseCmd(cmd);
    final udid = result.split(":");
    if (udid.length > 1) {
      return udid.last.trim();
    } else {
      return "获取udid失败: $result";
    }
  }

  Future<String> openApp(String packageName) async {
    final cmd = "hdc $_t shell aa start -a EntryAbility -b $packageName";
    return await baseCmd(cmd);
  }

  Future<String> baseCmd(String cmd) async {
    print("baseCmd ${cmd}");
    if (ohosAdapter.isOhos) {
      return await ohosAdapter.hdcCmd(cmd) ?? "";
    }
    if (Platform.isAndroid) {
      getExternalDir();
      return await hdcCmd(cmdToArgs(cmd), await getTempDir());
    } else {
      final hdcDir = await getHdcDir();
      var shell = Shell(workingDirectory: hdcDir);
      return await Isolate.run(() async {
        try {
          if (!Platform.isWindows) {
            var results = await shell.run(cmd.replaceFirst("hdc", "./hdc"));
            return results.first.outText;
          } else {
            final args = cmdToArgs(cmd.replaceFirst("hdc ", ""));
            print("args $args");
            var result = await Process.run(path.join(hdcDir, "hdc.exe"), args);
            return result.outText + result.errText;
          }
        } catch (e) {
          print("baseCmd $e");
          return "$e";
        }
      });
    }
  }

  Future<String> baseSign(String cmd) async {
    // ohos ffi 会卡线程，采用bridge
    if (ohosAdapter.isOhos) {
      return await ohosAdapter.signCmd(cmd) ?? "";
    }
    if (!Platform.isWindows && !Platform.isLinux) {
      return await signCmd(cmdToArgs(cmd), await getTempDir());
    } else {
      // window and linux
      var shell = Shell(workingDirectory: path.join(await getJavaDir(), "bin"));
      var hdcDir = await getHdcDir();
      var java = "java.exe";
      if (Platform.isLinux) {
        java = "java";
      }
      final hasJava = await hasJavaBySys();
      try {
        final javaCmd =
            !hasJava ? path.join(await getJavaDir(), "bin", java) : 'java';
        final args = cmdToArgs(cmd.replaceFirst("signtool ", ""));
        print("baseSign $javaCmd  $args");
        var result = await Process.run(javaCmd, [
          "-jar",
          path.join(hdcDir, "hap-sign-tool.jar"),
          ...args,
        ]);
        return result.outText + result.errText;
      } catch (e) {
        print("baseSign $e");
        return "baseSign $e";
      }
    }
  }
}

Future<String> getArchitecture() async {
  if (Platform.isMacOS || Platform.isLinux) {
    var result = await Process.run('uname', ['-m']);
    return result.stdout.trim();
  } else if (Platform.isWindows) {
    var result = await Process.run('wmic', ['OS', 'get', 'OSArchitecture']);
    return result.stdout.contains('64') ? 'x86_64' : 'x86';
  } else {
    return 'unknown';
  }
}

List<String> cmdToArgs(String cmd) {
  RegExp regExp = RegExp(r'([^\s"]+)|"([^"]*)"');
  List<String> matches = [];
  for (var match in regExp.allMatches(cmd)) {
    matches.add(match.group(2) ?? match.group(1)!);
  }
  print("cmdToArgs $matches");
  return matches;
}

final cmd = CmdService();

Future<bool> runHdc() async {
  var result = await Process.run('java', ['-version']);
  // 检查命令的退出状态
  if (result.exitCode == 0) {
    print('Java 版本: ${result.stdout}');
    print('Java 已安装');

    return true;
  } else {
    print('Java 未安装或无法运行');
    print('错误信息: ${result.stderr}');
    return false;
  }
}
