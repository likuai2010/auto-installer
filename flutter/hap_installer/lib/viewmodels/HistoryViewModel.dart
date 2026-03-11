import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/pages/history/debug_detail_page.dart';
import 'package:hap_installer/pages/more/more_page.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/PayList.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:x509/x509.dart';

import 'package:path/path.dart' as path;
import '../hdc/common.dart';
class HistoryViewModel extends ChangeNotifier {
  List<DebugHistory> historyList = [];

  DebugAppList appList = DebugAppList();

  PayList payList = const PayList();

  DebugHistory? current;
  bool loadingAppList = false;
  bool loadingUninstall = false;
  bool loadingReinstall = false;
  bool loadingGameMode = false;


  fetchDebugApp() async {
    var appListPath = path.join(await getAppDir(), "debug_app_list.json");
    if (!await File(appListPath).exists()) return;
  }
  Future<DebugAppList?> readDebugApp(String appPath) async {
    if (!await File(appPath).exists()) return null;
    final json = await File(appPath).readAsString();
    return DebugAppList.fromJson(jsonDecode(json));
  }

  initDebugAppList() async {
    if(loadingAppList) return;
    loadingAppList = true;
    notifyListeners();
    try {
      var debugList = await getDebugApp();
      if(debugList == null){
        debugList = DebugAppList(time: DateTime.now(), appList: []);
        var result = await cmd.dumpAppPackageName();
        if(result == null || result.contains("Fail") ) return;
        var packageNames = result.split("\n") ?? [];
        List<DebugApp> list = [];
        for (var element in packageNames.skip(1)) {
          if(element.trim().isNotEmpty){
              list.add(DebugApp(packageName: element.trim()));
          }
        }
        debugList = debugList.copyWith(appList: list);
      }
      await updateDebugAppList(debugList);
      await saveDebugApp(debugList);  
      final list = debugList.appList..sort((a, b) => b.appInfo?.label.compareTo(a.appInfo?.label ?? "") ?? 0);
      appList = debugList.copyWith(appList: list);
      loadingAppList = false;
      notifyListeners();
    } catch (e) {
      loadingAppList = false;
      notifyListeners();
    }
  }
  updateDebugApp(HapInfo info, String cerPath) async {
    if(appList.appList.isEmpty)
      return;
    try {
        var endTime = await readEndTime(cerPath);
        var debugList = appList.appList.toList(growable: true);
        var index = appList.appList.indexWhere((d) => d.packageName == info.packageName);
        if (index > -1){
          debugList[index] = debugList[index].copyWith(appInfo: info, certEndTime: endTime);
        }else{
          debugList.add(DebugApp(packageName: info.packageName, appInfo: info, certEndTime: endTime));
        }
        final list = debugList..sort((a, b) => b.appInfo?.label.compareTo(a.appInfo?.label ?? "") ?? 0);
        appList = appList.copyWith(time: DateTime.now(), appList: list);
        notifyListeners();
        await saveDebugApp(appList);
        await pushIcons(info);
    }catch(e){
        print("updateDebugApp filuare" + e.toString());
    }
  }
 
  readEndTime(String cerPath) async{
    var cert = parsePem(File(cerPath).readAsStringSync());
    var x509 = cert.lastOrNull as X509Certificate;
    var tbs = x509.tbsCertificate;
    return tbs.validity?.notAfter;
  }

