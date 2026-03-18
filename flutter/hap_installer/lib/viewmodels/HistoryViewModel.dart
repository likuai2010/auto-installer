import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/pages/history/debug_detail_page.dart';
import 'package:hap_installer/pages/more/more_page.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/PayList.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
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
  String packageName = "com.xiaobai.hap_installer";
  Future<DebugAppList> initHapInstaller(DebugAppList debugList) async{
    var appList = debugList.appList..sort((a, b) => b.appInfo?.label.compareTo(a.appInfo?.label ?? "") ?? 0);;
    if(ohosAdapter.isOhos){
      var appDir = path.join(viewmodel.debugPath, packageName.replaceAll(".", "_"));
      var hapInstaller = appList.firstWhere((f)=>f.packageName == packageName, orElse:  ()=> new DebugApp(packageName: packageName, canReInstall: false));
      if(hapInstaller.appInfo == null){
        final hapInfo = await dumpHapInfo(["/data/storage/el1/bundle/entry.hap"], viewmodel.debugPath);
        hapInstaller = hapInstaller.copyWith(appInfo: hapInfo);
      }
      final hapFile = File(path.join(appDir, path.basename(hapInstaller.appInfo!.pathList.first)));
      if(!await hapFile.exists()){
        if(! await hapFile.parent.exists()){
          await hapFile.parent.create();
        }

        await File("/data/storage/el1/bundle/entry.hap").copy(hapFile.path);
      }
      appList.removeWhere((f)=>f.packageName == packageName);
      appList = [hapInstaller, ...appList];
    }
     return debugList.copyWith(appList: appList);
  }
  initDebugAppList() async {
    if(loadingAppList) return;
    loadingAppList = true;
    notifyListeners();
    try {
      var debugList = await getDebugApp();
      var result = await cmd.dumpAppPackageName();
      if(debugList == null){
        debugList = DebugAppList(time: DateTime.now(), appList: []);
        if(result == null || result.contains("Fail") ){
           loadingAppList = false;
          return;
        }
        var packageNames = result.split("\n") ?? [];
        List<DebugApp> list = [];
        for (var element in packageNames.skip(1)) {
          if(element.trim().isNotEmpty){
              list.add(DebugApp(packageName: element.trim()));
          }
        }
        debugList = debugList.copyWith(appList: list);
      }else{
        if(result != null && !result.contains("Fail")){
          final filter = debugList.appList.where((d)=>result.contains(d.packageName)).toList();
          debugList = debugList.copyWith(appList: filter);
        }
      }
      debugList = await initHapInstaller(debugList);
      await updateDebugAppList(debugList);
      await saveDebugApp(debugList);  
      appList = debugList;
      loadingAppList = false;
      notifyListeners();
    } catch (e) {
      loadingAppList = false;
      notifyListeners();
    }
  }
  updateDebugApp(HapInfo info, String? cerPath) async {
    if(loadingAppList){
      return;
    }
    try {
        var endTime = cerPath != null ? await readEndTime(cerPath) : null;
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
    } catch(e){
        print("updateDebugApp filuare" + e.toString());
    }
  }
 
  readEndTime(String cerPath) async{
    var cert = parsePem(File(cerPath).readAsStringSync());
    var x509 = cert.lastOrNull as X509Certificate;
    var tbs = x509.tbsCertificate;
    return tbs.validity?.notAfter;
  }
  addCalendar(BuildContext context, DebugApp app) async{
    if(app.appInfo != null){
      final result = await ohosAdapter.addCalendar(app.appInfo!.label, app.certEndTime!.millisecondsSinceEpoch);
      if(result){
        toask(context, "添加系统日历成功");
      }else{
        toask(context, "添加系统日历失败");
      }
    }else{
       toask(context, "不支持提醒");
    }
  }

  updateDebugAppList(DebugAppList list) async {
    var needInstallTimes = List<String>.empty(growable: true);
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
        needInstallTimes.add(app.packageName);
      }
      if(list.appList[i].appInfo != null){
        final result = await pullIcons(list.appList[i].appInfo!);
        list.appList[i] = list.appList[i].copyWith(canReInstall: result);
      }
    }
    if(needInstallTimes.isNotEmpty){
      final result = await cmd.dumpAppInstallTimes(needInstallTimes);
      var installTime = result!.trim().split(",");
      var timeDict = <String, DateTime>{};
      for (int i = 0; i < needInstallTimes.length; i++) {
          final p = needInstallTimes[i];
          final timeString = installTime[i];
          final time = DateTime.fromMillisecondsSinceEpoch(int.parse(timeString.split(":").last.trim()));
          timeDict[p] = time;
      }
      for (var i = 0; i < list.appList.length; i++) {
          final app = list.appList[i];
          if(timeDict.containsKey(app.packageName)){
            list.appList[i] = app.copyWith(installTime: timeDict[app.packageName]);
          }
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
      final file = File(p);
      await file.rename(path.join(appDir, path.basename(p)));
      // 小于500M
      if (!await cmd.exitsPath(hapPath) && await file.length() < 1024 * 1024 * 500){
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
      if(await File(localPath).exists()){
        newList.add(localPath);
      } else if (await cmd.exitsPath(hapPath)){
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
      if(await File(localPath).exists()){
          newList.add(localPath);
      }else if(await cmd.exitsPath(hapPath)){
          await cmd.recvFile(hapPath, appDir);
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
  unInstall(String packageName) async{
    if(loadingUninstall)
      return;
    loadingUninstall = true;
    notifyListeners();
    var index = appList.appList.indexWhere((d) => d.packageName == packageName);
    var list = appList.appList.toList();
    await cmd.unInstall(packageName);
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
        if(hap.acl.isEmpty){
          await getByHap(hap.pathList.last, "module.json", viewmodel.debugPath);
          final module = await await cmd.readModuleInfo(viewmodel.debugPath);
          hap = hap.copyWith(acl: eco.getAcl(module));
        }
        toPage(context, (_) => const DebugDetailPage());
        await viewmodel.installHap(hap, reCert, true);
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
  DebugHistory createDebugHistory(HapInfo hapInfo) {
    var current = DebugHistory(hapInfo: hapInfo);
    addDebugHistory(current);
    return current;
  }

  updateHistory(DebugHistory debug, Function(DebugHistory) update) {
    current = debug;
    update(debug);
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
  Future<bool> newSetp(
    DebugHistory record,
    String label,
    Future<String?> Function() builder
  ) async {
    final newSetp = SetpInfo(name: label);
    List<SetpInfo> modifiableList = List.from(current!.setps);
    modifiableList.add(newSetp);
    record.setps = modifiableList;
    final index = record.setps.length - 1;
    notifyListeners();
    updateStep(index, (setp) {
      return setp.copyWith(loading: true, error: "正在${label}...");
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
          error: "$label失败: ${e.message}",
        );
      });
      return false;
    } catch (e) {
      updateStep(index, (setp) {
        return setp.copyWith(
          loading: false,
          error: "$label失败: $e",
        );
      });
      return false;
    }
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

final historyViewmodel = HistoryViewModel();