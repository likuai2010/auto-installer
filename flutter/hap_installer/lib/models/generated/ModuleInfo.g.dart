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
    );

Map<String, dynamic> _$$AppInfoImplToJson(_$AppInfoImpl instance) =>
    <String, dynamic>{
      'bundleName': instance.bundleName,
      'compileSdkVersion': instance.compileSdkVersion,
      'versionName': instance.versionName,
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
    );

Map<String, dynamic> _$$ModuleImplToJson(_$ModuleImpl instance) =>
    <String, dynamic>{
      'requestPermissions': instance.requestPermissions,
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
