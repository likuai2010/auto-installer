// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../SignConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignConfigImpl _$$SignConfigImplFromJson(Map<String, dynamic> json) =>
    _$SignConfigImpl(
      packageName: json['packageName'] as String? ?? "",
      udids:
          (json['udids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      csrPath: json['csrPath'] as String? ?? "",
      certPath: json['certPath'] as String? ?? "",
      certId: json['certId'] as String? ?? "",
      profilePath: json['profilePath'] as String? ?? "",
      keystoreFile: json['keystoreFile'] as String? ?? "",
      keystorePwd: json['keystorePwd'] as String? ?? "",
      keyAlias: json['keyAlias'] as String? ?? "",
    );

Map<String, dynamic> _$$SignConfigImplToJson(_$SignConfigImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'udids': instance.udids,
      'csrPath': instance.csrPath,
      'certPath': instance.certPath,
      'certId': instance.certId,
      'profilePath': instance.profilePath,
      'keystoreFile': instance.keystoreFile,
      'keystorePwd': instance.keystorePwd,
      'keyAlias': instance.keyAlias,
    };
