// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../HapInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HapInfo _$HapInfoFromJson(Map<String, dynamic> json) => _HapInfo(
  packageName: json['packageName'] as String? ?? "",
  filePath: json['filePath'] as String? ?? '',
  version: json['version'] as String? ?? null,
  icon: json['icon'] as String? ?? null,
);

Map<String, dynamic> _$HapInfoToJson(_HapInfo instance) => <String, dynamic>{
  'packageName': instance.packageName,
  'filePath': instance.filePath,
  'version': instance.version,
  'icon': instance.icon,
};
