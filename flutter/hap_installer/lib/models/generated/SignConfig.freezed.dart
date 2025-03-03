// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../SignConfig.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignConfig implements DiagnosticableTreeMixin {

 String get packageName; String get udid; String get csrPath; String get certPath; String get certId; String get profilePath; String get keystoreFile; String get keystorePwd; String get keyAlias;
/// Create a copy of SignConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignConfigCopyWith<SignConfig> get copyWith => _$SignConfigCopyWithImpl<SignConfig>(this as SignConfig, _$identity);

  /// Serializes this SignConfig to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SignConfig'))
    ..add(DiagnosticsProperty('packageName', packageName))..add(DiagnosticsProperty('udid', udid))..add(DiagnosticsProperty('csrPath', csrPath))..add(DiagnosticsProperty('certPath', certPath))..add(DiagnosticsProperty('certId', certId))..add(DiagnosticsProperty('profilePath', profilePath))..add(DiagnosticsProperty('keystoreFile', keystoreFile))..add(DiagnosticsProperty('keystorePwd', keystorePwd))..add(DiagnosticsProperty('keyAlias', keyAlias));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignConfig&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.udid, udid) || other.udid == udid)&&(identical(other.csrPath, csrPath) || other.csrPath == csrPath)&&(identical(other.certPath, certPath) || other.certPath == certPath)&&(identical(other.certId, certId) || other.certId == certId)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.keystoreFile, keystoreFile) || other.keystoreFile == keystoreFile)&&(identical(other.keystorePwd, keystorePwd) || other.keystorePwd == keystorePwd)&&(identical(other.keyAlias, keyAlias) || other.keyAlias == keyAlias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,udid,csrPath,certPath,certId,profilePath,keystoreFile,keystorePwd,keyAlias);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SignConfig(packageName: $packageName, udid: $udid, csrPath: $csrPath, certPath: $certPath, certId: $certId, profilePath: $profilePath, keystoreFile: $keystoreFile, keystorePwd: $keystorePwd, keyAlias: $keyAlias)';
}


}

