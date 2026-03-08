// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../DebugAppList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebugAppListImpl _$$DebugAppListImplFromJson(Map<String, dynamic> json) =>
    _$DebugAppListImpl(
      appList: (json['appList'] as List<dynamic>?)
              ?.map((e) => DebugApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$DebugAppListImplToJson(_$DebugAppListImpl instance) =>
    <String, dynamic>{
      'appList': instance.appList,
      'time': instance.time?.toIso8601String(),
    };

_$DebugAppImpl _$$DebugAppImplFromJson(Map<String, dynamic> json) =>
    _$DebugAppImpl(
      packageName: json['packageName'] as String? ?? "",
      appInfo: json['appInfo'] == null
          ? null
          : HapInfo.fromJson(json['appInfo'] as Map<String, dynamic>),
      installTime: json['installTime'] == null
          ? null
          : DateTime.parse(json['installTime'] as String),
      certEndTime: json['certEndTime'] == null
          ? null
          : DateTime.parse(json['certEndTime'] as String),
      canReInstall: json['canReInstall'] as bool? ?? false,
    );

Map<String, dynamic> _$$DebugAppImplToJson(_$DebugAppImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'appInfo': instance.appInfo,
      'installTime': instance.installTime?.toIso8601String(),
      'certEndTime': instance.certEndTime?.toIso8601String(),
      'canReInstall': instance.canReInstall,
    };
