import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

void toask(BuildContext context, [String message = ""]) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

class EcoViewModel extends ChangeNotifier {
  bool isLogin = false;
  List<TeamInfo> teamList = [];
  List<String> deviceList = [];
  AuthInfo? userInfo;
  HapInfo? hapInfo;
  String? currentDevice;
  SignConfig? signConfig;
  String storeDir = "";
  bool loading = false;
  String ip = "192.168.3.47";
  String port = "44315";

  EcoViewModel() {}

  init() async {
    startHdcServer();
    final storeDir = Directory(path.join(await getAppDir(), "store"));
    if (!await storeDir.exists()) {
      storeDir.create(recursive: true);
    }
    this.storeDir = storeDir.path;
    tarnsformAssert();
    initSignConfig();
    checkDevices();
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
      } else {
        toask(context, '登录信息无效(tip: 请关闭代理软件, ip必须在国内!)');
      }
      isLogin = true;
    } catch (e) {
      isLogin = false;
    }
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
    notifyListeners();
  }

  toSelectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var file = result?.files.first;
    toask(context, "${file?.path}");
    if (file?.path != null) {
      hapInfo = await _loadHap(context, file!.path!);
      notifyListeners();
    }
  }

  connectDevice(BuildContext context, String ip, String port) async {
    this.ip = ip;
    this.port = port;
    var result = await cmd.connectHdc("$ip:$port");
    toask(context, result);
    checkDevices();
  }

  checkDevices() async {
    final result = await cmd.targetList();
    deviceList = result.split("\n").where((d) => d != '').toList();
    if (deviceList.isNotEmpty && deviceList.first.trim() != "[Empty]") {
      currentDevice = "";
    } else {
      currentDevice = deviceList.first;
    }
  }

  Future<HapInfo> _loadHap(BuildContext context, String hapPath) async {
    final hapFile = File(hapPath);
    final tempFile = File("${await getTempDir()}/unsigned.hap");
    tempFile.writeAsBytes(hapFile.readAsBytesSync(), flush: true);
    if (!await tempFile.exists()) new Exception("文件不存在");
    final moduleInfo = await _loadModule(tempFile.path);
    return HapInfo(
      packageName: moduleInfo?.app?.bundleName ?? "未知",
      filePath: hapFile.path,
    );
  }

  tarnsformAssert() async {
    await copyAssert("xiaobai.csr");
    await copyAssert("xiaobai.p12");
    // debug test
    await copyAssert("unsigned.hap");
    await copyAssert("xiaobai-debug.cer");
    await copyAssert("xiaobai-debug.p7b");
  }

  copyAssert(String fileName) async {
    final bytes = await rootBundle.load('assets/store/$fileName');
    File file = File(path.join(storeDir, fileName));
    if (!await file.exists()) {
      file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }
  }

  initSignConfig() async {
    final configPath = path.join(await getAppDir(), "signConfig.json");
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
      signConfig = await readSignConfigFromFile(configPath) ?? defaultConfig;
    } catch (e) {
      signConfig = defaultConfig;
    }
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), configPath);
  }

  testSignHap() async {
    String filePath = path.join(storeDir, "unsigned.hap");
    var error = await cmd.signHap(filePath, signConfig!);
    print("SignHap $error");
    error = await cmd.installHap(await cmd.getOutPath(filePath));
    print("installHap: $error");
  }

  installHap(HapInfo hap) async {
    if (signConfig != null) {
      signConfig!.packageName = hap.packageName;
      if (currentDevice != "") {
        signConfig!.udids.add(await cmd.getUdid());
      }
      signConfig!.profilePath =
          "${await getAppDir()}/xiaobai-debug_${hap.packageName.replaceAll(".", "_")}.p7b";
      try {
        // onUpdate("请求签名...")
        final module = await _loadModule(hap.filePath);
        if (module == null) return;
        var result = await eco.autoCreateProfile(signConfig!, module, () {
          if (!isLogin) {
            // toLogin()
            return true;
          } else {
            return false;
          }
        });
        if (!result) return "请求签名失败";
        await saveJsonToFile(
          jsonEncode(signConfig!.toJson()),
          "${getAppDir()}/signConfig.json",
        );
        //onUpdate("正在签名...")
        var error = await cmd.signHap(hap.filePath, signConfig!);
        if (error == "签名成功") {
          //onUpdate("正在安装...")
          await cmd.installHap(await cmd.getOutPath(hap.filePath));
          // return ""
        } else {
          //return "签名失败"
        }
      } catch (e) {
        //promptAction.showToast({message: e.message || e, duration: 3000})
        //return e.message || e
      }
    }
    //return "签名配置不能为空"
  }

  connectHdc(String url) async {
    if (!_checkUrlOrPort(url)) {
      // promptAction.showToast({message:"请输入正确端口或地址"})
      return;
    } else {
      final result = await cmd.connectHdc(url);
      await checkDevices();
      if (result.contains("Connect OK")) {
        return;
      } else {
        // if (currentDevice?.contains("Unauthorized")) {
        //   // "请等待授权弹框!"
        // } else {
        //   // promptAction.showToast({message: result})
        // }
        return;
      }
    }
  }

  Future<ModuleInfo?> _loadModule(String hapPath) async {
    try {
      return await cmd.readModuleInfo(hapPath);
    } catch (e) {
      print("loadModule: $e");
    }
    return null;
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
