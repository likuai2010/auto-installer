import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:hap_installer/pages/Home.dart';
import 'package:hap_installer/pages/more_page.dart';
import 'package:hap_installer/widget/DownloadDialog.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';

void toask(BuildContext context, [String message = ""]) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

void showDownloadDialog(BuildContext context, String javaPath) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DownloadDialog(javaPath: javaPath);
    },
  );
}

class EcoViewModel extends ChangeNotifier {
  bool isLogin = false;
  bool firstUse = false;
  bool loading = false;
  bool fileLoading = false;
  bool deviceLoaing = false;

  List<TeamInfo> teamList = [];
  List<String> deviceList = [];
  AuthInfo? userInfo;
  HapInfo? hapInfo;
  String? currentDevice;
  SignConfig? signConfig;
  String storeDir = "";
  String signConfigPath = "";
  String userInfoPath = "";
  String debugPath = "";
  String ip = "192.168.3.47";
  String port = "39549";

  HistoryViewModel? historyViewModel;

  EcoViewModel() {}

  Future<bool> init() async {
    cmd.startServer();
    final storeDir = Directory(path.join(await getAppDir(), "store"));
    final debugDir = Directory(path.join(await getTempDir(), "apps"));
    if (!await storeDir.exists()) {
      await storeDir.create(recursive: true);
    }
    if (!await debugDir.exists()) {
      await debugDir.create(recursive: true);
    }

    debugPath = debugDir.path;
    this.storeDir = storeDir.path;
    signConfigPath = path.join(await getAppDir(), "signConfig.json");
    userInfoPath = path.join(await getAppDir(), "userInfo.json");

    await initSignConfig();
    await tarnsformAssert();

    final url = await getLocalUrl();
    firstUse = await getFirstUse() ?? true;
    await setFirstUse();
    ip = url?.split(":").first ?? ip;
    port = url?.split(":").last ?? port;
    print("eco init");
    return true;
  }

  Future loadUserInfo(BuildContext context, [AuthInfo? authInfo]) async {
    if (authInfo != null) {
      saveJsonToFile(jsonEncode(authInfo.toJson()), userInfoPath);
    }
    userInfo = await readUserInfoFromFile(userInfoPath);
    if (userInfo == null) return;
    try {
      await eco.initUserInfo(userInfo);
      final list = await eco.getUserTeamList();
      if (list != null) {
        teamList = list;
        if (teamList.isNotEmpty &&
            !teamList.any((t) => t.id == userInfo?.teamId)) {
          userInfo?.changeTeamId(teamList.first);
        }
      } else {
        toask(context, '获取团队信息失败(tip: 请关闭代理软件, ip必须在国内!)');
      }
      isLogin = true;
    } catch (e) {
      isLogin = false;
    }
    if (!Platform.isAndroid && !ohosAdapter.isOhos) {
      await checkDevices();
    }
    notifyListeners();
  }

  // only windows and linux
  checkJava(BuildContext context) async {
    if (!Platform.isWindows && !Platform.isLinux) return true;
    final hasJava = await hasJavaBySys();
    if (hasJava) return true;

    var javaPath = await getJavaDir();
    if (!await Directory(javaPath).exists()) {
      showAlert(
        context,
        title: const Text("警告!"),
        content: const Text("缺少java环境! 是否下载?"),
        onConfirm: () {
          showDownloadDialog(context, javaPath);
        },
      );
      return false;
    } else {
      return true;
    }
  }

  exportLog() async {
    final logPath = "${await getTempDir()}hdc.log";

    FlutterFileSaver().writeFileAsString(
      fileName: 'hdc_log.txt',
      data: await File(logPath).readAsString(),
    );
  }

  toLogin(BuildContext context) async {
    if (firstUse) {
      showTips(context);
      firstUse = false;
    }
    if (!await checkJava(context)) return;
    if (loading) return;
    loading = true;
    notifyListeners();
    final huawei = LoginHuawei();
    huawei.openUrl();
    final authInfo = await huawei.getAuthInfo();
    loading = false;
    await loadUserInfo(context, authInfo);
  }

  toAuthDev(BuildContext context) async {
    final huawei = LoginHuawei();
    huawei.toDev();
  }

  toConnect(BuildContext context, Function() builder) async {
    deviceLoaing = true;
    notifyListeners();
    try {
      await checkDevices();
    } catch (e) {
      toask(context, "检查设备失败 ${e}");
    }
    deviceLoaing = false;
    notifyListeners();
    builder();
  }

  toSelectFile(BuildContext context) async {
    if (!await checkJava(context)) return;
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {
      final filePath = await selectFile();
      if (filePath != null) {
        hapInfo = await _loadApp(context, filePath);
      }
    } catch (e) {
      toask(context, "${e}");
    }
    fileLoading = false;
    notifyListeners();
  }

