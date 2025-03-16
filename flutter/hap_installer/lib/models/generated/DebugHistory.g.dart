// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../DebugHistory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebugHistory _$DebugHistoryFromJson(
  Map<String, dynamic> json,
) => _DebugHistory(
  hapInfo: HapInfo.fromJson(json['hapInfo'] as Map<String, dynamic>),
  finished: json['finished'] as bool? ?? false,
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
  setps:
      (json['setps'] as List<dynamic>?)
          ?.map((e) => SetpInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [
        SetpInfo(name: "登录检查"),
        SetpInfo(name: "连接状态检查"),
        SetpInfo(name: "签名应用"),
        SetpInfo(name: "安装应用"),
      ],
);

Map<String, dynamic> _$DebugHistoryToJson(_DebugHistory instance) =>
    <String, dynamic>{
      'hapInfo': instance.hapInfo,
      'finished': instance.finished,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'setps': instance.setps,
    };

_SetpInfo _$SetpInfoFromJson(Map<String, dynamic> json) => _SetpInfo(
  name: json['name'] as String? ?? "",
  error: json['error'] as String? ?? null,
  loading: json['loading'] as bool? ?? null,
);

Map<String, dynamic> _$SetpInfoToJson(_SetpInfo instance) => <String, dynamic>{
  'name': instance.name,
  'error': instance.error,
  'loading': instance.loading,
};