  updateDebugAppList(DebugAppList list) async {
    for (int i = 0; i < list.appList.length; i++) {
      final app = list.appList[i];
      if (app.appInfo == null) {
        final appInfoFile = File(path.join((await getTempDir()), "apps", app.packageName.replaceAll(".", "_"), "hap_info.json"));
        if(await appInfoFile.exists()){
          final appInfo = HapInfo.fromJson(jsonDecode(appInfoFile.readAsStringSync()));
          list.appList[i] = app.copyWith(appInfo: appInfo);
        }
      }
      if(app.installTime == null) {
        var result = await cmd.dumpAppInstallTime(app.packageName);
        var installTime = result?.trim().split(",").first;
        if (installTime != null && installTime.contains("installTime")){
          final time = DateTime.fromMillisecondsSinceEpoch(int.parse(installTime.split(":").last.trim()));
          list.appList[i] = app.copyWith(installTime: time);
        }
      }
      if(list.appList[i].appInfo != null){
        final result = await pullIcons(list.appList[i].appInfo!);
        list.appList[i] = list.appList[i].copyWith(canReInstall: result);
      }
    }
    list.time = DateTime.now();
  }
  pushIcons(HapInfo info) async{
    var appDir = path.join(viewmodel.debugPath, info.packageName.replaceAll(".", "_"));
    final remote = "/data/local/tmp/${info.packageName.replaceAll(".", "_")}";
    for (var p in info.icon) {
      final iconPath = path.join(appDir, p);
      final targetPath ="$remote/$p";
      await cmd.makeDir(File(targetPath).parent.path);
      await cmd.sendFile(iconPath, targetPath);
    }
    for (var p in info.pathList) {
      final hapPath = "$remote/${path.basename(p)}";
      final size = await File(p).length();
      // 小于500M
      if (!await cmd.exitsPath(hapPath) && size < 1024 * 1024 * 500){
          await cmd.sendFile(p, hapPath);
      }
    }
  }
  pullIcons(HapInfo info) async {
    var appDir = path.join(viewmodel.debugPath, info.packageName.replaceAll(".", "_"));
    final remote = "/data/local/tmp/${info.packageName.replaceAll(".", "_")}";
    for (var p in info.icon) {
      final iconPath = path.join(appDir, p.trim());
      if(!await File(iconPath).exists()){
        await File(iconPath).parent.create(recursive: true);
        await cmd.recvFile("$remote/$p", iconPath);
      }
    }
    final newList = List<String>.empty(growable: true);
    for (var p in info.pathList) {
      final hapPath = "$remote/${path.basename(p)}";
      final localPath = path.join(appDir, path.basename(p));
      // 本地没有缓存就现在远程的
      if (!await File(localPath).exists() && await cmd.exitsPath(hapPath)){
        newList.add(localPath);
      } else if(await File(localPath).exists()){
        newList.add(localPath);
      }
    }
    return newList.length > 0;
  }
  downloadHap(HapInfo info) async {
    var appDir = path.join(viewmodel.debugPath, info.packageName.replaceAll(".", "_"));
    final remote = "/data/local/tmp/${info.packageName.replaceAll(".", "_")}";
    final newList = List<String>.empty(growable: true);
    for (var p in info.pathList) {
      final hapPath = "$remote/${path.basename(p)}";
      final localPath = path.join(appDir, path.basename(p));
      // 本地没有缓存就现在远程的
      if (!await File(localPath).exists() && await cmd.exitsPath(hapPath)){
        await cmd.recvFile(hapPath, appDir);
        newList.add(localPath);
      }else if(await File(localPath).exists()){
         newList.add(localPath);
      }
    }
    return info.copyWith(pathList: newList);
  }

  saveDebugApp(DebugAppList app) async{
    final file = File(path.join(await getAppDir(), "debug_app_list.json"));
    await file.writeAsString(jsonEncode(app.toJson()));
    final result = await cmd.sendFile(path.join(await getAppDir(), "debug_app_list.json"), "/data/local/tmp/debug_app_list.json");
    print("send debug app list: $result");
  }
  Future<DebugAppList?> getDebugApp() async{
    var appPath = path.join(await getAppDir(), "debug_app_list.json");
    var file = File(appPath);
    if (await file.exists()){
      await file.delete();
    }
    var result = await cmd.recvFile("/data/local/tmp/debug_app_list.json", appPath);
    print("recv debug app list: $result");
    if(result!.contains("[Fail]") && result!.contains("Unauthorized")){
      throw FormatException("设备未授权");
    }
    return readDebugApp(appPath);
  }