  openFile(BuildContext context, String filePath) async {
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {
      hapInfo = await _loadApp(context, filePath);
    } catch (e) {
      toask(context, "$e");
    }
    fileLoading = false;
    notifyListeners();
  }

  changeTeam(TeamInfo info) {
    if (userInfo != null) {
      userInfo!.changeTeamId(info);
      eco.initUserInfo(userInfo);
      saveJsonToFile(jsonEncode(userInfo!.toJson()), userInfoPath);
      notifyListeners();
    }
  }

  changeDevice(String id) {
    currentDevice = id;
    cmd.changeTarget(id);
    notifyListeners();
  }

  Future connectDevice(BuildContext context, String ip, String port) async {
    this.ip = ip;
    this.port = port;
    await setLocalUrl("$ip:$port");
    var result = await _connectHdc("$ip:$port");
    toask(context, result);
  }

  _connectHdc(String url) async {
    if (!_checkUrlOrPort(url)) {
      return "请输入正确端口或地址";
    } else {
      final result = await cmd.connectHdc(url);
      await checkDevices();
      if (result.contains("Connect OK")) {
        return "连接成功";
      } else if (result.contains("failed")) {
        return "连接失败: 请检查ip和端口是否正确";
      } else if (result.contains("repeat")) {
        return "设备已经连接";
      } else {
        return result;
      }
    }
  }

  checkDevices() async {
    final result = await cmd.targetList();
    deviceList =
        result
            .split("\n")
            .where((d) => d != '' && !d.contains('[Empty]'))
            .toList();
    if (deviceList.isNotEmpty) {
      if (currentDevice == null || !deviceList.any((d) => d == currentDevice)) {
        if (deviceList.first.contains("server failed")) {
          currentDevice = "hdc服务启动失败，请重启应用!";
        } else {
          currentDevice = deviceList.first;
          changeDevice(currentDevice!);
        }
      }
    } else {
      currentDevice = null;
    }
    deviceLoaing = false;
    notifyListeners();
  }

  Future<HapInfo> _loadApp(BuildContext context, String hapPath) async {
    final appFile = File(hapPath);
    if (!await appFile.exists()) {
      throw FormatException("文件不存在: ${hapPath}");
    }
    final debugDir = Directory(debugPath);
    if (await debugDir.exists()) {
      await debugDir.delete(recursive: true);
    }
    await debugDir.create(recursive: true);
    List<String> pathList = [];
    if (path.extension(hapPath, 1).contains("app")) {
      await cmd.unzip_App(hapPath, debugPath);
      final files = Directory(debugPath).list();
      pathList =
          await files
              .where((f) => f.path.endsWith(".hap") || f.path.endsWith(".hsp"))
              .map((f) => f.path)
              .toList();
      pathList.sort((a, b) {
        return path.extension(b).compareTo(path.extension(a));
      });
    } else {
      pathList = [hapPath];
    }
    final err = await cmd.unzip_Hap(
      pathList.first,
      "module.json",
      path.join(debugPath, "module.json"),
    );
    if (err != "成功") {
      throw FormatException("解压文件失败: $err");
    }
    print("readModuleInfo  $hapPath  $err");
    final moduleInfo = await cmd.readModuleInfo(debugPath);
    return HapInfo(
      packageName: moduleInfo.app?.bundleName ?? "未知",
      pathList: pathList,
      version: moduleInfo.app?.versionName,
    );
  }

