import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/HapInfo.freezed.dart';
part 'generated/HapInfo.g.dart';

@freezed
abstract class HapInfo with _$HapInfo {
  const factory HapInfo({
    @Default("") String packageName,
    @Default([]) List<String> pathList,
    @Default(null) String? version,
    @Default(null) String? icon,
    @Default([]) List<String> deviceType,
  }) = _HapInfo;
  factory HapInfo.fromJson(Map<String, dynamic> json) =>
      _$HapInfoFromJson(json);
}
