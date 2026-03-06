
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/DebugAppList.freezed.dart';
part 'generated/DebugAppList.g.dart';

@unfreezed
abstract class DebugAppList with _$DebugAppList {
   factory DebugAppList({
    @Default("") String time,
    @Default([]) List<DebugApp> payList,
  }) = _DebugAppList;
  factory DebugAppList.fromJson(Map<String, dynamic> json) =>
      _$DebugAppListFromJson(json);
}


@freezed
abstract class DebugApp with _$DebugApp {
  const factory DebugApp({
    @Default("") String packageName,
    @Default("") String label,
    @Default("") String icon,
    @Default(null) DateTime? installTime,
    @Default(null) DateTime? certEndTime,
    @Default("") String? appPath,
  }) = _DebugApp;
  factory DebugApp.fromJson(Map<String, dynamic> json) =>
      _$DebugAppFromJson(json);
}
