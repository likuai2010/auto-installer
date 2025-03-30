// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../EcoResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EcoResultImpl _$$EcoResultImplFromJson(Map<String, dynamic> json) =>
    _$EcoResultImpl(
      ret: json['ret'] == null
          ? const Ret()
          : Ret.fromJson(json['ret'] as Map<String, dynamic>),
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => TeamInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          null,
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          null,
      certList: (json['certList'] as List<dynamic>?)
              ?.map((e) => CertInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          null,
      userInfo: json['userInfo'] == null
          ? null
          : AuthInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      harmonyCert: json['harmonyCert'] == null
          ? null
          : CertInfo.fromJson(json['harmonyCert'] as Map<String, dynamic>),
      urlsInfo: (json['urlsInfo'] as List<dynamic>?)
              ?.map((e) => UrlInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          null,
      provisionFileUrl: json['provisionFileUrl'] as String? ?? null,
    );

Map<String, dynamic> _$$EcoResultImplToJson(_$EcoResultImpl instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'teams': instance.teams,
      'list': instance.list,
      'certList': instance.certList,
      'userInfo': instance.userInfo,
      'harmonyCert': instance.harmonyCert,
      'urlsInfo': instance.urlsInfo,
      'provisionFileUrl': instance.provisionFileUrl,
    };

_$RetImpl _$$RetImplFromJson(Map<String, dynamic> json) => _$RetImpl(
      code: (json['code'] as num?)?.toInt() ?? 0,
      msg: json['msg'] as String? ?? "",
    );

Map<String, dynamic> _$$RetImplToJson(_$RetImpl instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
    };

_$UrlInfoImpl _$$UrlInfoImplFromJson(Map<String, dynamic> json) =>
    _$UrlInfoImpl(
      newUrl: json['newUrl'] as String? ?? "",
    );

Map<String, dynamic> _$$UrlInfoImplToJson(_$UrlInfoImpl instance) =>
    <String, dynamic>{
      'newUrl': instance.newUrl,
    };

_$TeamInfoImpl _$$TeamInfoImplFromJson(Map<String, dynamic> json) =>
    _$TeamInfoImpl(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? "",
      lastLoginTime: json['lastLoginTime'] as String? ?? "",
    );

Map<String, dynamic> _$$TeamInfoImplToJson(_$TeamInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'countryCode': instance.countryCode,
      'lastLoginTime': instance.lastLoginTime,
    };

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      id: json['id'] as String? ?? "",
      deviceName: json['deviceName'] as String? ?? "",
      udid: json['udid'] as String? ?? "",
      deviceType: (json['deviceType'] as num?)?.toInt() ?? 0,
      createTime: json['createTime'] as String? ?? "",
      status: (json['status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceName': instance.deviceName,
      'udid': instance.udid,
      'deviceType': instance.deviceType,
      'createTime': instance.createTime,
      'status': instance.status,
    };

_$CertInfoImpl _$$CertInfoImplFromJson(Map<String, dynamic> json) =>
    _$CertInfoImpl(
      id: json['id'] as String? ?? "",
      certName: json['certName'] as String? ?? "",
      certObjectId: json['certObjectId'] as String? ?? "",
      publicKeySha256: json['publicKeySha256'] as String? ?? "",
      certType: (json['certType'] as num?)?.toInt() ?? 0,
      expireTime: (json['expireTime'] as num?)?.toInt() ?? 0,
      createTime: (json['createTime'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CertInfoImplToJson(_$CertInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certName': instance.certName,
      'certObjectId': instance.certObjectId,
      'publicKeySha256': instance.publicKeySha256,
      'certType': instance.certType,
      'expireTime': instance.expireTime,
      'createTime': instance.createTime,
      'status': instance.status,
    };

_$ProfileInfoImpl _$$ProfileInfoImplFromJson(Map<String, dynamic> json) =>
    _$ProfileInfoImpl(
      id: json['id'] as String? ?? "",
      provisionFileUrl: json['provisionFileUrl'] as String? ?? "",
    );

Map<String, dynamic> _$$ProfileInfoImplToJson(_$ProfileInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provisionFileUrl': instance.provisionFileUrl,
    };
