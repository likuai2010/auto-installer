// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../DebugAppList.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DebugAppList _$DebugAppListFromJson(Map<String, dynamic> json) {
  return _DebugAppList.fromJson(json);
}

/// @nodoc
mixin _$DebugAppList {
  List<DebugApp> get appList => throw _privateConstructorUsedError;
  set appList(List<DebugApp> value) => throw _privateConstructorUsedError;
  DateTime? get time => throw _privateConstructorUsedError;
  set time(DateTime? value) => throw _privateConstructorUsedError;

  /// Serializes this DebugAppList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebugAppList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebugAppListCopyWith<DebugAppList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebugAppListCopyWith<$Res> {
  factory $DebugAppListCopyWith(
          DebugAppList value, $Res Function(DebugAppList) then) =
      _$DebugAppListCopyWithImpl<$Res, DebugAppList>;
  @useResult
  $Res call({List<DebugApp> appList, DateTime? time});
}

/// @nodoc
class _$DebugAppListCopyWithImpl<$Res, $Val extends DebugAppList>
    implements $DebugAppListCopyWith<$Res> {
  _$DebugAppListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebugAppList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appList = null,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      appList: null == appList
          ? _value.appList
          : appList // ignore: cast_nullable_to_non_nullable
              as List<DebugApp>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebugAppListImplCopyWith<$Res>
    implements $DebugAppListCopyWith<$Res> {
  factory _$$DebugAppListImplCopyWith(
          _$DebugAppListImpl value, $Res Function(_$DebugAppListImpl) then) =
      __$$DebugAppListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DebugApp> appList, DateTime? time});
}