/// @nodoc
abstract mixin class $SignConfigCopyWith<$Res>  {
  factory $SignConfigCopyWith(SignConfig value, $Res Function(SignConfig) _then) = _$SignConfigCopyWithImpl;
@useResult
$Res call({
 String packageName, String udid, String csrPath, String certPath, String certId, String profilePath, String keystoreFile, String keystorePwd, String keyAlias
});




}
/// @nodoc
class _$SignConfigCopyWithImpl<$Res>
    implements $SignConfigCopyWith<$Res> {
  _$SignConfigCopyWithImpl(this._self, this._then);

  final SignConfig _self;
  final $Res Function(SignConfig) _then;

/// Create a copy of SignConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? udid = null,Object? csrPath = null,Object? certPath = null,Object? certId = null,Object? profilePath = null,Object? keystoreFile = null,Object? keystorePwd = null,Object? keyAlias = null,}) {
  return _then(_self.copyWith(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,udid: null == udid ? _self.udid : udid // ignore: cast_nullable_to_non_nullable
as String,csrPath: null == csrPath ? _self.csrPath : csrPath // ignore: cast_nullable_to_non_nullable
as String,certPath: null == certPath ? _self.certPath : certPath // ignore: cast_nullable_to_non_nullable
as String,certId: null == certId ? _self.certId : certId // ignore: cast_nullable_to_non_nullable
as String,profilePath: null == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String,keystoreFile: null == keystoreFile ? _self.keystoreFile : keystoreFile // ignore: cast_nullable_to_non_nullable
as String,keystorePwd: null == keystorePwd ? _self.keystorePwd : keystorePwd // ignore: cast_nullable_to_non_nullable
as String,keyAlias: null == keyAlias ? _self.keyAlias : keyAlias // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SignConfig with DiagnosticableTreeMixin implements SignConfig {
  const _SignConfig({this.packageName = "", this.udid = "", this.csrPath = "", this.certPath = "", this.certId = "", this.profilePath = "", this.keystoreFile = "", this.keystorePwd = "", this.keyAlias = ""});
  factory _SignConfig.fromJson(Map<String, dynamic> json) => _$SignConfigFromJson(json);

@override@JsonKey() final  String packageName;
@override@JsonKey() final  String udid;
@override@JsonKey() final  String csrPath;
@override@JsonKey() final  String certPath;
@override@JsonKey() final  String certId;
@override@JsonKey() final  String profilePath;
@override@JsonKey() final  String keystoreFile;
@override@JsonKey() final  String keystorePwd;
@override@JsonKey() final  String keyAlias;

/// Create a copy of SignConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignConfigCopyWith<_SignConfig> get copyWith => __$SignConfigCopyWithImpl<_SignConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignConfigToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SignConfig'))
    ..add(DiagnosticsProperty('packageName', packageName))..add(DiagnosticsProperty('udid', udid))..add(DiagnosticsProperty('csrPath', csrPath))..add(DiagnosticsProperty('certPath', certPath))..add(DiagnosticsProperty('certId', certId))..add(DiagnosticsProperty('profilePath', profilePath))..add(DiagnosticsProperty('keystoreFile', keystoreFile))..add(DiagnosticsProperty('keystorePwd', keystorePwd))..add(DiagnosticsProperty('keyAlias', keyAlias));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignConfig&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.udid, udid) || other.udid == udid)&&(identical(other.csrPath, csrPath) || other.csrPath == csrPath)&&(identical(other.certPath, certPath) || other.certPath == certPath)&&(identical(other.certId, certId) || other.certId == certId)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.keystoreFile, keystoreFile) || other.keystoreFile == keystoreFile)&&(identical(other.keystorePwd, keystorePwd) || other.keystorePwd == keystorePwd)&&(identical(other.keyAlias, keyAlias) || other.keyAlias == keyAlias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,udid,csrPath,certPath,certId,profilePath,keystoreFile,keystorePwd,keyAlias);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SignConfig(packageName: $packageName, udid: $udid, csrPath: $csrPath, certPath: $certPath, certId: $certId, profilePath: $profilePath, keystoreFile: $keystoreFile, keystorePwd: $keystorePwd, keyAlias: $keyAlias)';
}


}

/// @nodoc
abstract mixin class _$SignConfigCopyWith<$Res> implements $SignConfigCopyWith<$Res> {
  factory _$SignConfigCopyWith(_SignConfig value, $Res Function(_SignConfig) _then) = __$SignConfigCopyWithImpl;
@override @useResult
$Res call({
 String packageName, String udid, String csrPath, String certPath, String certId, String profilePath, String keystoreFile, String keystorePwd, String keyAlias
});




}
/// @nodoc
class __$SignConfigCopyWithImpl<$Res>
    implements _$SignConfigCopyWith<$Res> {
  __$SignConfigCopyWithImpl(this._self, this._then);

  final _SignConfig _self;
  final $Res Function(_SignConfig) _then;

/// Create a copy of SignConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? udid = null,Object? csrPath = null,Object? certPath = null,Object? certId = null,Object? profilePath = null,Object? keystoreFile = null,Object? keystorePwd = null,Object? keyAlias = null,}) {
  return _then(_SignConfig(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,udid: null == udid ? _self.udid : udid // ignore: cast_nullable_to_non_nullable
as String,csrPath: null == csrPath ? _self.csrPath : csrPath // ignore: cast_nullable_to_non_nullable
as String,certPath: null == certPath ? _self.certPath : certPath // ignore: cast_nullable_to_non_nullable
as String,certId: null == certId ? _self.certId : certId // ignore: cast_nullable_to_non_nullable
as String,profilePath: null == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String,keystoreFile: null == keystoreFile ? _self.keystoreFile : keystoreFile // ignore: cast_nullable_to_non_nullable
as String,keystorePwd: null == keystorePwd ? _self.keystorePwd : keystorePwd // ignore: cast_nullable_to_non_nullable
as String,keyAlias: null == keyAlias ? _self.keyAlias : keyAlias // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
