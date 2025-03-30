// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../DebugHistory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DebugHistory _$DebugHistoryFromJson(Map<String, dynamic> json) {
  return _DebugHistory.fromJson(json);
}

/// @nodoc
mixin _$DebugHistory {
  HapInfo get hapInfo => throw _privateConstructorUsedError;
  set hapInfo(HapInfo value) => throw _privateConstructorUsedError;
  bool get finished => throw _privateConstructorUsedError;
  set finished(bool value) => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  set start(DateTime? value) => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  set end(DateTime? value) => throw _privateConstructorUsedError;
  List<SetpInfo> get setps => throw _privateConstructorUsedError;
  set setps(List<SetpInfo> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DebugHistoryCopyWith<DebugHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebugHistoryCopyWith<$Res> {
  factory $DebugHistoryCopyWith(
          DebugHistory value, $Res Function(DebugHistory) then) =
      _$DebugHistoryCopyWithImpl<$Res, DebugHistory>;
  @useResult
  $Res call(
      {HapInfo hapInfo,
      bool finished,
      DateTime? start,
      DateTime? end,
      List<SetpInfo> setps});

  $HapInfoCopyWith<$Res> get hapInfo;
}

/// @nodoc
class _$DebugHistoryCopyWithImpl<$Res, $Val extends DebugHistory>
    implements $DebugHistoryCopyWith<$Res> {
  _$DebugHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hapInfo = null,
    Object? finished = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? setps = null,
  }) {
    return _then(_value.copyWith(
      hapInfo: null == hapInfo
          ? _value.hapInfo
          : hapInfo // ignore: cast_nullable_to_non_nullable
              as HapInfo,
      finished: null == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as bool,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      setps: null == setps
          ? _value.setps
          : setps // ignore: cast_nullable_to_non_nullable
              as List<SetpInfo>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HapInfoCopyWith<$Res> get hapInfo {
    return $HapInfoCopyWith<$Res>(_value.hapInfo, (value) {
      return _then(_value.copyWith(hapInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebugHistoryImplCopyWith<$Res>
    implements $DebugHistoryCopyWith<$Res> {
  factory _$$DebugHistoryImplCopyWith(
          _$DebugHistoryImpl value, $Res Function(_$DebugHistoryImpl) then) =
      __$$DebugHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HapInfo hapInfo,
      bool finished,
      DateTime? start,
      DateTime? end,
      List<SetpInfo> setps});

  @override
  $HapInfoCopyWith<$Res> get hapInfo;
}

/// @nodoc
class __$$DebugHistoryImplCopyWithImpl<$Res>
    extends _$DebugHistoryCopyWithImpl<$Res, _$DebugHistoryImpl>
    implements _$$DebugHistoryImplCopyWith<$Res> {
  __$$DebugHistoryImplCopyWithImpl(
      _$DebugHistoryImpl _value, $Res Function(_$DebugHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hapInfo = null,
    Object? finished = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? setps = null,
  }) {
    return _then(_$DebugHistoryImpl(
      hapInfo: null == hapInfo
          ? _value.hapInfo
          : hapInfo // ignore: cast_nullable_to_non_nullable
              as HapInfo,
      finished: null == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as bool,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      setps: null == setps
          ? _value.setps
          : setps // ignore: cast_nullable_to_non_nullable
              as List<SetpInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugHistoryImpl implements _DebugHistory {
  _$DebugHistoryImpl(
      {required this.hapInfo,
      this.finished = false,
      this.start = null,
      this.end = null,
      this.setps = const [
        SetpInfo(name: "登录检查"),
        SetpInfo(name: "连接状态检查"),
        SetpInfo(name: "请求签名"),
        SetpInfo(name: "签名应用"),
        SetpInfo(name: "安装应用")
      ]});

  factory _$DebugHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugHistoryImplFromJson(json);

  @override
  HapInfo hapInfo;
  @override
  @JsonKey()
  bool finished;
  @override
  @JsonKey()
  DateTime? start;
  @override
  @JsonKey()
  DateTime? end;
  @override
  @JsonKey()
  List<SetpInfo> setps;

  @override
  String toString() {
    return 'DebugHistory(hapInfo: $hapInfo, finished: $finished, start: $start, end: $end, setps: $setps)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DebugHistoryImplCopyWith<_$DebugHistoryImpl> get copyWith =>
      __$$DebugHistoryImplCopyWithImpl<_$DebugHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebugHistoryImplToJson(
      this,
    );
  }
}

abstract class _DebugHistory implements DebugHistory {
  factory _DebugHistory(
      {required HapInfo hapInfo,
      bool finished,
      DateTime? start,
      DateTime? end,
      List<SetpInfo> setps}) = _$DebugHistoryImpl;

  factory _DebugHistory.fromJson(Map<String, dynamic> json) =
      _$DebugHistoryImpl.fromJson;

  @override
  HapInfo get hapInfo;
  set hapInfo(HapInfo value);
  @override
  bool get finished;
  set finished(bool value);
  @override
  DateTime? get start;
  set start(DateTime? value);
  @override
  DateTime? get end;
  set end(DateTime? value);
  @override
  List<SetpInfo> get setps;
  set setps(List<SetpInfo> value);
  @override
  @JsonKey(ignore: true)
  _$$DebugHistoryImplCopyWith<_$DebugHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetpInfo _$SetpInfoFromJson(Map<String, dynamic> json) {
  return _SetpInfo.fromJson(json);
}

/// @nodoc
mixin _$SetpInfo {
  String get name => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool? get loading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetpInfoCopyWith<SetpInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetpInfoCopyWith<$Res> {
  factory $SetpInfoCopyWith(SetpInfo value, $Res Function(SetpInfo) then) =
      _$SetpInfoCopyWithImpl<$Res, SetpInfo>;
  @useResult
  $Res call({String name, String? error, bool? loading});
}

/// @nodoc
class _$SetpInfoCopyWithImpl<$Res, $Val extends SetpInfo>
    implements $SetpInfoCopyWith<$Res> {
  _$SetpInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? error = freezed,
    Object? loading = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: freezed == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetpInfoImplCopyWith<$Res>
    implements $SetpInfoCopyWith<$Res> {
  factory _$$SetpInfoImplCopyWith(
          _$SetpInfoImpl value, $Res Function(_$SetpInfoImpl) then) =
      __$$SetpInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? error, bool? loading});
}

/// @nodoc
class __$$SetpInfoImplCopyWithImpl<$Res>
    extends _$SetpInfoCopyWithImpl<$Res, _$SetpInfoImpl>
    implements _$$SetpInfoImplCopyWith<$Res> {
  __$$SetpInfoImplCopyWithImpl(
      _$SetpInfoImpl _value, $Res Function(_$SetpInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? error = freezed,
    Object? loading = freezed,
  }) {
    return _then(_$SetpInfoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: freezed == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetpInfoImpl implements _SetpInfo {
  const _$SetpInfoImpl(
      {this.name = "", this.error = null, this.loading = null});

  factory _$SetpInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetpInfoImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final bool? loading;

  @override
  String toString() {
    return 'SetpInfo(name: $name, error: $error, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetpInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, error, loading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetpInfoImplCopyWith<_$SetpInfoImpl> get copyWith =>
      __$$SetpInfoImplCopyWithImpl<_$SetpInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetpInfoImplToJson(
      this,
    );
  }
}

abstract class _SetpInfo implements SetpInfo {
  const factory _SetpInfo(
      {final String name,
      final String? error,
      final bool? loading}) = _$SetpInfoImpl;

  factory _SetpInfo.fromJson(Map<String, dynamic> json) =
      _$SetpInfoImpl.fromJson;

  @override
  String get name;
  @override
  String? get error;
  @override
  bool? get loading;
  @override
  @JsonKey(ignore: true)
  _$$SetpInfoImplCopyWith<_$SetpInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
