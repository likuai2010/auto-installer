// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../DebugHistory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebugHistory {

 HapInfo get hapInfo; set hapInfo(HapInfo value); bool get finished; set finished(bool value); DateTime? get start; set start(DateTime? value); DateTime? get end; set end(DateTime? value); List<SetpInfo> get setps; set setps(List<SetpInfo> value);
/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebugHistoryCopyWith<DebugHistory> get copyWith => _$DebugHistoryCopyWithImpl<DebugHistory>(this as DebugHistory, _$identity);

  /// Serializes this DebugHistory to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'DebugHistory(hapInfo: $hapInfo, finished: $finished, start: $start, end: $end, setps: $setps)';
}


}

/// @nodoc
abstract mixin class $DebugHistoryCopyWith<$Res>  {
  factory $DebugHistoryCopyWith(DebugHistory value, $Res Function(DebugHistory) _then) = _$DebugHistoryCopyWithImpl;
@useResult
$Res call({
 HapInfo hapInfo, bool finished, DateTime? start, DateTime? end, List<SetpInfo> setps
});


$HapInfoCopyWith<$Res> get hapInfo;

}
/// @nodoc
class _$DebugHistoryCopyWithImpl<$Res>
    implements $DebugHistoryCopyWith<$Res> {
  _$DebugHistoryCopyWithImpl(this._self, this._then);

  final DebugHistory _self;
  final $Res Function(DebugHistory) _then;

/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hapInfo = null,Object? finished = null,Object? start = freezed,Object? end = freezed,Object? setps = null,}) {
  return _then(_self.copyWith(
hapInfo: null == hapInfo ? _self.hapInfo : hapInfo // ignore: cast_nullable_to_non_nullable
as HapInfo,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,setps: null == setps ? _self.setps : setps // ignore: cast_nullable_to_non_nullable
as List<SetpInfo>,
  ));
}
/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HapInfoCopyWith<$Res> get hapInfo {
  
  return $HapInfoCopyWith<$Res>(_self.hapInfo, (value) {
    return _then(_self.copyWith(hapInfo: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _DebugHistory implements DebugHistory {
   _DebugHistory({required this.hapInfo, this.finished = false, this.start = null, this.end = null, this.setps = const [SetpInfo(name: "登录检查"), SetpInfo(name: "连接状态检查"), SetpInfo(name: "签名应用"), SetpInfo(name: "安装应用")]});
  factory _DebugHistory.fromJson(Map<String, dynamic> json) => _$DebugHistoryFromJson(json);

@override  HapInfo hapInfo;
@override@JsonKey()  bool finished;
@override@JsonKey()  DateTime? start;
@override@JsonKey()  DateTime? end;
@override@JsonKey()  List<SetpInfo> setps;

/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebugHistoryCopyWith<_DebugHistory> get copyWith => __$DebugHistoryCopyWithImpl<_DebugHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebugHistoryToJson(this, );
}



@override
String toString() {
  return 'DebugHistory(hapInfo: $hapInfo, finished: $finished, start: $start, end: $end, setps: $setps)';
}


}

/// @nodoc
abstract mixin class _$DebugHistoryCopyWith<$Res> implements $DebugHistoryCopyWith<$Res> {
  factory _$DebugHistoryCopyWith(_DebugHistory value, $Res Function(_DebugHistory) _then) = __$DebugHistoryCopyWithImpl;
@override @useResult
$Res call({
 HapInfo hapInfo, bool finished, DateTime? start, DateTime? end, List<SetpInfo> setps
});


@override $HapInfoCopyWith<$Res> get hapInfo;

}
/// @nodoc
class __$DebugHistoryCopyWithImpl<$Res>
    implements _$DebugHistoryCopyWith<$Res> {
  __$DebugHistoryCopyWithImpl(this._self, this._then);

  final _DebugHistory _self;
  final $Res Function(_DebugHistory) _then;

/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hapInfo = null,Object? finished = null,Object? start = freezed,Object? end = freezed,Object? setps = null,}) {
  return _then(_DebugHistory(
hapInfo: null == hapInfo ? _self.hapInfo : hapInfo // ignore: cast_nullable_to_non_nullable
as HapInfo,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,setps: null == setps ? _self.setps : setps // ignore: cast_nullable_to_non_nullable
as List<SetpInfo>,
  ));
}

/// Create a copy of DebugHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HapInfoCopyWith<$Res> get hapInfo {
  
  return $HapInfoCopyWith<$Res>(_self.hapInfo, (value) {
    return _then(_self.copyWith(hapInfo: value));
  });
}
}


/// @nodoc
mixin _$SetpInfo {

 String get name; String? get error; bool? get loading;
/// Create a copy of SetpInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetpInfoCopyWith<SetpInfo> get copyWith => _$SetpInfoCopyWithImpl<SetpInfo>(this as SetpInfo, _$identity);

  /// Serializes this SetpInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetpInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.error, error) || other.error == error)&&(identical(other.loading, loading) || other.loading == loading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,error,loading);

@override
String toString() {
  return 'SetpInfo(name: $name, error: $error, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $SetpInfoCopyWith<$Res>  {
  factory $SetpInfoCopyWith(SetpInfo value, $Res Function(SetpInfo) _then) = _$SetpInfoCopyWithImpl;
@useResult
$Res call({
 String name, String? error, bool? loading
});




}
/// @nodoc
class _$SetpInfoCopyWithImpl<$Res>
    implements $SetpInfoCopyWith<$Res> {
  _$SetpInfoCopyWithImpl(this._self, this._then);

  final SetpInfo _self;
  final $Res Function(SetpInfo) _then;

/// Create a copy of SetpInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? error = freezed,Object? loading = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,loading: freezed == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SetpInfo implements SetpInfo {
  const _SetpInfo({this.name = "", this.error = null, this.loading = null});
  factory _SetpInfo.fromJson(Map<String, dynamic> json) => _$SetpInfoFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String? error;
@override@JsonKey() final  bool? loading;

/// Create a copy of SetpInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetpInfoCopyWith<_SetpInfo> get copyWith => __$SetpInfoCopyWithImpl<_SetpInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetpInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetpInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.error, error) || other.error == error)&&(identical(other.loading, loading) || other.loading == loading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,error,loading);

@override
String toString() {
  return 'SetpInfo(name: $name, error: $error, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$SetpInfoCopyWith<$Res> implements $SetpInfoCopyWith<$Res> {
  factory _$SetpInfoCopyWith(_SetpInfo value, $Res Function(_SetpInfo) _then) = __$SetpInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String? error, bool? loading
});




}
/// @nodoc
class __$SetpInfoCopyWithImpl<$Res>
    implements _$SetpInfoCopyWith<$Res> {
  __$SetpInfoCopyWithImpl(this._self, this._then);

  final _SetpInfo _self;
  final $Res Function(_SetpInfo) _then;

/// Create a copy of SetpInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? error = freezed,Object? loading = freezed,}) {
  return _then(_SetpInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,loading: freezed == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
