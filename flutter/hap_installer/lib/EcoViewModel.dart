import 'dart:convert';
import 'dart:io';

import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:native_core/native_core.dart';

class EcoViewModel {
  bool isLogin = false;
  List<TeamInfo> teamList = [];
  List<String> deviceList = [];
  String currentDevice = "";
  SignConfig? signConfig;
  EcoViewModel(){
    startHdcServer();
  }

  loadUserInfo() async {
    final userInfo = await readUserInfoFromFile(
      "${await getAppDir()}/userInfo.json",
    );
    try {
      await eco.initUserInfo(userInfo);
      teamList = await eco.getUserTeamList();
      isLogin = true;
    } catch (e) {
      isLogin = false;
    }
  }
  connectDevice() async {
    print("connectDevice: ");

    var result = await cmd.connectHdc("192.168.0.126:34851");
    print("connectDevice: "+ result);
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

  Future<HapInfo> loadHap(String hapPath) async {
    final hapFile = File("${getTempDir()}/unsigned.hap");
    if (await hapFile.exists()) await hapFile.delete();
    print('testTag copy finish: ${hapFile.path}');
    final moduleInfo = await _loadModule(hapFile.path);
    return HapInfo(
      packageName: moduleInfo?.app?.bundleName ?? "位置",
      filePath: hapFile.path,
    );
  }

  installHap(HapInfo hap) async {
    if (signConfig != null) {
      signConfig!.packageName = hap.packageName;
      if (currentDevice != "") {
        signConfig!.udid = await cmd.getUdid();
      }
      signConfig!.profilePath =
          "${getAppDir()}/xiaobai-debug_${hap.packageName.replaceAll(".", "_")}.p7b";
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
        var error = await cmd.signHap(hap.filePath, signConfig);
        if (error == "签名成功") {
          //onUpdate("正在安装...")
          await cmd.installHap(null);
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
        if (currentDevice.contains("Unauthorized")) {
          // "请等待授权弹框!"
        } else {
          // promptAction.showToast({message: result})
        }
        return;
      }
    }
  }

  Future<ModuleInfo?> _loadModule(String hapPath) async {
    try {
      return await cmd.readModuleInfo(hapPath);
    } catch (e) {
      //promptAction.showToast({message:"未读取到module.json"})
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
