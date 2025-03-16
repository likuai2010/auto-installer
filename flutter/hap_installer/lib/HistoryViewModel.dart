import 'package:flutter/material.dart';
import 'package:hap_installer/DebugHapState.dart';
import 'package:hap_installer/models/HapInfo.dart';


class DebugHistory{
    DebugHistory({required this.hapInfo});
    HapInfo hapInfo;
    DateTime start = DateTime.now();
    DateTime end = DateTime.now();
    List<SetpInfo> setps = [SetpInfo(name: "登录检查"), SetpInfo(name: "连接状态检查"), SetpInfo(name: "签名应用"), SetpInfo(name: "安装应用")];
}


class HistoryViewModel extends ChangeNotifier{
    List<DebugHistory> historyList = [DebugHistory(hapInfo: HapInfo(packageName: "xxx", filePath: "xxxx"))];
    DebugHistory? current;

    fetchDebugHistory(){
    }
    createDebugHistory(HapInfo hapInfo){
      current = DebugHistory(hapInfo: hapInfo);
      addDebugHistory(current!);
    }
    updateHistory(Function(DebugHistory) update) {
      if (current != null){
         update(current!);
      }
      notifyListeners();
    }
    selectDebugHistory(DebugHistory history){
      current = history;
      notifyListeners();
    }
    addDebugHistory(DebugHistory history){
      historyList.add(history);
      notifyListeners();
    }
}
