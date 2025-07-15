import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'generated/ModuleInfo.freezed.dart';
part 'generated/ModuleInfo.g.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const factory AppInfo({
    @Default("") String bundleName,
    @Default("") String compileSdkVersion,
    @Default("") String versionName,
  }) = _AppInfo;
  // 从JSON构建
  factory AppInfo.fromJson(Map<String, dynamic> json) =>
      _$AppInfoFromJson(json);
}




@freezed
abstract class HnpPackage with _$HnpPackage {
  const factory HnpPackage({
    @Default("") String package,
    @Default("") String type,
  }) = _HnpPackage;
  // 从JSON构建
  factory HnpPackage.fromJson(Map<String, dynamic> json) =>
      _$HnpPackageFromJson(json);
}

@freezed
abstract class RequestPermission with _$RequestPermission {
  const factory RequestPermission({@Default("") String name}) =
      _RequestPermission;
  // 从JSON构建
  factory RequestPermission.fromJson(Map<String, dynamic> json) =>
      _$RequestPermissionFromJson(json);
}

@freezed
abstract class Module with _$Module {
  const factory Module({
    @Default([]) List<RequestPermission> requestPermissions,
    @Default([]) List<String> deviceTypes,
    @Default([]) List<HnpPackage> hnpPackages,
  }) = _Module;
  // 从JSON构建
  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
}

@freezed
abstract class ModuleInfo with _$ModuleInfo {
  const factory ModuleInfo({
    @Default(null) AppInfo? app,
    @Default(null) Module? module,
  }) = _ModuleInfo;
  // 从JSON构建
  factory ModuleInfo.fromJson(Map<String, dynamic> json) =>
      _$ModuleInfoFromJson(json);
}
