import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:native_core/native_core.dart';
import 'package:path/path.dart' as path;

import 'package:shared_preferences/shared_preferences.dart';

void toask(BuildContext context, [String message = ""]) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

class EcoViewModel extends ChangeNotifier {
  bool isLogin = false;
  bool loading = false;

  List<TeamInfo> teamList = [];
  List<String> deviceList = [];
  AuthInfo? userInfo;
  HapInfo? hapInfo;
  String? currentDevice;
  SignConfig? signConfig;
  String storeDir = "";
  String signConfigPath = "";
  String ip = "192.168.3.47";
  String port = "39617";

  HistoryViewModel? historyViewModel;

  EcoViewModel() {}

  init() async {
    if (Platform.isAndroid) {
      startHdcServer();
    }

    final storeDir = Directory(path.join(await getAppDir(), "store"));
    if (!await storeDir.exists()) {
      storeDir.create(recursive: true);
    }
    final signConfigPath = path.join(await getAppDir(), "signConfig.json");
    this.storeDir = storeDir.path;
    this.signConfigPath = signConfigPath;

    initSignConfig();
    await tarnsformAssert();

    if (Platform.isAndroid) {
      await checkDevices();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final localIp = prefs.getString('ip');
    final localPort = prefs.getString('port');
    ip = localIp ?? ip;
    port = localPort ?? port;
    notifyListeners();
  }

  Future loadUserInfo(BuildContext context, [AuthInfo? authInfo]) async {
    final configPath = path.join(await getAppDir(), "userInfo.json");
    if (authInfo != null) {
      saveJsonToFile(jsonEncode(authInfo.toJson()), configPath);
    }
    userInfo = await readUserInfoFromFile(configPath);
    if (userInfo == null) return;
    try {
      await eco.initUserInfo(userInfo);
      final list = await eco.getUserTeamList();
      if (list != null) {
        teamList = list;
        userInfo?.changeTeamId(teamList.first.id);
      } else {
        toask(context, '登录信息无效(tip: 请关闭代理软件, ip必须在国内!)');
      }
      isLogin = true;
    } catch (e) {
      isLogin = false;
    }
    notifyListeners();
  }

  toLogin(BuildContext context) async {
    if (loading) {
      return;
    }
    loading = true;
    notifyListeners();
    final huawei = LoginHuawei();
    huawei.openUrl();
    final authInfo = await huawei.getAuthInfo();
    loading = false;
    await loadUserInfo(context, authInfo);
  }

  toSelectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var file = result?.files.first;
    if (file?.path != null) {
      try {
        hapInfo = await _loadHap(context, file!.path!);
      } catch (e) {
        toask(context, "${e}");
      }
      notifyListeners();
    }
  }

  Future connectDevice(BuildContext context, String ip, String port) async {
    this.ip = ip;
    this.port = port;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ip", ip);
    prefs.setString("port", port);
    var result = await _connectHdc("$ip:$port");
    toask(context, result);
    notifyListeners();
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
    deviceList = result.split("\n").where((d) => d != '').toList();
    if (deviceList.isNotEmpty && deviceList.first.trim() != "[Empty]") {
      currentDevice = deviceList.first;
    } else {
      currentDevice = null;
    }
  }

  Future<HapInfo> _loadHap(BuildContext context, String hapPath) async {
    final hapFile = File(hapPath);
    if (!await hapFile.exists()) throw Exception("文件不存在");
    final moduleInfo = await _loadModule(hapFile.path);
    return HapInfo(
      packageName: moduleInfo.app?.bundleName ?? "未知",
      filePath: hapFile.path,
    );
  }

