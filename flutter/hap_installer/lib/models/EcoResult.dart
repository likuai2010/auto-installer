import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hap_installer/models/AuthInfo.dart';

part 'generated/EcoResult.freezed.dart';
part 'generated/EcoResult.g.dart';

@freezed
abstract class EcoResult with _$EcoResult {
  const factory EcoResult({
    @Default(0) int code,
    @Default('') String msg,
    @Default(null) List<TeamInfo>? teams,
    @Default(null) List<DeviceInfo>? list,
    @Default(null) List<CertInfo>? certList,
    @Default(null) AuthInfo? userInfo,
    @Default(null) CertInfo? harmonyCert,
    @Default(null) List<UrlInfo>? urlsInfo,
    @Default(null) String? provisionFileUrl,
  }) = _EcoResult;
  // 从JSON构建
  factory EcoResult.fromJson(Map<String, dynamic> json) =>
      _$EcoResultFromJson(json);
}

@freezed
abstract class UrlInfo with _$UrlInfo {
  const factory UrlInfo({@Default("") String newUrl}) = _UrlInfo;
  // 从JSON构建
  factory UrlInfo.fromJson(Map<String, dynamic> json) =>
      _$UrlInfoFromJson(json);
}

@freezed
abstract class TeamInfo with _$TeamInfo {
  const factory TeamInfo({
    @Default("") String id,
    @Default('') String name,
    @Default("") String countryCode,
    @Default("") String lastLoginTime,
  }) = _TeamInfo;
  // 从JSON构建
  factory TeamInfo.fromJson(Map<String, dynamic> json) =>
      _$TeamInfoFromJson(json);
}

@freezed
abstract class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    @Default("") String id,
    @Default("") String deviceName,
    @Default("") String udid,
    @Default(0) int deviceType,
    @Default("") String createTime,
    @Default(0) int status,
  }) = _DeviceInfo;
  // 从JSON构建
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}

@freezed
abstract class CertInfo with _$CertInfo {
  const factory CertInfo({
    @Default("") String id,
    @Default("") String certName,
    @Default("") String certObjectId,
    @Default("") String publicKeySha256,
    @Default(0) int certType,
    @Default(0) int expireTime,
    @Default(0) int createTime,
    @Default(0) int status,
  }) = _CertInfo;
  // 从JSON构建
  factory CertInfo.fromJson(Map<String, dynamic> json) =>
      _$CertInfoFromJson(json);
}

@freezed
abstract class ProfileInfo with _$ProfileInfo {
  const factory ProfileInfo({
    @Default("") String id,
    @Default("") String provisionFileUrl,
  }) = _ProfileInfo;
  // 从JSON构建
  factory ProfileInfo.fromJson(Map<String, dynamic> json) =>
      _$ProfileInfoFromJson(json);
}
