// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../DebugHistory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebugHistoryImpl _$$DebugHistoryImplFromJson(Map<String, dynamic> json) =>
    _$DebugHistoryImpl(
      hapInfo: HapInfo.fromJson(json['hapInfo'] as Map<String, dynamic>),
      finished: json['finished'] as bool? ?? false,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      setps: (json['setps'] as List<dynamic>?)
              ?.map((e) => SetpInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DebugHistoryImplToJson(_$DebugHistoryImpl instance) =>
    <String, dynamic>{
      'hapInfo': instance.hapInfo,
      'finished': instance.finished,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'setps': instance.setps,
    };

_$SetpInfoImpl _$$SetpInfoImplFromJson(Map<String, dynamic> json) =>
    _$SetpInfoImpl(
      name: json['name'] as String? ?? "",
      error: json['error'] as String? ?? null,
      loading: json['loading'] as bool? ?? null,
    );

Map<String, dynamic> _$$SetpInfoImplToJson(_$SetpInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'error': instance.error,
      'loading': instance.loading,
    };
