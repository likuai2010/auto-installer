// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../AuthInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthInfo _$AuthInfoFromJson(Map<String, dynamic> json) => AuthInfo(
      accessToken: json['accessToken'] as String?,
      userId: json['userId'] as String?,
      jwtToken: json['jwtToken'] as String?,
    )
      ..teamId = json['teamId'] as String?
      ..nickName = json['nickName'] as String?;

Map<String, dynamic> _$AuthInfoToJson(AuthInfo instance) => <String, dynamic>{
      'accessToken': instance.accessToken,
      'userId': instance.userId,
      'teamId': instance.teamId,
      'nickName': instance.nickName,
      'jwtToken': instance.jwtToken,
    };
