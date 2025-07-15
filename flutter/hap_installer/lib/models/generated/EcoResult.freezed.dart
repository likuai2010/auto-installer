// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../EcoResult.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EcoResult _$EcoResultFromJson(Map<String, dynamic> json) {
  return _EcoResult.fromJson(json);
}

/// @nodoc
mixin _$EcoResult {
  Ret get ret => throw _privateConstructorUsedError;
  List<TeamInfo>? get teams => throw _privateConstructorUsedError;
  List<DeviceInfo>? get list => throw _privateConstructorUsedError;
  List<CertInfo>? get certList => throw _privateConstructorUsedError;
  AuthInfo? get userInfo => throw _privateConstructorUsedError;
  CertInfo? get harmonyCert => throw _privateConstructorUsedError;
  List<UrlInfo>? get urlsInfo => throw _privateConstructorUsedError;
  String? get provisionFileUrl => throw _privateConstructorUsedError;

  /// Serializes this EcoResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EcoResultCopyWith<EcoResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EcoResultCopyWith<$Res> {
  factory $EcoResultCopyWith(EcoResult value, $Res Function(EcoResult) then) =
      _$EcoResultCopyWithImpl<$Res, EcoResult>;
  @useResult
  $Res call(
      {Ret ret,
      List<TeamInfo>? teams,
      List<DeviceInfo>? list,
      List<CertInfo>? certList,
      AuthInfo? userInfo,
      CertInfo? harmonyCert,
      List<UrlInfo>? urlsInfo,
      String? provisionFileUrl});

  $RetCopyWith<$Res> get ret;
  $CertInfoCopyWith<$Res>? get harmonyCert;
}

