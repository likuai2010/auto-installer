// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ModuleInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppInfoImpl _$$AppInfoImplFromJson(Map<String, dynamic> json) =>
    _$AppInfoImpl(
      bundleName: json['bundleName'] as String? ?? "",
      compileSdkVersion: json['compileSdkVersion'] as String? ?? "",
      versionName: json['versionName'] as String? ?? "",
      icon: json['icon'] as String? ?? "",
      label: json['label'] as String? ?? "",
    );

Map<String, dynamic> _$$AppInfoImplToJson(_$AppInfoImpl instance) =>
    <String, dynamic>{
      'bundleName': instance.bundleName,
      'compileSdkVersion': instance.compileSdkVersion,
      'versionName': instance.versionName,
      'icon': instance.icon,
      'label': instance.label,
    };

_$HnpPackageImpl _$$HnpPackageImplFromJson(Map<String, dynamic> json) =>
    _$HnpPackageImpl(
      package: json['package'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$$HnpPackageImplToJson(_$HnpPackageImpl instance) =>
    <String, dynamic>{
      'package': instance.package,
      'type': instance.type,
    };

_$RequestPermissionImpl _$$RequestPermissionImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestPermissionImpl(
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$$RequestPermissionImplToJson(
        _$RequestPermissionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$ModuleImpl _$$ModuleImplFromJson(Map<String, dynamic> json) => _$ModuleImpl(
      requestPermissions: (json['requestPermissions'] as List<dynamic>?)
              ?.map(
                  (e) => RequestPermission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      deviceTypes: (json['deviceTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hnpPackages: (json['hnpPackages'] as List<dynamic>?)
              ?.map((e) => HnpPackage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String? ?? "",
      packageName: json['packageName'] as String? ?? "",
    );

Map<String, dynamic> _$$ModuleImplToJson(_$ModuleImpl instance) =>
    <String, dynamic>{
      'requestPermissions': instance.requestPermissions,
      'deviceTypes': instance.deviceTypes,
      'hnpPackages': instance.hnpPackages,
      'name': instance.name,
      'packageName': instance.packageName,
    };

_$ModuleInfoImpl _$$ModuleInfoImplFromJson(Map<String, dynamic> json) =>
    _$ModuleInfoImpl(
      app: json['app'] == null
          ? null
          : AppInfo.fromJson(json['app'] as Map<String, dynamic>),
      module: json['module'] == null
          ? null
          : Module.fromJson(json['module'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ModuleInfoImplToJson(_$ModuleInfoImpl instance) =>
    <String, dynamic>{
      'app': instance.app,
      'module': instance.module,
    };
