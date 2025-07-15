// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../HapInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HapInfo _$HapInfoFromJson(Map<String, dynamic> json) {
  return _HapInfo.fromJson(json);
}

/// @nodoc
mixin _$HapInfo {
  String get packageName => throw _privateConstructorUsedError;
  List<String> get pathList => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  List<String> get deviceType => throw _privateConstructorUsedError;

  /// Serializes this HapInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HapInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HapInfoCopyWith<HapInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HapInfoCopyWith<$Res> {
  factory $HapInfoCopyWith(HapInfo value, $Res Function(HapInfo) then) =
      _$HapInfoCopyWithImpl<$Res, HapInfo>;
  @useResult
  $Res call(
      {String packageName,
      List<String> pathList,
      String? version,
      String? icon,
      List<String> deviceType});
}

/// @nodoc
class _$HapInfoCopyWithImpl<$Res, $Val extends HapInfo>
    implements $HapInfoCopyWith<$Res> {
  _$HapInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HapInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? pathList = null,
    Object? version = freezed,
    Object? icon = freezed,
    Object? deviceType = null,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      pathList: null == pathList
          ? _value.pathList
          : pathList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HapInfoImplCopyWith<$Res> implements $HapInfoCopyWith<$Res> {
  factory _$$HapInfoImplCopyWith(
          _$HapInfoImpl value, $Res Function(_$HapInfoImpl) then) =
      __$$HapInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String packageName,
      List<String> pathList,
      String? version,
      String? icon,
      List<String> deviceType});
}

/// @nodoc
class __$$HapInfoImplCopyWithImpl<$Res>
    extends _$HapInfoCopyWithImpl<$Res, _$HapInfoImpl>
    implements _$$HapInfoImplCopyWith<$Res> {
  __$$HapInfoImplCopyWithImpl(
      _$HapInfoImpl _value, $Res Function(_$HapInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of HapInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? pathList = null,
    Object? version = freezed,
    Object? icon = freezed,
    Object? deviceType = null,
  }) {
    return _then(_$HapInfoImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      pathList: null == pathList
          ? _value._pathList
          : pathList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value._deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HapInfoImpl implements _HapInfo {
  const _$HapInfoImpl(
      {this.packageName = "",
      final List<String> pathList = const [],
      this.version = null,
      this.icon = null,
      final List<String> deviceType = const []})
      : _pathList = pathList,
        _deviceType = deviceType;

  factory _$HapInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HapInfoImplFromJson(json);

  @override
  @JsonKey()
  final String packageName;
  final List<String> _pathList;
  @override
  @JsonKey()
  List<String> get pathList {
    if (_pathList is EqualUnmodifiableListView) return _pathList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pathList);
  }

  @override
  @JsonKey()
  final String? version;
  @override
  @JsonKey()
  final String? icon;
  final List<String> _deviceType;
  @override
  @JsonKey()
  List<String> get deviceType {
    if (_deviceType is EqualUnmodifiableListView) return _deviceType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deviceType);
  }

  @override
  String toString() {
    return 'HapInfo(packageName: $packageName, pathList: $pathList, version: $version, icon: $icon, deviceType: $deviceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HapInfoImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            const DeepCollectionEquality().equals(other._pathList, _pathList) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality()
                .equals(other._deviceType, _deviceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      packageName,
      const DeepCollectionEquality().hash(_pathList),
      version,
      icon,
      const DeepCollectionEquality().hash(_deviceType));

  /// Create a copy of HapInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HapInfoImplCopyWith<_$HapInfoImpl> get copyWith =>
      __$$HapInfoImplCopyWithImpl<_$HapInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HapInfoImplToJson(
      this,
    );
  }
}

abstract class _HapInfo implements HapInfo {
  const factory _HapInfo(
      {final String packageName,
      final List<String> pathList,
      final String? version,
      final String? icon,
      final List<String> deviceType}) = _$HapInfoImpl;

  factory _HapInfo.fromJson(Map<String, dynamic> json) = _$HapInfoImpl.fromJson;

  @override
  String get packageName;
  @override
  List<String> get pathList;
  @override
  String? get version;
  @override
  String? get icon;
  @override
  List<String> get deviceType;

  /// Create a copy of HapInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HapInfoImplCopyWith<_$HapInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
