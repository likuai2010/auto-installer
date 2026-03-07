import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/PayList.dart';
import 'package:path/path.dart' as path;
import '../hdc/common.dart';

class HistoryViewModel extends ChangeNotifier {
  List<DebugHistory> historyList = [];

  DebugAppList appList = DebugAppList();

  PayList payList = const PayList();

  DebugHistory? current;
  bool loading = false;


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
    if(loading) return;
    loading = true;
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
      loading = false;
      notifyListeners();
    } catch (e) {
     loading = false;
    }
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
        if(app.installTime == null){
          var result = await cmd.dumpAppInstallTime(app.packageName);
          var installTime = result?.trim().split(",").first;
          if(installTime !=null && installTime.contains("installTime")){
            final time = DateTime.fromMillisecondsSinceEpoch(int.parse(installTime.split(":").last.trim()));
            list.appList[i] = app.copyWith(installTime: time);
          }
        }
      }
      list.time = DateTime.now();
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
    return readDebugApp(appPath);
  }




  fetchPayList() async {
    final json = await rootBundle.loadString("assets/pay/list.json");
    payList = PayList.fromJson(jsonDecode(json));
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
