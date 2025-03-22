// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../HapInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HapInfo {

 String get packageName; List<String> get pathList; String? get version; String? get icon;
/// Create a copy of HapInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HapInfoCopyWith<HapInfo> get copyWith => _$HapInfoCopyWithImpl<HapInfo>(this as HapInfo, _$identity);

  /// Serializes this HapInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HapInfo&&(identical(other.packageName, packageName) || other.packageName == packageName)&&const DeepCollectionEquality().equals(other.pathList, pathList)&&(identical(other.version, version) || other.version == version)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,const DeepCollectionEquality().hash(pathList),version,icon);

@override
String toString() {
  return 'HapInfo(packageName: $packageName, pathList: $pathList, version: $version, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $HapInfoCopyWith<$Res>  {
  factory $HapInfoCopyWith(HapInfo value, $Res Function(HapInfo) _then) = _$HapInfoCopyWithImpl;
@useResult
$Res call({
 String packageName, List<String> pathList, String? version, String? icon
});




}
/// @nodoc
class _$HapInfoCopyWithImpl<$Res>
    implements $HapInfoCopyWith<$Res> {
  _$HapInfoCopyWithImpl(this._self, this._then);

  final HapInfo _self;
  final $Res Function(HapInfo) _then;

/// Create a copy of HapInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? pathList = null,Object? version = freezed,Object? icon = freezed,}) {
  return _then(_self.copyWith(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,pathList: null == pathList ? _self.pathList : pathList // ignore: cast_nullable_to_non_nullable
as List<String>,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _HapInfo implements HapInfo {
  const _HapInfo({this.packageName = "", final  List<String> pathList = const [], this.version = null, this.icon = null}): _pathList = pathList;
  factory _HapInfo.fromJson(Map<String, dynamic> json) => _$HapInfoFromJson(json);

@override@JsonKey() final  String packageName;
 final  List<String> _pathList;
@override@JsonKey() List<String> get pathList {
  if (_pathList is EqualUnmodifiableListView) return _pathList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pathList);
}

@override@JsonKey() final  String? version;
@override@JsonKey() final  String? icon;

/// Create a copy of HapInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HapInfoCopyWith<_HapInfo> get copyWith => __$HapInfoCopyWithImpl<_HapInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HapInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HapInfo&&(identical(other.packageName, packageName) || other.packageName == packageName)&&const DeepCollectionEquality().equals(other._pathList, _pathList)&&(identical(other.version, version) || other.version == version)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,const DeepCollectionEquality().hash(_pathList),version,icon);

@override
String toString() {
  return 'HapInfo(packageName: $packageName, pathList: $pathList, version: $version, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$HapInfoCopyWith<$Res> implements $HapInfoCopyWith<$Res> {
  factory _$HapInfoCopyWith(_HapInfo value, $Res Function(_HapInfo) _then) = __$HapInfoCopyWithImpl;
@override @useResult
$Res call({
 String packageName, List<String> pathList, String? version, String? icon
});




}
/// @nodoc
class __$HapInfoCopyWithImpl<$Res>
    implements _$HapInfoCopyWith<$Res> {
  __$HapInfoCopyWithImpl(this._self, this._then);

  final _HapInfo _self;
  final $Res Function(_HapInfo) _then;

/// Create a copy of HapInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? pathList = null,Object? version = freezed,Object? icon = freezed,}) {
  return _then(_HapInfo(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,pathList: null == pathList ? _self._pathList : pathList // ignore: cast_nullable_to_non_nullable
as List<String>,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