/// @nodoc
class __$$DebugAppListImplCopyWithImpl<$Res>
    extends _$DebugAppListCopyWithImpl<$Res, _$DebugAppListImpl>
    implements _$$DebugAppListImplCopyWith<$Res> {
  __$$DebugAppListImplCopyWithImpl(
      _$DebugAppListImpl _value, $Res Function(_$DebugAppListImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebugAppList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appList = null,
    Object? time = freezed,
  }) {
    return _then(_$DebugAppListImpl(
      appList: null == appList
          ? _value.appList
          : appList // ignore: cast_nullable_to_non_nullable
              as List<DebugApp>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugAppListImpl implements _DebugAppList {
  _$DebugAppListImpl({this.appList = const [], this.time = null});

  factory _$DebugAppListImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugAppListImplFromJson(json);

  @override
  @JsonKey()
  List<DebugApp> appList;
  @override
  @JsonKey()
  DateTime? time;

  @override
  String toString() {
    return 'DebugAppList(appList: $appList, time: $time)';
  }

  /// Create a copy of DebugAppList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebugAppListImplCopyWith<_$DebugAppListImpl> get copyWith =>
      __$$DebugAppListImplCopyWithImpl<_$DebugAppListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebugAppListImplToJson(
      this,
    );
  }
}

abstract class _DebugAppList implements DebugAppList {
  factory _DebugAppList({List<DebugApp> appList, DateTime? time}) =
      _$DebugAppListImpl;

  factory _DebugAppList.fromJson(Map<String, dynamic> json) =
      _$DebugAppListImpl.fromJson;

  @override
  List<DebugApp> get appList;
  set appList(List<DebugApp> value);
  @override
  DateTime? get time;
  set time(DateTime? value);

  /// Create a copy of DebugAppList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebugAppListImplCopyWith<_$DebugAppListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebugApp _$DebugAppFromJson(Map<String, dynamic> json) {
  return _DebugApp.fromJson(json);
}

/// @nodoc
mixin _$DebugApp {
  String get packageName => throw _privateConstructorUsedError;
  HapInfo? get appInfo => throw _privateConstructorUsedError;
  DateTime? get installTime => throw _privateConstructorUsedError;
  DateTime? get certEndTime => throw _privateConstructorUsedError;

  /// Serializes this DebugApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebugAppCopyWith<DebugApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebugAppCopyWith<$Res> {
  factory $DebugAppCopyWith(DebugApp value, $Res Function(DebugApp) then) =
      _$DebugAppCopyWithImpl<$Res, DebugApp>;
  @useResult
  $Res call(
      {String packageName,
      HapInfo? appInfo,
      DateTime? installTime,
      DateTime? certEndTime});

  $HapInfoCopyWith<$Res>? get appInfo;
}

/// @nodoc
class _$DebugAppCopyWithImpl<$Res, $Val extends DebugApp>
    implements $DebugAppCopyWith<$Res> {
  _$DebugAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? appInfo = freezed,
    Object? installTime = freezed,
    Object? certEndTime = freezed,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      appInfo: freezed == appInfo
          ? _value.appInfo
          : appInfo // ignore: cast_nullable_to_non_nullable
              as HapInfo?,
      installTime: freezed == installTime
          ? _value.installTime
          : installTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certEndTime: freezed == certEndTime
          ? _value.certEndTime
          : certEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HapInfoCopyWith<$Res>? get appInfo {
    if (_value.appInfo == null) {
      return null;
    }

    return $HapInfoCopyWith<$Res>(_value.appInfo!, (value) {
      return _then(_value.copyWith(appInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebugAppImplCopyWith<$Res>
    implements $DebugAppCopyWith<$Res> {
  factory _$$DebugAppImplCopyWith(
          _$DebugAppImpl value, $Res Function(_$DebugAppImpl) then) =
      __$$DebugAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String packageName,
      HapInfo? appInfo,
      DateTime? installTime,
      DateTime? certEndTime});

  @override
  $HapInfoCopyWith<$Res>? get appInfo;
}

/// @nodoc
class __$$DebugAppImplCopyWithImpl<$Res>
    extends _$DebugAppCopyWithImpl<$Res, _$DebugAppImpl>
    implements _$$DebugAppImplCopyWith<$Res> {
  __$$DebugAppImplCopyWithImpl(
      _$DebugAppImpl _value, $Res Function(_$DebugAppImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? appInfo = freezed,
    Object? installTime = freezed,
    Object? certEndTime = freezed,
  }) {
    return _then(_$DebugAppImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      appInfo: freezed == appInfo
          ? _value.appInfo
          : appInfo // ignore: cast_nullable_to_non_nullable
              as HapInfo?,
      installTime: freezed == installTime
          ? _value.installTime
          : installTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certEndTime: freezed == certEndTime
          ? _value.certEndTime
          : certEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugAppImpl implements _DebugApp {
  const _$DebugAppImpl(
      {this.packageName = "",
      this.appInfo = null,
      this.installTime = null,
      this.certEndTime = null});

  factory _$DebugAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugAppImplFromJson(json);

  @override
  @JsonKey()
  final String packageName;
  @override
  @JsonKey()
  final HapInfo? appInfo;
  @override
  @JsonKey()
  final DateTime? installTime;
  @override
  @JsonKey()
  final DateTime? certEndTime;

  @override
  String toString() {
    return 'DebugApp(packageName: $packageName, appInfo: $appInfo, installTime: $installTime, certEndTime: $certEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebugAppImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appInfo, appInfo) || other.appInfo == appInfo) &&
            (identical(other.installTime, installTime) ||
                other.installTime == installTime) &&
            (identical(other.certEndTime, certEndTime) ||
                other.certEndTime == certEndTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, packageName, appInfo, installTime, certEndTime);

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebugAppImplCopyWith<_$DebugAppImpl> get copyWith =>
      __$$DebugAppImplCopyWithImpl<_$DebugAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebugAppImplToJson(
      this,
    );
  }
}

abstract class _DebugApp implements DebugApp {
  const factory _DebugApp(
      {final String packageName,
      final HapInfo? appInfo,
      final DateTime? installTime,
      final DateTime? certEndTime}) = _$DebugAppImpl;

  factory _DebugApp.fromJson(Map<String, dynamic> json) =
      _$DebugAppImpl.fromJson;

  @override
  String get packageName;
  @override
  HapInfo? get appInfo;
  @override
  DateTime? get installTime;
  @override
  DateTime? get certEndTime;

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebugAppImplCopyWith<_$DebugAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