/// @nodoc
class _$EcoResultCopyWithImpl<$Res, $Val extends EcoResult>
    implements $EcoResultCopyWith<$Res> {
  _$EcoResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ret = null,
    Object? teams = freezed,
    Object? list = freezed,
    Object? certList = freezed,
    Object? userInfo = freezed,
    Object? harmonyCert = freezed,
    Object? urlsInfo = freezed,
    Object? provisionFileUrl = freezed,
  }) {
    return _then(_value.copyWith(
      ret: null == ret
          ? _value.ret
          : ret // ignore: cast_nullable_to_non_nullable
              as Ret,
      teams: freezed == teams
          ? _value.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamInfo>?,
      list: freezed == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<DeviceInfo>?,
      certList: freezed == certList
          ? _value.certList
          : certList // ignore: cast_nullable_to_non_nullable
              as List<CertInfo>?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as AuthInfo?,
      harmonyCert: freezed == harmonyCert
          ? _value.harmonyCert
          : harmonyCert // ignore: cast_nullable_to_non_nullable
              as CertInfo?,
      urlsInfo: freezed == urlsInfo
          ? _value.urlsInfo
          : urlsInfo // ignore: cast_nullable_to_non_nullable
              as List<UrlInfo>?,
      provisionFileUrl: freezed == provisionFileUrl
          ? _value.provisionFileUrl
          : provisionFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RetCopyWith<$Res> get ret {
    return $RetCopyWith<$Res>(_value.ret, (value) {
      return _then(_value.copyWith(ret: value) as $Val);
    });
  }

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CertInfoCopyWith<$Res>? get harmonyCert {
    if (_value.harmonyCert == null) {
      return null;
    }

    return $CertInfoCopyWith<$Res>(_value.harmonyCert!, (value) {
      return _then(_value.copyWith(harmonyCert: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EcoResultImplCopyWith<$Res>
    implements $EcoResultCopyWith<$Res> {
  factory _$$EcoResultImplCopyWith(
          _$EcoResultImpl value, $Res Function(_$EcoResultImpl) then) =
      __$$EcoResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Ret ret,
      List<TeamInfo>? teams,
      List<DeviceInfo>? list,
      List<CertInfo>? certList,
      AuthInfo? userInfo,
      CertInfo? harmonyCert,
      List<UrlInfo>? urlsInfo,
      String? provisionFileUrl});

  @override
  $RetCopyWith<$Res> get ret;
  @override
  $CertInfoCopyWith<$Res>? get harmonyCert;
}

/// @nodoc
class __$$EcoResultImplCopyWithImpl<$Res>
    extends _$EcoResultCopyWithImpl<$Res, _$EcoResultImpl>
    implements _$$EcoResultImplCopyWith<$Res> {
  __$$EcoResultImplCopyWithImpl(
      _$EcoResultImpl _value, $Res Function(_$EcoResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ret = null,
    Object? teams = freezed,
    Object? list = freezed,
    Object? certList = freezed,
    Object? userInfo = freezed,
    Object? harmonyCert = freezed,
    Object? urlsInfo = freezed,
    Object? provisionFileUrl = freezed,
  }) {
    return _then(_$EcoResultImpl(
      ret: null == ret
          ? _value.ret
          : ret // ignore: cast_nullable_to_non_nullable
              as Ret,
      teams: freezed == teams
          ? _value._teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamInfo>?,
      list: freezed == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<DeviceInfo>?,
      certList: freezed == certList
          ? _value._certList
          : certList // ignore: cast_nullable_to_non_nullable
              as List<CertInfo>?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as AuthInfo?,
      harmonyCert: freezed == harmonyCert
          ? _value.harmonyCert
          : harmonyCert // ignore: cast_nullable_to_non_nullable
              as CertInfo?,
      urlsInfo: freezed == urlsInfo
          ? _value._urlsInfo
          : urlsInfo // ignore: cast_nullable_to_non_nullable
              as List<UrlInfo>?,
      provisionFileUrl: freezed == provisionFileUrl
          ? _value.provisionFileUrl
          : provisionFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EcoResultImpl with DiagnosticableTreeMixin implements _EcoResult {
  const _$EcoResultImpl(
      {this.ret = const Ret(),
      final List<TeamInfo>? teams = null,
      final List<DeviceInfo>? list = null,
      final List<CertInfo>? certList = null,
      this.userInfo = null,
      this.harmonyCert = null,
      final List<UrlInfo>? urlsInfo = null,
      this.provisionFileUrl = null})
      : _teams = teams,
        _list = list,
        _certList = certList,
        _urlsInfo = urlsInfo;

  factory _$EcoResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EcoResultImplFromJson(json);

  @override
  @JsonKey()
  final Ret ret;
  final List<TeamInfo>? _teams;
  @override
  @JsonKey()
  List<TeamInfo>? get teams {
    final value = _teams;
    if (value == null) return null;
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<DeviceInfo>? _list;
  @override
  @JsonKey()
  List<DeviceInfo>? get list {
    final value = _list;
    if (value == null) return null;
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CertInfo>? _certList;
  @override
  @JsonKey()
  List<CertInfo>? get certList {
    final value = _certList;
    if (value == null) return null;
    if (_certList is EqualUnmodifiableListView) return _certList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final AuthInfo? userInfo;
  @override
  @JsonKey()
  final CertInfo? harmonyCert;
  final List<UrlInfo>? _urlsInfo;
  @override
  @JsonKey()
  List<UrlInfo>? get urlsInfo {
    final value = _urlsInfo;
    if (value == null) return null;
    if (_urlsInfo is EqualUnmodifiableListView) return _urlsInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String? provisionFileUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EcoResult(ret: $ret, teams: $teams, list: $list, certList: $certList, userInfo: $userInfo, harmonyCert: $harmonyCert, urlsInfo: $urlsInfo, provisionFileUrl: $provisionFileUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EcoResult'))
      ..add(DiagnosticsProperty('ret', ret))
      ..add(DiagnosticsProperty('teams', teams))
      ..add(DiagnosticsProperty('list', list))
      ..add(DiagnosticsProperty('certList', certList))
      ..add(DiagnosticsProperty('userInfo', userInfo))
      ..add(DiagnosticsProperty('harmonyCert', harmonyCert))
      ..add(DiagnosticsProperty('urlsInfo', urlsInfo))
      ..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EcoResultImpl &&
            (identical(other.ret, ret) || other.ret == ret) &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            const DeepCollectionEquality().equals(other._certList, _certList) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.harmonyCert, harmonyCert) ||
                other.harmonyCert == harmonyCert) &&
            const DeepCollectionEquality().equals(other._urlsInfo, _urlsInfo) &&
            (identical(other.provisionFileUrl, provisionFileUrl) ||
                other.provisionFileUrl == provisionFileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ret,
      const DeepCollectionEquality().hash(_teams),
      const DeepCollectionEquality().hash(_list),
      const DeepCollectionEquality().hash(_certList),
      userInfo,
      harmonyCert,
      const DeepCollectionEquality().hash(_urlsInfo),
      provisionFileUrl);

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EcoResultImplCopyWith<_$EcoResultImpl> get copyWith =>
      __$$EcoResultImplCopyWithImpl<_$EcoResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EcoResultImplToJson(
      this,
    );
  }
}

abstract class _EcoResult implements EcoResult {
  const factory _EcoResult(
      {final Ret ret,
      final List<TeamInfo>? teams,
      final List<DeviceInfo>? list,
      final List<CertInfo>? certList,
      final AuthInfo? userInfo,
      final CertInfo? harmonyCert,
      final List<UrlInfo>? urlsInfo,
      final String? provisionFileUrl}) = _$EcoResultImpl;

  factory _EcoResult.fromJson(Map<String, dynamic> json) =
      _$EcoResultImpl.fromJson;

  @override
  Ret get ret;
  @override
  List<TeamInfo>? get teams;
  @override
  List<DeviceInfo>? get list;
  @override
  List<CertInfo>? get certList;
  @override
  AuthInfo? get userInfo;
  @override
  CertInfo? get harmonyCert;
  @override
  List<UrlInfo>? get urlsInfo;
  @override
  String? get provisionFileUrl;

  /// Create a copy of EcoResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EcoResultImplCopyWith<_$EcoResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ret _$RetFromJson(Map<String, dynamic> json) {
  return _Ret.fromJson(json);
}

/// @nodoc
mixin _$Ret {
  int get code => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;

  /// Serializes this Ret to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RetCopyWith<Ret> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetCopyWith<$Res> {
  factory $RetCopyWith(Ret value, $Res Function(Ret) then) =
      _$RetCopyWithImpl<$Res, Ret>;
  @useResult
  $Res call({int code, String msg});
}

/// @nodoc
class _$RetCopyWithImpl<$Res, $Val extends Ret> implements $RetCopyWith<$Res> {
  _$RetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? msg = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RetImplCopyWith<$Res> implements $RetCopyWith<$Res> {
  factory _$$RetImplCopyWith(_$RetImpl value, $Res Function(_$RetImpl) then) =
      __$$RetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int code, String msg});
}

/// @nodoc
class __$$RetImplCopyWithImpl<$Res> extends _$RetCopyWithImpl<$Res, _$RetImpl>
    implements _$$RetImplCopyWith<$Res> {
  __$$RetImplCopyWithImpl(_$RetImpl _value, $Res Function(_$RetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? msg = null,
  }) {
    return _then(_$RetImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RetImpl with DiagnosticableTreeMixin implements _Ret {
  const _$RetImpl({this.code = 0, this.msg = ""});

  factory _$RetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetImplFromJson(json);

  @override
  @JsonKey()
  final int code;
  @override
  @JsonKey()
  final String msg;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Ret(code: $code, msg: $msg)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Ret'))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('msg', msg));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, msg);

  /// Create a copy of Ret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetImplCopyWith<_$RetImpl> get copyWith =>
      __$$RetImplCopyWithImpl<_$RetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RetImplToJson(
      this,
    );
  }
}

abstract class _Ret implements Ret {
  const factory _Ret({final int code, final String msg}) = _$RetImpl;

  factory _Ret.fromJson(Map<String, dynamic> json) = _$RetImpl.fromJson;

  @override
  int get code;
  @override
  String get msg;

  /// Create a copy of Ret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetImplCopyWith<_$RetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UrlInfo _$UrlInfoFromJson(Map<String, dynamic> json) {
  return _UrlInfo.fromJson(json);
}

/// @nodoc
mixin _$UrlInfo {
  String get newUrl => throw _privateConstructorUsedError;

  /// Serializes this UrlInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UrlInfoCopyWith<UrlInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UrlInfoCopyWith<$Res> {
  factory $UrlInfoCopyWith(UrlInfo value, $Res Function(UrlInfo) then) =
      _$UrlInfoCopyWithImpl<$Res, UrlInfo>;
  @useResult
  $Res call({String newUrl});
}

/// @nodoc
class _$UrlInfoCopyWithImpl<$Res, $Val extends UrlInfo>
    implements $UrlInfoCopyWith<$Res> {
  _$UrlInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newUrl = null,
  }) {
    return _then(_value.copyWith(
      newUrl: null == newUrl
          ? _value.newUrl
          : newUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UrlInfoImplCopyWith<$Res> implements $UrlInfoCopyWith<$Res> {
  factory _$$UrlInfoImplCopyWith(
          _$UrlInfoImpl value, $Res Function(_$UrlInfoImpl) then) =
      __$$UrlInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newUrl});
}

/// @nodoc
class __$$UrlInfoImplCopyWithImpl<$Res>
    extends _$UrlInfoCopyWithImpl<$Res, _$UrlInfoImpl>
    implements _$$UrlInfoImplCopyWith<$Res> {
  __$$UrlInfoImplCopyWithImpl(
      _$UrlInfoImpl _value, $Res Function(_$UrlInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newUrl = null,
  }) {
    return _then(_$UrlInfoImpl(
      newUrl: null == newUrl
          ? _value.newUrl
          : newUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UrlInfoImpl with DiagnosticableTreeMixin implements _UrlInfo {
  const _$UrlInfoImpl({this.newUrl = ""});

  factory _$UrlInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UrlInfoImplFromJson(json);

  @override
  @JsonKey()
  final String newUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UrlInfo(newUrl: $newUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UrlInfo'))
      ..add(DiagnosticsProperty('newUrl', newUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UrlInfoImpl &&
            (identical(other.newUrl, newUrl) || other.newUrl == newUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newUrl);

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UrlInfoImplCopyWith<_$UrlInfoImpl> get copyWith =>
      __$$UrlInfoImplCopyWithImpl<_$UrlInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UrlInfoImplToJson(
      this,
    );
  }
}

abstract class _UrlInfo implements UrlInfo {
  const factory _UrlInfo({final String newUrl}) = _$UrlInfoImpl;

  factory _UrlInfo.fromJson(Map<String, dynamic> json) = _$UrlInfoImpl.fromJson;

  @override
  String get newUrl;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UrlInfoImplCopyWith<_$UrlInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamInfo _$TeamInfoFromJson(Map<String, dynamic> json) {
  return _TeamInfo.fromJson(json);
}

/// @nodoc
mixin _$TeamInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  String get lastLoginTime => throw _privateConstructorUsedError;

  /// Serializes this TeamInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInfoCopyWith<TeamInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInfoCopyWith<$Res> {
  factory $TeamInfoCopyWith(TeamInfo value, $Res Function(TeamInfo) then) =
      _$TeamInfoCopyWithImpl<$Res, TeamInfo>;
  @useResult
  $Res call({String id, String name, String countryCode, String lastLoginTime});
}

/// @nodoc
class _$TeamInfoCopyWithImpl<$Res, $Val extends TeamInfo>
    implements $TeamInfoCopyWith<$Res> {
  _$TeamInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? countryCode = null,
    Object? lastLoginTime = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      lastLoginTime: null == lastLoginTime
          ? _value.lastLoginTime
          : lastLoginTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamInfoImplCopyWith<$Res>
    implements $TeamInfoCopyWith<$Res> {
  factory _$$TeamInfoImplCopyWith(
          _$TeamInfoImpl value, $Res Function(_$TeamInfoImpl) then) =
      __$$TeamInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String countryCode, String lastLoginTime});
}

/// @nodoc
class __$$TeamInfoImplCopyWithImpl<$Res>
    extends _$TeamInfoCopyWithImpl<$Res, _$TeamInfoImpl>
    implements _$$TeamInfoImplCopyWith<$Res> {
  __$$TeamInfoImplCopyWithImpl(
      _$TeamInfoImpl _value, $Res Function(_$TeamInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? countryCode = null,
    Object? lastLoginTime = null,
  }) {
    return _then(_$TeamInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      lastLoginTime: null == lastLoginTime
          ? _value.lastLoginTime
          : lastLoginTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInfoImpl with DiagnosticableTreeMixin implements _TeamInfo {
  const _$TeamInfoImpl(
      {this.id = "",
      this.name = '',
      this.countryCode = "",
      this.lastLoginTime = ""});

  factory _$TeamInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInfoImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String countryCode;
  @override
  @JsonKey()
  final String lastLoginTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TeamInfo(id: $id, name: $name, countryCode: $countryCode, lastLoginTime: $lastLoginTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TeamInfo'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('countryCode', countryCode))
      ..add(DiagnosticsProperty('lastLoginTime', lastLoginTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.lastLoginTime, lastLoginTime) ||
                other.lastLoginTime == lastLoginTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, countryCode, lastLoginTime);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      __$$TeamInfoImplCopyWithImpl<_$TeamInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInfoImplToJson(
      this,
    );
  }
}

abstract class _TeamInfo implements TeamInfo {
  const factory _TeamInfo(
      {final String id,
      final String name,
      final String countryCode,
      final String lastLoginTime}) = _$TeamInfoImpl;

  factory _TeamInfo.fromJson(Map<String, dynamic> json) =
      _$TeamInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get countryCode;
  @override
  String get lastLoginTime;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return _DeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfo {
  String get id => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  String get udid => throw _privateConstructorUsedError;
  int get deviceType => throw _privateConstructorUsedError;
  String get createTime => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
          DeviceInfo value, $Res Function(DeviceInfo) then) =
      _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call(
      {String id,
      String deviceName,
      String udid,
      int deviceType,
      String createTime,
      int status});
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceName = null,
    Object? udid = null,
    Object? deviceType = null,
    Object? createTime = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      udid: null == udid
          ? _value.udid
          : udid // ignore: cast_nullable_to_non_nullable
              as String,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
          _$DeviceInfoImpl value, $Res Function(_$DeviceInfoImpl) then) =
      __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String deviceName,
      String udid,
      int deviceType,
      String createTime,
      int status});
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
      _$DeviceInfoImpl _value, $Res Function(_$DeviceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceName = null,
    Object? udid = null,
    Object? deviceType = null,
    Object? createTime = null,
    Object? status = null,
  }) {
    return _then(_$DeviceInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      udid: null == udid
          ? _value.udid
          : udid // ignore: cast_nullable_to_non_nullable
              as String,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoImpl with DiagnosticableTreeMixin implements _DeviceInfo {
  const _$DeviceInfoImpl(
      {this.id = "",
      this.deviceName = "",
      this.udid = "",
      this.deviceType = 0,
      this.createTime = "",
      this.status = 0});

  factory _$DeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String deviceName;
  @override
  @JsonKey()
  final String udid;
  @override
  @JsonKey()
  final int deviceType;
  @override
  @JsonKey()
  final String createTime;
  @override
  @JsonKey()
  final int status;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DeviceInfo(id: $id, deviceName: $deviceName, udid: $udid, deviceType: $deviceType, createTime: $createTime, status: $status)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DeviceInfo'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('deviceName', deviceName))
      ..add(DiagnosticsProperty('udid', udid))
      ..add(DiagnosticsProperty('deviceType', deviceType))
      ..add(DiagnosticsProperty('createTime', createTime))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.udid, udid) || other.udid == udid) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, deviceName, udid, deviceType, createTime, status);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfo implements DeviceInfo {
  const factory _DeviceInfo(
      {final String id,
      final String deviceName,
      final String udid,
      final int deviceType,
      final String createTime,
      final int status}) = _$DeviceInfoImpl;

  factory _DeviceInfo.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceName;
  @override
  String get udid;
  @override
  int get deviceType;
  @override
  String get createTime;
  @override
  int get status;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CertInfo _$CertInfoFromJson(Map<String, dynamic> json) {
  return _CertInfo.fromJson(json);
}

/// @nodoc
mixin _$CertInfo {
  String get id => throw _privateConstructorUsedError;
  String get certName => throw _privateConstructorUsedError;
  String get certObjectId => throw _privateConstructorUsedError;
  String get publicKeySha256 => throw _privateConstructorUsedError;
  int get certType => throw _privateConstructorUsedError;
  int get expireTime => throw _privateConstructorUsedError;
  int get createTime => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;

  /// Serializes this CertInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CertInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertInfoCopyWith<CertInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertInfoCopyWith<$Res> {
  factory $CertInfoCopyWith(CertInfo value, $Res Function(CertInfo) then) =
      _$CertInfoCopyWithImpl<$Res, CertInfo>;
  @useResult
  $Res call(
      {String id,
      String certName,
      String certObjectId,
      String publicKeySha256,
      int certType,
      int expireTime,
      int createTime,
      int status});
}

/// @nodoc
class _$CertInfoCopyWithImpl<$Res, $Val extends CertInfo>
    implements $CertInfoCopyWith<$Res> {
  _$CertInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CertInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? certName = null,
    Object? certObjectId = null,
    Object? publicKeySha256 = null,
    Object? certType = null,
    Object? expireTime = null,
    Object? createTime = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      certName: null == certName
          ? _value.certName
          : certName // ignore: cast_nullable_to_non_nullable
              as String,
      certObjectId: null == certObjectId
          ? _value.certObjectId
          : certObjectId // ignore: cast_nullable_to_non_nullable
              as String,
      publicKeySha256: null == publicKeySha256
          ? _value.publicKeySha256
          : publicKeySha256 // ignore: cast_nullable_to_non_nullable
              as String,
      certType: null == certType
          ? _value.certType
          : certType // ignore: cast_nullable_to_non_nullable
              as int,
      expireTime: null == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertInfoImplCopyWith<$Res>
    implements $CertInfoCopyWith<$Res> {
  factory _$$CertInfoImplCopyWith(
          _$CertInfoImpl value, $Res Function(_$CertInfoImpl) then) =
      __$$CertInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String certName,
      String certObjectId,
      String publicKeySha256,
      int certType,
      int expireTime,
      int createTime,
      int status});
}

/// @nodoc
class __$$CertInfoImplCopyWithImpl<$Res>
    extends _$CertInfoCopyWithImpl<$Res, _$CertInfoImpl>
    implements _$$CertInfoImplCopyWith<$Res> {
  __$$CertInfoImplCopyWithImpl(
      _$CertInfoImpl _value, $Res Function(_$CertInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CertInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? certName = null,
    Object? certObjectId = null,
    Object? publicKeySha256 = null,
    Object? certType = null,
    Object? expireTime = null,
    Object? createTime = null,
    Object? status = null,
  }) {
    return _then(_$CertInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      certName: null == certName
          ? _value.certName
          : certName // ignore: cast_nullable_to_non_nullable
              as String,
      certObjectId: null == certObjectId
          ? _value.certObjectId
          : certObjectId // ignore: cast_nullable_to_non_nullable
              as String,
      publicKeySha256: null == publicKeySha256
          ? _value.publicKeySha256
          : publicKeySha256 // ignore: cast_nullable_to_non_nullable
              as String,
      certType: null == certType
          ? _value.certType
          : certType // ignore: cast_nullable_to_non_nullable
              as int,
      expireTime: null == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertInfoImpl with DiagnosticableTreeMixin implements _CertInfo {
  const _$CertInfoImpl(
      {this.id = "",
      this.certName = "",
      this.certObjectId = "",
      this.publicKeySha256 = "",
      this.certType = 0,
      this.expireTime = 0,
      this.createTime = 0,
      this.status = 0});

  factory _$CertInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertInfoImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String certName;
  @override
  @JsonKey()
  final String certObjectId;
  @override
  @JsonKey()
  final String publicKeySha256;
  @override
  @JsonKey()
  final int certType;
  @override
  @JsonKey()
  final int expireTime;
  @override
  @JsonKey()
  final int createTime;
  @override
  @JsonKey()
  final int status;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CertInfo(id: $id, certName: $certName, certObjectId: $certObjectId, publicKeySha256: $publicKeySha256, certType: $certType, expireTime: $expireTime, createTime: $createTime, status: $status)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CertInfo'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('certName', certName))
      ..add(DiagnosticsProperty('certObjectId', certObjectId))
      ..add(DiagnosticsProperty('publicKeySha256', publicKeySha256))
      ..add(DiagnosticsProperty('certType', certType))
      ..add(DiagnosticsProperty('expireTime', expireTime))
      ..add(DiagnosticsProperty('createTime', createTime))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.certName, certName) ||
                other.certName == certName) &&
            (identical(other.certObjectId, certObjectId) ||
                other.certObjectId == certObjectId) &&
            (identical(other.publicKeySha256, publicKeySha256) ||
                other.publicKeySha256 == publicKeySha256) &&
            (identical(other.certType, certType) ||
                other.certType == certType) &&
            (identical(other.expireTime, expireTime) ||
                other.expireTime == expireTime) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, certName, certObjectId,
      publicKeySha256, certType, expireTime, createTime, status);

  /// Create a copy of CertInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertInfoImplCopyWith<_$CertInfoImpl> get copyWith =>
      __$$CertInfoImplCopyWithImpl<_$CertInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertInfoImplToJson(
      this,
    );
  }
}

abstract class _CertInfo implements CertInfo {
  const factory _CertInfo(
      {final String id,
      final String certName,
      final String certObjectId,
      final String publicKeySha256,
      final int certType,
      final int expireTime,
      final int createTime,
      final int status}) = _$CertInfoImpl;

  factory _CertInfo.fromJson(Map<String, dynamic> json) =
      _$CertInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get certName;
  @override
  String get certObjectId;
  @override
  String get publicKeySha256;
  @override
  int get certType;
  @override
  int get expireTime;
  @override
  int get createTime;
  @override
  int get status;

  /// Create a copy of CertInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertInfoImplCopyWith<_$CertInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileInfo _$ProfileInfoFromJson(Map<String, dynamic> json) {
  return _ProfileInfo.fromJson(json);
}

/// @nodoc
mixin _$ProfileInfo {
  String get id => throw _privateConstructorUsedError;
  String get provisionFileUrl => throw _privateConstructorUsedError;

  /// Serializes this ProfileInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileInfoCopyWith<ProfileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileInfoCopyWith<$Res> {
  factory $ProfileInfoCopyWith(
          ProfileInfo value, $Res Function(ProfileInfo) then) =
      _$ProfileInfoCopyWithImpl<$Res, ProfileInfo>;
  @useResult
  $Res call({String id, String provisionFileUrl});
}

/// @nodoc
class _$ProfileInfoCopyWithImpl<$Res, $Val extends ProfileInfo>
    implements $ProfileInfoCopyWith<$Res> {
  _$ProfileInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provisionFileUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provisionFileUrl: null == provisionFileUrl
          ? _value.provisionFileUrl
          : provisionFileUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileInfoImplCopyWith<$Res>
    implements $ProfileInfoCopyWith<$Res> {
  factory _$$ProfileInfoImplCopyWith(
          _$ProfileInfoImpl value, $Res Function(_$ProfileInfoImpl) then) =
      __$$ProfileInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String provisionFileUrl});
}

/// @nodoc
class __$$ProfileInfoImplCopyWithImpl<$Res>
    extends _$ProfileInfoCopyWithImpl<$Res, _$ProfileInfoImpl>
    implements _$$ProfileInfoImplCopyWith<$Res> {
  __$$ProfileInfoImplCopyWithImpl(
      _$ProfileInfoImpl _value, $Res Function(_$ProfileInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provisionFileUrl = null,
  }) {
    return _then(_$ProfileInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provisionFileUrl: null == provisionFileUrl
          ? _value.provisionFileUrl
          : provisionFileUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileInfoImpl with DiagnosticableTreeMixin implements _ProfileInfo {
  const _$ProfileInfoImpl({this.id = "", this.provisionFileUrl = ""});

  factory _$ProfileInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileInfoImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String provisionFileUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProfileInfo(id: $id, provisionFileUrl: $provisionFileUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProfileInfo'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('provisionFileUrl', provisionFileUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.provisionFileUrl, provisionFileUrl) ||
                other.provisionFileUrl == provisionFileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, provisionFileUrl);

  /// Create a copy of ProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileInfoImplCopyWith<_$ProfileInfoImpl> get copyWith =>
      __$$ProfileInfoImplCopyWithImpl<_$ProfileInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileInfoImplToJson(
      this,
    );
  }
}

abstract class _ProfileInfo implements ProfileInfo {
  const factory _ProfileInfo({final String id, final String provisionFileUrl}) =
      _$ProfileInfoImpl;

  factory _ProfileInfo.fromJson(Map<String, dynamic> json) =
      _$ProfileInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get provisionFileUrl;

  /// Create a copy of ProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileInfoImplCopyWith<_$ProfileInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
