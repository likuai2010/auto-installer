// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../EcoResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EcoResult _$EcoResultFromJson(Map<String, dynamic> json) => _EcoResult(
  code: (json['code'] as num?)?.toInt() ?? 0,
  msg: json['msg'] as String? ?? '',
  teams:
      (json['teams'] as List<dynamic>?)
          ?.map((e) => TeamInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  certList:
      (json['certList'] as List<dynamic>?)
          ?.map((e) => CertInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  userInfo:
      json['userInfo'] == null
          ? null
          : AuthInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
  harmonyCert:
      json['harmonyCert'] == null
          ? null
          : CertInfo.fromJson(json['harmonyCert'] as Map<String, dynamic>),
  urlsInfo:
      (json['urlsInfo'] as List<dynamic>?)
          ?.map((e) => UrlInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  provisionFileUrl: json['provisionFileUrl'] as String? ?? null,
);

Map<String, dynamic> _$EcoResultToJson(_EcoResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'teams': instance.teams,
      'list': instance.list,
      'certList': instance.certList,
      'userInfo': instance.userInfo,
      'harmonyCert': instance.harmonyCert,
      'urlsInfo': instance.urlsInfo,
      'provisionFileUrl': instance.provisionFileUrl,
    };

_UrlInfo _$UrlInfoFromJson(Map<String, dynamic> json) =>
    _UrlInfo(newUrl: json['newUrl'] as String? ?? "");

Map<String, dynamic> _$UrlInfoToJson(_UrlInfo instance) => <String, dynamic>{
  'newUrl': instance.newUrl,
};

_TeamInfo _$TeamInfoFromJson(Map<String, dynamic> json) => _TeamInfo(
  id: json['id'] as String? ?? "",
  name: json['name'] as String? ?? '',
  countryCode: json['countryCode'] as String? ?? "",
  lastLoginTime: json['lastLoginTime'] as String? ?? "",
);

Map<String, dynamic> _$TeamInfoToJson(_TeamInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'countryCode': instance.countryCode,
  'lastLoginTime': instance.lastLoginTime,
};

_DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => _DeviceInfo(
  id: json['id'] as String? ?? "",
  deviceName: json['deviceName'] as String? ?? "",
  udid: json['udid'] as String? ?? "",
  deviceType: (json['deviceType'] as num?)?.toInt() ?? 0,
  createTime: json['createTime'] as String? ?? "",
  status: (json['status'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DeviceInfoToJson(_DeviceInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceName': instance.deviceName,
      'udid': instance.udid,
      'deviceType': instance.deviceType,
      'createTime': instance.createTime,
      'status': instance.status,
    };

_CertInfo _$CertInfoFromJson(Map<String, dynamic> json) => _CertInfo(
  id: json['id'] as String? ?? "",
  certName: json['certName'] as String? ?? "",
  certObjectId: json['certObjectId'] as String? ?? "",
  publicKeySha256: json['publicKeySha256'] as String? ?? "",
  certType: (json['certType'] as num?)?.toInt() ?? 0,
  expireTime: (json['expireTime'] as num?)?.toInt() ?? 0,
  createTime: (json['createTime'] as num?)?.toInt() ?? 0,
  status: (json['status'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CertInfoToJson(_CertInfo instance) => <String, dynamic>{
  'id': instance.id,
  'certName': instance.certName,
  'certObjectId': instance.certObjectId,
  'publicKeySha256': instance.publicKeySha256,
  'certType': instance.certType,
  'expireTime': instance.expireTime,
  'createTime': instance.createTime,
  'status': instance.status,
};

_ProfileInfo _$ProfileInfoFromJson(Map<String, dynamic> json) => _ProfileInfo(
  id: json['id'] as String? ?? "",
  provisionFileUrl: json['provisionFileUrl'] as String? ?? "",
);

Map<String, dynamic> _$ProfileInfoToJson(_ProfileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provisionFileUrl': instance.provisionFileUrl,
    };
