// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ModuleInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppInfo _$AppInfoFromJson(Map<String, dynamic> json) => _AppInfo(
  bundleName: json['bundleName'] as String? ?? "",
  compileSdkVersion: json['compileSdkVersion'] as String? ?? "",
  versionName: json['versionName'] as String? ?? "",
);

Map<String, dynamic> _$AppInfoToJson(_AppInfo instance) => <String, dynamic>{
  'bundleName': instance.bundleName,
  'compileSdkVersion': instance.compileSdkVersion,
  'versionName': instance.versionName,
};

_RequestPermission _$RequestPermissionFromJson(Map<String, dynamic> json) =>
    _RequestPermission(name: json['name'] as String? ?? "");

Map<String, dynamic> _$RequestPermissionToJson(_RequestPermission instance) =>
    <String, dynamic>{'name': instance.name};

_Module _$ModuleFromJson(Map<String, dynamic> json) => _Module(
  requestPermissions:
      (json['requestPermissions'] as List<dynamic>?)
          ?.map((e) => RequestPermission.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ModuleToJson(_Module instance) => <String, dynamic>{
  'requestPermissions': instance.requestPermissions,
};

_ModuleInfo _$ModuleInfoFromJson(Map<String, dynamic> json) => _ModuleInfo(
  app:
      json['app'] == null
          ? null
          : AppInfo.fromJson(json['app'] as Map<String, dynamic>),
  module:
      json['module'] == null
          ? null
          : Module.fromJson(json['module'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ModuleInfoToJson(_ModuleInfo instance) =>
    <String, dynamic>{'app': instance.app, 'module': instance.module};