  fetchPayList() async {
    final json = await rootBundle.loadString("assets/pay/list.json");
    payList = PayList.fromJson(jsonDecode(json));
    notifyListeners();
  }
  unInstall(HapInfo info) async{
    if(loadingUninstall)
      return;
    loadingUninstall = true;
    notifyListeners();
    var index = appList.appList.indexWhere((d) => d.packageName == info.packageName);
    var list = appList.appList.toList();
    await cmd.unInstall(info.packageName);
    list.removeAt(index);
    appList = appList.copyWith(appList: list);
    await saveDebugApp(appList);
    loadingUninstall = false;
    notifyListeners();
  }
  reInstall(BuildContext context, HapInfo hap, bool reCert) async{
    if(loadingReinstall)
      return;
    loadingReinstall = true;
    notifyListeners();
    try{
        hap = await downloadHap(hap);
        await getByHap(hap.pathList.last, "module.json", viewmodel.debugPath);
        toPage(context, (_) => const DebugDetailPage());
        await viewmodel.installHap(context, hap);
    } on FormatException catch (e) {
      toask(context, e.message);
    }catch (e) {
      toask(context, "$e");
    }

    loadingReinstall = false;
    notifyListeners();
  }
  setGame(DebugApp app, BuildContext context) async {
    if (loadingGameMode)
      return;
    loadingGameMode = true;
    notifyListeners();
    var result = await cmd.setGameMode(app.packageName, !app.isGame);
    if(result?.contains("success") == true){
      var index = appList.appList.indexWhere((d) => d.packageName == app.packageName);
      var appInfo = appList.appList[index];
      appList.appList[index] = appInfo.copyWith(isGame: !appInfo.isGame);
      await saveDebugApp(appList);
    }else{
      toask(context, "切换失败:$result");
    }
    loadingGameMode =false;
    notifyListeners();
  }

  createDebugHistory(HapInfo hapInfo) {
    current = DebugHistory(hapInfo: hapInfo);
    addDebugHistory(current!);
  }

  updateHistory(Function(DebugHistory) update) {
    if (current != null) {
      update(current!);
    }
    notifyListeners();
  }

  resetProfile(BuildContext context) async {
    final profile = File(viewmodel.signConfig?.profilePath ?? "");
    viewmodel.signConfig?.certId = "";
    if (await profile.exists()) {
      await profile.delete();
    }
    toask(context, "证书和Profile已重置, 请重新签名.");
  }

  updateStep(int index, Function(SetpInfo) update) {
    if (current != null && index < current!.setps.length) {
      List<SetpInfo> modifiableList = List.from(current!.setps);
      modifiableList[index] = update(current!.setps[index]);
      current!.setps = modifiableList;
    }
    notifyListeners();
  }

  Future<bool> startSetp(
    int index,
    Future<String?> Function() builder, [
    String? label,
  ]) async {
    updateStep(index, (setp) {
      return setp.copyWith(loading: true, error: "正在${label ?? setp.name}...");
    });
    try {
      final error = await builder();
      updateStep(index, (setp) {
        return setp.copyWith(loading: false, error: error);
      });
      return error == null;
    } on FormatException catch (e) {
      updateStep(index, (setp) {
        return setp.copyWith(
          loading: false,
          error: "${label ?? setp.name}失败: ${e.message}",
        );
      });
      return false;
    } catch (e) {
      updateStep(index, (setp) {
        return setp.copyWith(
          loading: false,
          error: "${label ?? setp.name}失败: $e",
        );
      });
      return false;
    }
  }

  selectDebugHistory(DebugHistory history) {
    current = history;
    notifyListeners();
  }

  addDebugHistory(DebugHistory history) {
    historyList.add(history);
    notifyListeners();
  }


}
