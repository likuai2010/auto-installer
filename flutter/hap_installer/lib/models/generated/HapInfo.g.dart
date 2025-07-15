// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../HapInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HapInfoImpl _$$HapInfoImplFromJson(Map<String, dynamic> json) =>
    _$HapInfoImpl(
      packageName: json['packageName'] as String? ?? "",
      pathList: (json['pathList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      version: json['version'] as String? ?? null,
      icon: json['icon'] as String? ?? null,
      deviceType: (json['deviceType'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$HapInfoImplToJson(_$HapInfoImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'pathList': instance.pathList,
      'version': instance.version,
      'icon': instance.icon,
      'deviceType': instance.deviceType,
    };