  tarnsformAssert() async {
    await copyAssert("store", "xiaobai.csr", storeDir);
    await copyAssert("store", "xiaobai.p12", storeDir);
    // debug test
    await copyAssert("store", "unsigned.hap", storeDir);
    await copyAssert("store", "xiaobai-debug.cer", storeDir);
    await copyAssert("store", "xiaobai-debug.p7b", storeDir);
    if (Platform.isMacOS) {
      var hdcDir = await getHdcDir();
      await copyAssert("tools/macos", "hdc", hdcDir);
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      }
      await copyAssert("tools/macos", "libusb_shared.dylib", hdcDir);
    }
  }

  copyAssert(String dir, String fileName, String targetDir) async {
    final bytes = await rootBundle.load('assets/$dir/$fileName');
    File file = File(path.join(targetDir, fileName));
    if (!await file.exists()) {
      file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
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

  changeCertConfig(CertInfo info) async {
    signConfig!.certId = info.id;
    signConfig!.certPath = path.join(storeDir, "${info.certName}.cer");
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
    return signConfig;
  }

  testSignHap(BuildContext context) async {
    String filePath = path.join(storeDir, "unsigned.hap");
    var error = await cmd.signHap(filePath, signConfig!);
    toask(context, error);
    error = await cmd.installHap(await cmd.getOutPath(filePath));
    print("installHap: $error");
    toask(context, error);
  }

  installHap() async {
    if (hapInfo != null) {
      var hap = hapInfo!;
      var signConfig = this.signConfig!;
      historyViewModel?.createDebugHistory(hap);
      historyViewModel?.updateSetp(0, (setp) {
        return setp.copyWith(loading: false, error: !isLogin ? "未登录" : null);
      });
      historyViewModel?.updateSetp(1, (setp) {
        return setp.copyWith(loading: false, error: !isLogin ? "未连接设备" : null);
      });
      signConfig.packageName = hap.packageName;
      signConfig.profilePath =
          "$storeDir/${hap.packageName.replaceAll(".", "_")}.p7b";

      historyViewModel?.updateSetp(2, (setp) {
        return setp.copyWith(loading: true, error: "获取设备udid中...");
      });
      try {
        final udid = await cmd.getUdid();
        if (!signConfig.udids.contains(udid)) {
          signConfig.udids.add(udid);
        }
      } catch (e) {
        historyViewModel?.updateSetp(2, (setp) {
          return setp.copyWith(loading: false, error: "获取设备udid失败: $e");
        });
        historyViewModel?.updateHistory((setp) {
          setp.finished = true;
        });
        return;
      }
      historyViewModel?.updateSetp(2, (setp) {
        return setp.copyWith(loading: true, error: "请求签名中");
      });
      try {
        final module = await _loadModule(hap.filePath);
        await eco.autoCreateProfile(signConfig, module, () {
          return !isLogin;
        });
      } catch (e) {
        historyViewModel?.updateSetp(2, (setp) {
          return setp.copyWith(loading: false, error: "请求签名失败: $e");
        });
        historyViewModel?.updateHistory((setp) {
          setp.finished = true;
        });
        return;
      } finally {
        await saveJsonToFile(jsonEncode(signConfig.toJson()), signConfigPath);
      }

      historyViewModel?.updateSetp(2, (setp) {
        return setp.copyWith(loading: true, error: "正在签名...");
      });
      var error = "so failure";
      if (Platform.isWindows) {
        await Future.delayed(Duration(milliseconds: 10000));
      } else {
        error = await cmd.signHap(hap.filePath, signConfig);
      }

      historyViewModel?.updateSetp(2, (setp) {
        return setp.copyWith(
          loading: false,
          error: error == "签名成功" ? null : error,
        );
      });
      if (error == "签名成功") {
        historyViewModel?.updateSetp(3, (setp) {
          return setp.copyWith(loading: true, error: "正在调试...");
        });
        try {
          final error = await cmd.installHap(
            await cmd.getOutPath(hap.filePath),
          );
          historyViewModel?.updateSetp(3, (setp) {
            return setp.copyWith(
              loading: false,
              error: error == "调试成功" ? null : error,
            );
          });
        } catch (e) {
          historyViewModel?.updateSetp(3, (setp) {
            return setp.copyWith(loading: false, error: "调试失败: $e");
          });
        }
      }
    }
    historyViewModel?.updateHistory((setp) {
      setp.finished = true;
    });
  }

  Future<ModuleInfo> _loadModule(String hapPath) async {
    return await cmd.readModuleInfo(hapPath);
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
