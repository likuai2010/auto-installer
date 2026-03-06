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
  String get time => throw _privateConstructorUsedError;
  set time(String value) => throw _privateConstructorUsedError;
  List<DebugApp> get payList => throw _privateConstructorUsedError;
  set payList(List<DebugApp> value) => throw _privateConstructorUsedError;

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
  $Res call({String time, List<DebugApp> payList});
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
    Object? time = null,
    Object? payList = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      payList: null == payList
          ? _value.payList
          : payList // ignore: cast_nullable_to_non_nullable
              as List<DebugApp>,
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
  $Res call({String time, List<DebugApp> payList});
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
    Object? time = null,
    Object? payList = null,
  }) {
    return _then(_$DebugAppListImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      payList: null == payList
          ? _value.payList
          : payList // ignore: cast_nullable_to_non_nullable
              as List<DebugApp>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugAppListImpl implements _DebugAppList {
  _$DebugAppListImpl({this.time = "", this.payList = const []});

  factory _$DebugAppListImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugAppListImplFromJson(json);

  @override
  @JsonKey()
  String time;
  @override
  @JsonKey()
  List<DebugApp> payList;

  @override
  String toString() {
    return 'DebugAppList(time: $time, payList: $payList)';
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
  factory _DebugAppList({String time, List<DebugApp> payList}) =
      _$DebugAppListImpl;

  factory _DebugAppList.fromJson(Map<String, dynamic> json) =
      _$DebugAppListImpl.fromJson;

  @override
  String get time;
  set time(String value);
  @override
  List<DebugApp> get payList;
  set payList(List<DebugApp> value);

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
  String get label => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  DateTime? get installTime => throw _privateConstructorUsedError;
  DateTime? get certEndTime => throw _privateConstructorUsedError;
  String? get appPath => throw _privateConstructorUsedError;

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
      String label,
      String icon,
      DateTime? installTime,
      DateTime? certEndTime,
      String? appPath});
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
    Object? label = null,
    Object? icon = null,
    Object? installTime = freezed,
    Object? certEndTime = freezed,
    Object? appPath = freezed,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      installTime: freezed == installTime
          ? _value.installTime
          : installTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certEndTime: freezed == certEndTime
          ? _value.certEndTime
          : certEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appPath: freezed == appPath
          ? _value.appPath
          : appPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
      String label,
      String icon,
      DateTime? installTime,
      DateTime? certEndTime,
      String? appPath});
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
    Object? label = null,
    Object? icon = null,
    Object? installTime = freezed,
    Object? certEndTime = freezed,
    Object? appPath = freezed,
  }) {
    return _then(_$DebugAppImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      installTime: freezed == installTime
          ? _value.installTime
          : installTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certEndTime: freezed == certEndTime
          ? _value.certEndTime
          : certEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appPath: freezed == appPath
          ? _value.appPath
          : appPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugAppImpl implements _DebugApp {
  const _$DebugAppImpl(
      {this.packageName = "",
      this.label = "",
      this.icon = "",
      this.installTime = null,
      this.certEndTime = null,
      this.appPath = ""});

  factory _$DebugAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugAppImplFromJson(json);

  @override
  @JsonKey()
  final String packageName;
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final DateTime? installTime;
  @override
  @JsonKey()
  final DateTime? certEndTime;
  @override
  @JsonKey()
  final String? appPath;

  @override
  String toString() {
    return 'DebugApp(packageName: $packageName, label: $label, icon: $icon, installTime: $installTime, certEndTime: $certEndTime, appPath: $appPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebugAppImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.installTime, installTime) ||
                other.installTime == installTime) &&
            (identical(other.certEndTime, certEndTime) ||
                other.certEndTime == certEndTime) &&
            (identical(other.appPath, appPath) || other.appPath == appPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, packageName, label, icon, installTime, certEndTime, appPath);

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
      final String label,
      final String icon,
      final DateTime? installTime,
      final DateTime? certEndTime,
      final String? appPath}) = _$DebugAppImpl;

  factory _DebugApp.fromJson(Map<String, dynamic> json) =
      _$DebugAppImpl.fromJson;

  @override
  String get packageName;
  @override
  String get label;
  @override
  String get icon;
  @override
  DateTime? get installTime;
  @override
  DateTime? get certEndTime;
  @override
  String? get appPath;

  /// Create a copy of DebugApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebugAppImplCopyWith<_$DebugAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
