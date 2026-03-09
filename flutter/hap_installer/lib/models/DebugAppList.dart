
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hap_installer/models/HapInfo.dart';

part 'generated/DebugAppList.freezed.dart';
part 'generated/DebugAppList.g.dart';

@unfreezed
abstract class DebugAppList with _$DebugAppList {
   factory DebugAppList({
    @Default([]) List<DebugApp> appList,
    @Default(null) DateTime? time,
  }) = _DebugAppList;
  factory DebugAppList.fromJson(Map<String, dynamic> json) =>
      _$DebugAppListFromJson(json);
}


@freezed
abstract class DebugApp with _$DebugApp {
  const factory DebugApp({
    @Default("") String packageName,
    @Default(null) HapInfo? appInfo,
    @Default(null) DateTime? installTime,
    @Default(null) DateTime? certEndTime,
    @Default(false) bool canReInstall,
    @Default(false) bool isGame,
  }) = _DebugApp;
  factory DebugApp.fromJson(Map<String, dynamic> json) =>
      _$DebugAppFromJson(json);
}
