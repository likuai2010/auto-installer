import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hap_installer/models/HapInfo.dart';

part 'generated/DebugHistory.freezed.dart';
part 'generated/DebugHistory.g.dart';

@unfreezed
abstract class DebugHistory with _$DebugHistory {
  factory DebugHistory({
    required HapInfo hapInfo,
    @Default(false) bool finished,
    @Default(null) DateTime? start,
    @Default(null) DateTime? end,
    @Default([
      SetpInfo(name: "登录检查"),
      SetpInfo(name: "连接状态检查"),
      SetpInfo(name: "签名应用"),
      SetpInfo(name: "安装应用"),
    ])
    List<SetpInfo> setps,
  }) = _DebugHistory;
  factory DebugHistory.fromJson(Map<String, dynamic> json) =>
      _$DebugHistoryFromJson(json);
}

@freezed
abstract class SetpInfo with _$SetpInfo {
  const factory SetpInfo({
    @Default("") String name,
    @Default(null) String? error,
    @Default(null) bool? loading,
  }) = _SetpInfo;
  factory SetpInfo.fromJson(Map<String, dynamic> json) =>
      _$SetpInfoFromJson(json);
}
