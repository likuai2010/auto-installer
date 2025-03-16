import 'package:flutter/material.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/models/HapInfo.dart';

class HistoryViewModel extends ChangeNotifier {
  List<DebugHistory> historyList = [];
  DebugHistory? current;

  fetchDebugHistory() {}
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

  updateSetp(int index, Function(SetpInfo) update) {
    if (current != null && index < current!.setps.length) {
      List<SetpInfo> modifiableList = List.from(current!.setps);
      modifiableList[index] = update(current!.setps[index]);
      current!.setps = modifiableList;
    }
    notifyListeners();
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
