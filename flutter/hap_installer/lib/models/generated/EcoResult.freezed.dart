// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../EcoResult.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EcoResult implements DiagnosticableTreeMixin {

 int get code; String get msg; List<TeamInfo>? get teams; List<DeviceInfo>? get list; List<CertInfo>? get certList; AuthInfo? get userInfo; CertInfo? get harmonyCert; List<UrlInfo>? get urlsInfo; String? get provisionFileUrl;
/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EcoResultCopyWith<EcoResult> get copyWith => _$EcoResultCopyWithImpl<EcoResult>(this as EcoResult, _$identity);

  /// Serializes this EcoResult to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EcoResult'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('msg', msg))..add(DiagnosticsProperty('teams', teams))..add(DiagnosticsProperty('list', list))..add(DiagnosticsProperty('certList', certList))..add(DiagnosticsProperty('userInfo', userInfo))..add(DiagnosticsProperty('harmonyCert', harmonyCert))..add(DiagnosticsProperty('urlsInfo', urlsInfo))..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EcoResult&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other.teams, teams)&&const DeepCollectionEquality().equals(other.list, list)&&const DeepCollectionEquality().equals(other.certList, certList)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.harmonyCert, harmonyCert) || other.harmonyCert == harmonyCert)&&const DeepCollectionEquality().equals(other.urlsInfo, urlsInfo)&&(identical(other.provisionFileUrl, provisionFileUrl) || other.provisionFileUrl == provisionFileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,const DeepCollectionEquality().hash(teams),const DeepCollectionEquality().hash(list),const DeepCollectionEquality().hash(certList),userInfo,harmonyCert,const DeepCollectionEquality().hash(urlsInfo),provisionFileUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EcoResult(code: $code, msg: $msg, teams: $teams, list: $list, certList: $certList, userInfo: $userInfo, harmonyCert: $harmonyCert, urlsInfo: $urlsInfo, provisionFileUrl: $provisionFileUrl)';
}


}

