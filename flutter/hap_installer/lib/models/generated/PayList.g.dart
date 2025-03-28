// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../PayList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayList _$PayListFromJson(Map<String, dynamic> json) => _PayList(
  time: json['time'] as String? ?? "",
  payList:
      (json['payList'] as List<dynamic>?)
          ?.map((e) => PayInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PayListToJson(_PayList instance) => <String, dynamic>{
  'time': instance.time,
  'payList': instance.payList,
};

_PayInfo _$PayInfoFromJson(Map<String, dynamic> json) => _PayInfo(
  nick: json['nick'] as String? ?? "",
  amount: json['amount'] as String? ?? "",
);

Map<String, dynamic> _$PayInfoToJson(_PayInfo instance) => <String, dynamic>{
  'nick': instance.nick,
  'amount': instance.amount,
};
