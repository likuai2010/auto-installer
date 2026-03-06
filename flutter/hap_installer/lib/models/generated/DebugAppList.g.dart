// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../DebugAppList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebugAppListImpl _$$DebugAppListImplFromJson(Map<String, dynamic> json) =>
    _$DebugAppListImpl(
      time: json['time'] as String? ?? "",
      payList: (json['payList'] as List<dynamic>?)
              ?.map((e) => DebugApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DebugAppListImplToJson(_$DebugAppListImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'payList': instance.payList,
    };

_$DebugAppImpl _$$DebugAppImplFromJson(Map<String, dynamic> json) =>
    _$DebugAppImpl(
      packageName: json['packageName'] as String? ?? "",
      label: json['label'] as String? ?? "",
      icon: json['icon'] as String? ?? "",
      installTime: json['installTime'] == null
          ? null
          : DateTime.parse(json['installTime'] as String),
      certEndTime: json['certEndTime'] == null
          ? null
          : DateTime.parse(json['certEndTime'] as String),
      appPath: json['appPath'] as String? ?? "",
    );

Map<String, dynamic> _$$DebugAppImplToJson(_$DebugAppImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'label': instance.label,
      'icon': instance.icon,
      'installTime': instance.installTime?.toIso8601String(),
      'certEndTime': instance.certEndTime?.toIso8601String(),
      'appPath': instance.appPath,
    };