  tarnsformAssert() async {
    await copyAssert("store", "xiaobai.csr", storeDir);
    await copyAssert("store", "xiaobai.p12", storeDir);
    // debug test
    await copyAssert("store", "unsigned.hap", storeDir);
    await copyAssert("store", "xiaobai-debug.cer", storeDir);
    await copyAssert("store", "xiaobai-debug.p7b", storeDir);
    var hdcDir = await getHdcDir();
    print("hdcDir: ${hdcDir}");
    if (Platform.isMacOS) {
      final arch = await getArchitecture();
      if (arch.contains("x86_64")) {
        await copyAssert("macos", "hdc_x86_64", hdcDir, "hdc");
        await copyAssert(
          "macos",
          "libusb_shared_x86_64.dylib",
          hdcDir,
          "libusb_shared.dylib",
        );
      } else {
        await copyAssert("macos", "hdc", hdcDir);
        await copyAssert("macos", "libusb_shared.dylib", hdcDir);
      }
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      }
    }
    if (Platform.isWindows) {
      await copyAssert("windows", "hdc.exe", hdcDir);
      await copyAssert("windows", "libusb_shared.dll", hdcDir);
      await copyAssert("windows", "hap-sign-tool.jar", hdcDir);
    }
    if (Platform.isLinux) {
      await copyAssert("linux", "hap-sign-tool.jar", hdcDir);
      await copyAssert("linux", "hdc", hdcDir);
      await copyAssert("linux", "libusb_shared.so", hdcDir);
      await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
    }
  }

  clearCache(BuildContext context) async {
    final temp = await getTempDir();
    await Directory(temp).delete(recursive: true);
    try {
      await FilePicker.platform.clearTemporaryFiles();
      // ignore: empty_catches
    } catch (e) {}
    toask(context, "清理完成!");
  }

  copyAssert(
    String dir,
    String fileName,
    String targetDir, [
    String? target,
  ]) async {
    final bytes = await rootBundle.load('assets/$dir/$fileName');
    File file = File(path.join(targetDir, target ?? fileName));
    if (!await file.exists()) {
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }
  }

  initSignConfig() async {
    final defaultConfig = SignConfig(
      udids: List.empty(),
      certId: "",
      csrPath: path.join(storeDir, "xiaobai.csr"),
      keystoreFile: path.join(storeDir, "xiaobai.p12"),
      keystorePwd: "xiaobai123",
      keyAlias: "xiaobai",
      profilePath: path.join(storeDir, "xiaobai-debug.p7b"),
      certPath: path.join(storeDir, "xiaobai-debug.cer"),
    );
    try {
      signConfig =
          await readSignConfigFromFile(signConfigPath) ?? defaultConfig;
    } catch (e) {
      signConfig = defaultConfig;
    }
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
  }

  saveSignConfig() async {
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
  }

  resetSignConfig() async {
    final defaultConfig = SignConfig(
      udids: List.empty(),
      certId: "",
      csrPath: path.join(storeDir, "xiaobai.csr"),
      keystoreFile: path.join(storeDir, "xiaobai.p12"),
      keystorePwd: "xiaobai123",
      keyAlias: "xiaobai",
      profilePath: path.join(storeDir, "xiaobai-debug.p7b"),
      certPath: path.join(storeDir, "xiaobai-debug.cer"),
    );
    signConfig = defaultConfig;
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
  }

  changeCertConfig(CertInfo info) async {
    signConfig!.certId = info.id;
    signConfig!.certPath = path.join(storeDir, "${info.certName}.cer");
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
    return signConfig;
  }

  testSignHap(BuildContext context) async {
    String filePath = path.join(storeDir, "unsigned-test.hap");
    var error = await cmd.signHap(filePath, signConfig!);
    toask(context, error ?? "");
    error = await cmd.installHap(await cmd.getOutPath(filePath));
    print("installHap: $error");
    toask(context, error ?? "");
  }

  installHap() async {
    if (hapInfo != null) {
      var hap = hapInfo!;
      var signConfig = this.signConfig!;
      bool nextStep = true;
      final model = historyViewModel!;
      model.createDebugHistory(hap);
      model.updateHistory((s) {
        s.finished = false;
      });
      model.updateStep(0, (setp) {
        return setp.copyWith(loading: false, error: !isLogin ? "未登录" : null);
      });
      nextStep = await model.startSetp(1, () async {
        if (Platform.isAndroid) {
          await _connectHdc("$ip:$port");
        }
        return currentDevice == null ? "未连接设备" : null;
      });

      signConfig.packageName = hap.packageName;
      signConfig.profilePath =
          "$storeDir/${hap.packageName.replaceAll(".", "_")}.p7b";

      if (nextStep) {
        nextStep = await model.startSetp(2, () async {
          final udid = await cmd.getUdid();
          var udids = signConfig.udids.toList();
          if (!udids.contains(udid)) {
            udids.add(udid);
            signConfig.udids = udids;
          }
          return null;
        }, "获取设备udid");
      }
      if (nextStep) {
        nextStep = await model.startSetp(2, () async {
          final module = await cmd.readModuleInfo(debugPath);
          await eco.autoCreateProfile(signConfig, module, () => !isLogin);
          return null;
        });
      }
      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.startSetp(3, () async {
            return await cmd.signHap(p, signConfig);
          }, "签名(${path.basename(p)})");
        }
      }

      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.startSetp(4, () async {
            return await cmd.installHap(await cmd.getOutPath(p));
          }, "调试(${path.basename(p)})");
        }
      }
      model.updateHistory((setp) {
        setp.finished = true;
      });
    }
  }

  bool _checkUrlOrPort(String url) {
    int? number = int.tryParse(url);
    if (url.length <= 5 && number != null) {
      return false;
    } else if (url.length > 5 && !url.contains(":")) {
      return false;
    }
    return true;
  }
}

final viewmodel = EcoViewModel();
