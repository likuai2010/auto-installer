// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../PayList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayListImpl _$$PayListImplFromJson(Map<String, dynamic> json) =>
    _$PayListImpl(
      time: json['time'] as String? ?? "",
      payList: (json['payList'] as List<dynamic>?)
              ?.map((e) => PayInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PayListImplToJson(_$PayListImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'payList': instance.payList,
    };

_$PayInfoImpl _$$PayInfoImplFromJson(Map<String, dynamic> json) =>
    _$PayInfoImpl(
      nick: json['nick'] as String? ?? "",
      amount: json['amount'] as String? ?? "",
    );

Map<String, dynamic> _$$PayInfoImplToJson(_$PayInfoImpl instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'amount': instance.amount,
    };
