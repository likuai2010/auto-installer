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
  readDebugApp(String appPath) async {
    if (!await File(appPath).exists()) return null;
    final json = await File(appPath).readAsString();
    return DebugAppList.fromJson(jsonDecode(json));
  }

  initDebugAppList() async {
    loading = true;
    var debugList = await getDebugApp();
    if(debugList == null){
      debugList = DebugAppList();
      var result = await cmd.dumpAppPackageName();
      var packageNames = result?.split("\n") ?? [];
      List<DebugApp> list = [];
      for (var element in packageNames) {
        if(element.trim().isNotEmpty){
         list.add(DebugApp(packageName: element.trim()));
        }
      }
      debugList = debugList.copyWith(payList: list);
    }
    await saveDebugApp(debugList);
    appList = debugList;
    notifyListeners();
    loading = false;
  }

  saveDebugApp(DebugAppList app) async{
    final file = File(path.join(await getAppDir(), "debug_app_list.json"));
    await file.writeAsString(jsonEncode(app.toJson()));
    await cmd.sendFile(path.join(await getAppDir(), "debug_app_list.json"), "/data/local/tmp/debug_app_list.json");
  }
  getDebugApp() async{
    var appPath = path.join(await getAppDir(), "debug_app_list.json");
    await cmd.recvFile("/data/local/tmp/debug_app_list.json", appPath);
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
