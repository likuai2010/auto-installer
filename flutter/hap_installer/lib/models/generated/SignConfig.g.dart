// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../SignConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignConfig _$SignConfigFromJson(Map<String, dynamic> json) => _SignConfig(
  packageName: json['packageName'] as String? ?? "",
  udid: json['udid'] as String? ?? "",
  csrPath: json['csrPath'] as String? ?? "",
  certPath: json['certPath'] as String? ?? "",
  certId: json['certId'] as String? ?? "",
  profilePath: json['profilePath'] as String? ?? "",
  keystoreFile: json['keystoreFile'] as String? ?? "",
  keystorePwd: json['keystorePwd'] as String? ?? "",
  keyAlias: json['keyAlias'] as String? ?? "",
);

Map<String, dynamic> _$SignConfigToJson(_SignConfig instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'udid': instance.udid,
      'csrPath': instance.csrPath,
      'certPath': instance.certPath,
      'certId': instance.certId,
      'profilePath': instance.profilePath,
      'keystoreFile': instance.keystoreFile,
      'keystorePwd': instance.keystorePwd,
      'keyAlias': instance.keyAlias,
    };
