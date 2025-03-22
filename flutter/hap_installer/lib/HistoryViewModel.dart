import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
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