/// @nodoc
abstract mixin class $EcoResultCopyWith<$Res>  {
  factory $EcoResultCopyWith(EcoResult value, $Res Function(EcoResult) _then) = _$EcoResultCopyWithImpl;
@useResult
$Res call({
 int code, String msg, List<TeamInfo>? teams, List<DeviceInfo>? list, List<CertInfo>? certList, AuthInfo? userInfo, CertInfo? harmonyCert, List<UrlInfo>? urlsInfo, String? provisionFileUrl
});


$CertInfoCopyWith<$Res>? get harmonyCert;

}
/// @nodoc
class _$EcoResultCopyWithImpl<$Res>
    implements $EcoResultCopyWith<$Res> {
  _$EcoResultCopyWithImpl(this._self, this._then);

  final EcoResult _self;
  final $Res Function(EcoResult) _then;

/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? msg = null,Object? teams = freezed,Object? list = freezed,Object? certList = freezed,Object? userInfo = freezed,Object? harmonyCert = freezed,Object? urlsInfo = freezed,Object? provisionFileUrl = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,teams: freezed == teams ? _self.teams : teams // ignore: cast_nullable_to_non_nullable
as List<TeamInfo>?,list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<DeviceInfo>?,certList: freezed == certList ? _self.certList : certList // ignore: cast_nullable_to_non_nullable
as List<CertInfo>?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as AuthInfo?,harmonyCert: freezed == harmonyCert ? _self.harmonyCert : harmonyCert // ignore: cast_nullable_to_non_nullable
as CertInfo?,urlsInfo: freezed == urlsInfo ? _self.urlsInfo : urlsInfo // ignore: cast_nullable_to_non_nullable
as List<UrlInfo>?,provisionFileUrl: freezed == provisionFileUrl ? _self.provisionFileUrl : provisionFileUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CertInfoCopyWith<$Res>? get harmonyCert {
    if (_self.harmonyCert == null) {
    return null;
  }

  return $CertInfoCopyWith<$Res>(_self.harmonyCert!, (value) {
    return _then(_self.copyWith(harmonyCert: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _EcoResult with DiagnosticableTreeMixin implements EcoResult {
  const _EcoResult({this.code = 0, this.msg = '', final  List<TeamInfo>? teams = null, final  List<DeviceInfo>? list = null, final  List<CertInfo>? certList = null, this.userInfo = null, this.harmonyCert = null, final  List<UrlInfo>? urlsInfo = null, this.provisionFileUrl = null}): _teams = teams,_list = list,_certList = certList,_urlsInfo = urlsInfo;
  factory _EcoResult.fromJson(Map<String, dynamic> json) => _$EcoResultFromJson(json);

@override@JsonKey() final  int code;
@override@JsonKey() final  String msg;
 final  List<TeamInfo>? _teams;
@override@JsonKey() List<TeamInfo>? get teams {
  final value = _teams;
  if (value == null) return null;
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<DeviceInfo>? _list;
@override@JsonKey() List<DeviceInfo>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<CertInfo>? _certList;
@override@JsonKey() List<CertInfo>? get certList {
  final value = _certList;
  if (value == null) return null;
  if (_certList is EqualUnmodifiableListView) return _certList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  AuthInfo? userInfo;
@override@JsonKey() final  CertInfo? harmonyCert;
 final  List<UrlInfo>? _urlsInfo;
@override@JsonKey() List<UrlInfo>? get urlsInfo {
  final value = _urlsInfo;
  if (value == null) return null;
  if (_urlsInfo is EqualUnmodifiableListView) return _urlsInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  String? provisionFileUrl;

/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EcoResultCopyWith<_EcoResult> get copyWith => __$EcoResultCopyWithImpl<_EcoResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EcoResultToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EcoResult'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('msg', msg))..add(DiagnosticsProperty('teams', teams))..add(DiagnosticsProperty('list', list))..add(DiagnosticsProperty('certList', certList))..add(DiagnosticsProperty('userInfo', userInfo))..add(DiagnosticsProperty('harmonyCert', harmonyCert))..add(DiagnosticsProperty('urlsInfo', urlsInfo))..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EcoResult&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other._teams, _teams)&&const DeepCollectionEquality().equals(other._list, _list)&&const DeepCollectionEquality().equals(other._certList, _certList)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.harmonyCert, harmonyCert) || other.harmonyCert == harmonyCert)&&const DeepCollectionEquality().equals(other._urlsInfo, _urlsInfo)&&(identical(other.provisionFileUrl, provisionFileUrl) || other.provisionFileUrl == provisionFileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,const DeepCollectionEquality().hash(_teams),const DeepCollectionEquality().hash(_list),const DeepCollectionEquality().hash(_certList),userInfo,harmonyCert,const DeepCollectionEquality().hash(_urlsInfo),provisionFileUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EcoResult(code: $code, msg: $msg, teams: $teams, list: $list, certList: $certList, userInfo: $userInfo, harmonyCert: $harmonyCert, urlsInfo: $urlsInfo, provisionFileUrl: $provisionFileUrl)';
}


}

/// @nodoc
abstract mixin class _$EcoResultCopyWith<$Res> implements $EcoResultCopyWith<$Res> {
  factory _$EcoResultCopyWith(_EcoResult value, $Res Function(_EcoResult) _then) = __$EcoResultCopyWithImpl;
@override @useResult
$Res call({
 int code, String msg, List<TeamInfo>? teams, List<DeviceInfo>? list, List<CertInfo>? certList, AuthInfo? userInfo, CertInfo? harmonyCert, List<UrlInfo>? urlsInfo, String? provisionFileUrl
});


@override $CertInfoCopyWith<$Res>? get harmonyCert;

}
/// @nodoc
class __$EcoResultCopyWithImpl<$Res>
    implements _$EcoResultCopyWith<$Res> {
  __$EcoResultCopyWithImpl(this._self, this._then);

  final _EcoResult _self;
  final $Res Function(_EcoResult) _then;

/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? msg = null,Object? teams = freezed,Object? list = freezed,Object? certList = freezed,Object? userInfo = freezed,Object? harmonyCert = freezed,Object? urlsInfo = freezed,Object? provisionFileUrl = freezed,}) {
  return _then(_EcoResult(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,teams: freezed == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<TeamInfo>?,list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<DeviceInfo>?,certList: freezed == certList ? _self._certList : certList // ignore: cast_nullable_to_non_nullable
as List<CertInfo>?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as AuthInfo?,harmonyCert: freezed == harmonyCert ? _self.harmonyCert : harmonyCert // ignore: cast_nullable_to_non_nullable
as CertInfo?,urlsInfo: freezed == urlsInfo ? _self._urlsInfo : urlsInfo // ignore: cast_nullable_to_non_nullable
as List<UrlInfo>?,provisionFileUrl: freezed == provisionFileUrl ? _self.provisionFileUrl : provisionFileUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EcoResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CertInfoCopyWith<$Res>? get harmonyCert {
    if (_self.harmonyCert == null) {
    return null;
  }

  return $CertInfoCopyWith<$Res>(_self.harmonyCert!, (value) {
    return _then(_self.copyWith(harmonyCert: value));
  });
}
}


/// @nodoc
mixin _$UrlInfo implements DiagnosticableTreeMixin {

 String get newUrl;
/// Create a copy of UrlInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlInfoCopyWith<UrlInfo> get copyWith => _$UrlInfoCopyWithImpl<UrlInfo>(this as UrlInfo, _$identity);

  /// Serializes this UrlInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UrlInfo'))
    ..add(DiagnosticsProperty('newUrl', newUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrlInfo&&(identical(other.newUrl, newUrl) || other.newUrl == newUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UrlInfo(newUrl: $newUrl)';
}


}

/// @nodoc
abstract mixin class $UrlInfoCopyWith<$Res>  {
  factory $UrlInfoCopyWith(UrlInfo value, $Res Function(UrlInfo) _then) = _$UrlInfoCopyWithImpl;
@useResult
$Res call({
 String newUrl
});




}
/// @nodoc
class _$UrlInfoCopyWithImpl<$Res>
    implements $UrlInfoCopyWith<$Res> {
  _$UrlInfoCopyWithImpl(this._self, this._then);

  final UrlInfo _self;
  final $Res Function(UrlInfo) _then;

/// Create a copy of UrlInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? newUrl = null,}) {
  return _then(_self.copyWith(
newUrl: null == newUrl ? _self.newUrl : newUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UrlInfo with DiagnosticableTreeMixin implements UrlInfo {
  const _UrlInfo({this.newUrl = ""});
  factory _UrlInfo.fromJson(Map<String, dynamic> json) => _$UrlInfoFromJson(json);

@override@JsonKey() final  String newUrl;

/// Create a copy of UrlInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrlInfoCopyWith<_UrlInfo> get copyWith => __$UrlInfoCopyWithImpl<_UrlInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrlInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UrlInfo'))
    ..add(DiagnosticsProperty('newUrl', newUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UrlInfo&&(identical(other.newUrl, newUrl) || other.newUrl == newUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UrlInfo(newUrl: $newUrl)';
}


}

/// @nodoc
abstract mixin class _$UrlInfoCopyWith<$Res> implements $UrlInfoCopyWith<$Res> {
  factory _$UrlInfoCopyWith(_UrlInfo value, $Res Function(_UrlInfo) _then) = __$UrlInfoCopyWithImpl;
@override @useResult
$Res call({
 String newUrl
});




}
/// @nodoc
class __$UrlInfoCopyWithImpl<$Res>
    implements _$UrlInfoCopyWith<$Res> {
  __$UrlInfoCopyWithImpl(this._self, this._then);

  final _UrlInfo _self;
  final $Res Function(_UrlInfo) _then;

/// Create a copy of UrlInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newUrl = null,}) {
  return _then(_UrlInfo(
newUrl: null == newUrl ? _self.newUrl : newUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TeamInfo implements DiagnosticableTreeMixin {

 String get id; String get name; String get countryCode; String get lastLoginTime;
/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamInfoCopyWith<TeamInfo> get copyWith => _$TeamInfoCopyWithImpl<TeamInfo>(this as TeamInfo, _$identity);

  /// Serializes this TeamInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TeamInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('countryCode', countryCode))..add(DiagnosticsProperty('lastLoginTime', lastLoginTime));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.lastLoginTime, lastLoginTime) || other.lastLoginTime == lastLoginTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,countryCode,lastLoginTime);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TeamInfo(id: $id, name: $name, countryCode: $countryCode, lastLoginTime: $lastLoginTime)';
}


}

/// @nodoc
abstract mixin class $TeamInfoCopyWith<$Res>  {
  factory $TeamInfoCopyWith(TeamInfo value, $Res Function(TeamInfo) _then) = _$TeamInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String countryCode, String lastLoginTime
});




}
/// @nodoc
class _$TeamInfoCopyWithImpl<$Res>
    implements $TeamInfoCopyWith<$Res> {
  _$TeamInfoCopyWithImpl(this._self, this._then);

  final TeamInfo _self;
  final $Res Function(TeamInfo) _then;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? countryCode = null,Object? lastLoginTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,lastLoginTime: null == lastLoginTime ? _self.lastLoginTime : lastLoginTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TeamInfo with DiagnosticableTreeMixin implements TeamInfo {
  const _TeamInfo({this.id = "", this.name = '', this.countryCode = "", this.lastLoginTime = ""});
  factory _TeamInfo.fromJson(Map<String, dynamic> json) => _$TeamInfoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String countryCode;
@override@JsonKey() final  String lastLoginTime;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamInfoCopyWith<_TeamInfo> get copyWith => __$TeamInfoCopyWithImpl<_TeamInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TeamInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('countryCode', countryCode))..add(DiagnosticsProperty('lastLoginTime', lastLoginTime));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.lastLoginTime, lastLoginTime) || other.lastLoginTime == lastLoginTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,countryCode,lastLoginTime);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TeamInfo(id: $id, name: $name, countryCode: $countryCode, lastLoginTime: $lastLoginTime)';
}


}

/// @nodoc
abstract mixin class _$TeamInfoCopyWith<$Res> implements $TeamInfoCopyWith<$Res> {
  factory _$TeamInfoCopyWith(_TeamInfo value, $Res Function(_TeamInfo) _then) = __$TeamInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String countryCode, String lastLoginTime
});




}
/// @nodoc
class __$TeamInfoCopyWithImpl<$Res>
    implements _$TeamInfoCopyWith<$Res> {
  __$TeamInfoCopyWithImpl(this._self, this._then);

  final _TeamInfo _self;
  final $Res Function(_TeamInfo) _then;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? countryCode = null,Object? lastLoginTime = null,}) {
  return _then(_TeamInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,lastLoginTime: null == lastLoginTime ? _self.lastLoginTime : lastLoginTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeviceInfo implements DiagnosticableTreeMixin {

 String get id; String get deviceName; String get udid; int get deviceType; String get createTime; int get status;
/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<DeviceInfo> get copyWith => _$DeviceInfoCopyWithImpl<DeviceInfo>(this as DeviceInfo, _$identity);

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeviceInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('deviceName', deviceName))..add(DiagnosticsProperty('udid', udid))..add(DiagnosticsProperty('deviceType', deviceType))..add(DiagnosticsProperty('createTime', createTime))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.udid, udid) || other.udid == udid)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceName,udid,deviceType,createTime,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeviceInfo(id: $id, deviceName: $deviceName, udid: $udid, deviceType: $deviceType, createTime: $createTime, status: $status)';
}


}

/// @nodoc
abstract mixin class $DeviceInfoCopyWith<$Res>  {
  factory $DeviceInfoCopyWith(DeviceInfo value, $Res Function(DeviceInfo) _then) = _$DeviceInfoCopyWithImpl;
@useResult
$Res call({
 String id, String deviceName, String udid, int deviceType, String createTime, int status
});




}
/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._self, this._then);

  final DeviceInfo _self;
  final $Res Function(DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceName = null,Object? udid = null,Object? deviceType = null,Object? createTime = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,udid: null == udid ? _self.udid : udid // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DeviceInfo with DiagnosticableTreeMixin implements DeviceInfo {
  const _DeviceInfo({this.id = "", this.deviceName = "", this.udid = "", this.deviceType = 0, this.createTime = "", this.status = 0});
  factory _DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String deviceName;
@override@JsonKey() final  String udid;
@override@JsonKey() final  int deviceType;
@override@JsonKey() final  String createTime;
@override@JsonKey() final  int status;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceInfoCopyWith<_DeviceInfo> get copyWith => __$DeviceInfoCopyWithImpl<_DeviceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeviceInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('deviceName', deviceName))..add(DiagnosticsProperty('udid', udid))..add(DiagnosticsProperty('deviceType', deviceType))..add(DiagnosticsProperty('createTime', createTime))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.udid, udid) || other.udid == udid)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceName,udid,deviceType,createTime,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeviceInfo(id: $id, deviceName: $deviceName, udid: $udid, deviceType: $deviceType, createTime: $createTime, status: $status)';
}


}

/// @nodoc
abstract mixin class _$DeviceInfoCopyWith<$Res> implements $DeviceInfoCopyWith<$Res> {
  factory _$DeviceInfoCopyWith(_DeviceInfo value, $Res Function(_DeviceInfo) _then) = __$DeviceInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String deviceName, String udid, int deviceType, String createTime, int status
});




}
/// @nodoc
class __$DeviceInfoCopyWithImpl<$Res>
    implements _$DeviceInfoCopyWith<$Res> {
  __$DeviceInfoCopyWithImpl(this._self, this._then);

  final _DeviceInfo _self;
  final $Res Function(_DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceName = null,Object? udid = null,Object? deviceType = null,Object? createTime = null,Object? status = null,}) {
  return _then(_DeviceInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,udid: null == udid ? _self.udid : udid // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as int,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CertInfo implements DiagnosticableTreeMixin {

 String get id; String get certName; String get certObjectId; String get publicKeySha256; int get certType; int get expireTime; int get createTime; int get status;
/// Create a copy of CertInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CertInfoCopyWith<CertInfo> get copyWith => _$CertInfoCopyWithImpl<CertInfo>(this as CertInfo, _$identity);

  /// Serializes this CertInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CertInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('certName', certName))..add(DiagnosticsProperty('certObjectId', certObjectId))..add(DiagnosticsProperty('publicKeySha256', publicKeySha256))..add(DiagnosticsProperty('certType', certType))..add(DiagnosticsProperty('expireTime', expireTime))..add(DiagnosticsProperty('createTime', createTime))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CertInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.certName, certName) || other.certName == certName)&&(identical(other.certObjectId, certObjectId) || other.certObjectId == certObjectId)&&(identical(other.publicKeySha256, publicKeySha256) || other.publicKeySha256 == publicKeySha256)&&(identical(other.certType, certType) || other.certType == certType)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,certName,certObjectId,publicKeySha256,certType,expireTime,createTime,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CertInfo(id: $id, certName: $certName, certObjectId: $certObjectId, publicKeySha256: $publicKeySha256, certType: $certType, expireTime: $expireTime, createTime: $createTime, status: $status)';
}


}

/// @nodoc
abstract mixin class $CertInfoCopyWith<$Res>  {
  factory $CertInfoCopyWith(CertInfo value, $Res Function(CertInfo) _then) = _$CertInfoCopyWithImpl;
@useResult
$Res call({
 String id, String certName, String certObjectId, String publicKeySha256, int certType, int expireTime, int createTime, int status
});




}
/// @nodoc
class _$CertInfoCopyWithImpl<$Res>
    implements $CertInfoCopyWith<$Res> {
  _$CertInfoCopyWithImpl(this._self, this._then);

  final CertInfo _self;
  final $Res Function(CertInfo) _then;

/// Create a copy of CertInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? certName = null,Object? certObjectId = null,Object? publicKeySha256 = null,Object? certType = null,Object? expireTime = null,Object? createTime = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,certName: null == certName ? _self.certName : certName // ignore: cast_nullable_to_non_nullable
as String,certObjectId: null == certObjectId ? _self.certObjectId : certObjectId // ignore: cast_nullable_to_non_nullable
as String,publicKeySha256: null == publicKeySha256 ? _self.publicKeySha256 : publicKeySha256 // ignore: cast_nullable_to_non_nullable
as String,certType: null == certType ? _self.certType : certType // ignore: cast_nullable_to_non_nullable
as int,expireTime: null == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as int,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CertInfo with DiagnosticableTreeMixin implements CertInfo {
  const _CertInfo({this.id = "", this.certName = "", this.certObjectId = "", this.publicKeySha256 = "", this.certType = 0, this.expireTime = 0, this.createTime = 0, this.status = 0});
  factory _CertInfo.fromJson(Map<String, dynamic> json) => _$CertInfoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String certName;
@override@JsonKey() final  String certObjectId;
@override@JsonKey() final  String publicKeySha256;
@override@JsonKey() final  int certType;
@override@JsonKey() final  int expireTime;
@override@JsonKey() final  int createTime;
@override@JsonKey() final  int status;

/// Create a copy of CertInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CertInfoCopyWith<_CertInfo> get copyWith => __$CertInfoCopyWithImpl<_CertInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CertInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CertInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('certName', certName))..add(DiagnosticsProperty('certObjectId', certObjectId))..add(DiagnosticsProperty('publicKeySha256', publicKeySha256))..add(DiagnosticsProperty('certType', certType))..add(DiagnosticsProperty('expireTime', expireTime))..add(DiagnosticsProperty('createTime', createTime))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CertInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.certName, certName) || other.certName == certName)&&(identical(other.certObjectId, certObjectId) || other.certObjectId == certObjectId)&&(identical(other.publicKeySha256, publicKeySha256) || other.publicKeySha256 == publicKeySha256)&&(identical(other.certType, certType) || other.certType == certType)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,certName,certObjectId,publicKeySha256,certType,expireTime,createTime,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CertInfo(id: $id, certName: $certName, certObjectId: $certObjectId, publicKeySha256: $publicKeySha256, certType: $certType, expireTime: $expireTime, createTime: $createTime, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CertInfoCopyWith<$Res> implements $CertInfoCopyWith<$Res> {
  factory _$CertInfoCopyWith(_CertInfo value, $Res Function(_CertInfo) _then) = __$CertInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String certName, String certObjectId, String publicKeySha256, int certType, int expireTime, int createTime, int status
});




}
/// @nodoc
class __$CertInfoCopyWithImpl<$Res>
    implements _$CertInfoCopyWith<$Res> {
  __$CertInfoCopyWithImpl(this._self, this._then);

  final _CertInfo _self;
  final $Res Function(_CertInfo) _then;

/// Create a copy of CertInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? certName = null,Object? certObjectId = null,Object? publicKeySha256 = null,Object? certType = null,Object? expireTime = null,Object? createTime = null,Object? status = null,}) {
  return _then(_CertInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,certName: null == certName ? _self.certName : certName // ignore: cast_nullable_to_non_nullable
as String,certObjectId: null == certObjectId ? _self.certObjectId : certObjectId // ignore: cast_nullable_to_non_nullable
as String,publicKeySha256: null == publicKeySha256 ? _self.publicKeySha256 : publicKeySha256 // ignore: cast_nullable_to_non_nullable
as String,certType: null == certType ? _self.certType : certType // ignore: cast_nullable_to_non_nullable
as int,expireTime: null == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as int,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProfileInfo implements DiagnosticableTreeMixin {

 String get id; String get provisionFileUrl;
/// Create a copy of ProfileInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileInfoCopyWith<ProfileInfo> get copyWith => _$ProfileInfoCopyWithImpl<ProfileInfo>(this as ProfileInfo, _$identity);

  /// Serializes this ProfileInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.provisionFileUrl, provisionFileUrl) || other.provisionFileUrl == provisionFileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provisionFileUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileInfo(id: $id, provisionFileUrl: $provisionFileUrl)';
}


}

/// @nodoc
abstract mixin class $ProfileInfoCopyWith<$Res>  {
  factory $ProfileInfoCopyWith(ProfileInfo value, $Res Function(ProfileInfo) _then) = _$ProfileInfoCopyWithImpl;
@useResult
$Res call({
 String id, String provisionFileUrl
});




}
/// @nodoc
class _$ProfileInfoCopyWithImpl<$Res>
    implements $ProfileInfoCopyWith<$Res> {
  _$ProfileInfoCopyWithImpl(this._self, this._then);

  final ProfileInfo _self;
  final $Res Function(ProfileInfo) _then;

/// Create a copy of ProfileInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provisionFileUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provisionFileUrl: null == provisionFileUrl ? _self.provisionFileUrl : provisionFileUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProfileInfo with DiagnosticableTreeMixin implements ProfileInfo {
  const _ProfileInfo({this.id = "", this.provisionFileUrl = ""});
  factory _ProfileInfo.fromJson(Map<String, dynamic> json) => _$ProfileInfoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String provisionFileUrl;

/// Create a copy of ProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileInfoCopyWith<_ProfileInfo> get copyWith => __$ProfileInfoCopyWithImpl<_ProfileInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileInfo'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.provisionFileUrl, provisionFileUrl) || other.provisionFileUrl == provisionFileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provisionFileUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileInfo(id: $id, provisionFileUrl: $provisionFileUrl)';
}


}

/// @nodoc
abstract mixin class _$ProfileInfoCopyWith<$Res> implements $ProfileInfoCopyWith<$Res> {
  factory _$ProfileInfoCopyWith(_ProfileInfo value, $Res Function(_ProfileInfo) _then) = __$ProfileInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String provisionFileUrl
});




}
/// @nodoc
class __$ProfileInfoCopyWithImpl<$Res>
    implements _$ProfileInfoCopyWith<$Res> {
  __$ProfileInfoCopyWithImpl(this._self, this._then);

  final _ProfileInfo _self;
  final $Res Function(_ProfileInfo) _then;

/// Create a copy of ProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provisionFileUrl = null,}) {
  return _then(_ProfileInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provisionFileUrl: null == provisionFileUrl ? _self.provisionFileUrl : provisionFileUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
