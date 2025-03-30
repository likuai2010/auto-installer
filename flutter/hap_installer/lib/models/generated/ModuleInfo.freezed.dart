// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../ModuleInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppInfo _$AppInfoFromJson(Map<String, dynamic> json) {
  return _AppInfo.fromJson(json);
}

/// @nodoc
mixin _$AppInfo {
  String get bundleName => throw _privateConstructorUsedError;
  String get compileSdkVersion => throw _privateConstructorUsedError;
  String get versionName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppInfoCopyWith<AppInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInfoCopyWith<$Res> {
  factory $AppInfoCopyWith(AppInfo value, $Res Function(AppInfo) then) =
      _$AppInfoCopyWithImpl<$Res, AppInfo>;
  @useResult
  $Res call({String bundleName, String compileSdkVersion, String versionName});
}

/// @nodoc
class _$AppInfoCopyWithImpl<$Res, $Val extends AppInfo>
    implements $AppInfoCopyWith<$Res> {
  _$AppInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bundleName = null,
    Object? compileSdkVersion = null,
    Object? versionName = null,
  }) {
    return _then(_value.copyWith(
      bundleName: null == bundleName
          ? _value.bundleName
          : bundleName // ignore: cast_nullable_to_non_nullable
              as String,
      compileSdkVersion: null == compileSdkVersion
          ? _value.compileSdkVersion
          : compileSdkVersion // ignore: cast_nullable_to_non_nullable
              as String,
      versionName: null == versionName
          ? _value.versionName
          : versionName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppInfoImplCopyWith<$Res> implements $AppInfoCopyWith<$Res> {
  factory _$$AppInfoImplCopyWith(
          _$AppInfoImpl value, $Res Function(_$AppInfoImpl) then) =
      __$$AppInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String bundleName, String compileSdkVersion, String versionName});
}

/// @nodoc
class __$$AppInfoImplCopyWithImpl<$Res>
    extends _$AppInfoCopyWithImpl<$Res, _$AppInfoImpl>
    implements _$$AppInfoImplCopyWith<$Res> {
  __$$AppInfoImplCopyWithImpl(
      _$AppInfoImpl _value, $Res Function(_$AppInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bundleName = null,
    Object? compileSdkVersion = null,
    Object? versionName = null,
  }) {
    return _then(_$AppInfoImpl(
      bundleName: null == bundleName
          ? _value.bundleName
          : bundleName // ignore: cast_nullable_to_non_nullable
              as String,
      compileSdkVersion: null == compileSdkVersion
          ? _value.compileSdkVersion
          : compileSdkVersion // ignore: cast_nullable_to_non_nullable
              as String,
      versionName: null == versionName
          ? _value.versionName
          : versionName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppInfoImpl with DiagnosticableTreeMixin implements _AppInfo {
  const _$AppInfoImpl(
      {this.bundleName = "",
      this.compileSdkVersion = "",
      this.versionName = ""});

  factory _$AppInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppInfoImplFromJson(json);

  @override
  @JsonKey()
  final String bundleName;
  @override
  @JsonKey()
  final String compileSdkVersion;
  @override
  @JsonKey()
  final String versionName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppInfo(bundleName: $bundleName, compileSdkVersion: $compileSdkVersion, versionName: $versionName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppInfo'))
      ..add(DiagnosticsProperty('bundleName', bundleName))
      ..add(DiagnosticsProperty('compileSdkVersion', compileSdkVersion))
      ..add(DiagnosticsProperty('versionName', versionName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppInfoImpl &&
            (identical(other.bundleName, bundleName) ||
                other.bundleName == bundleName) &&
            (identical(other.compileSdkVersion, compileSdkVersion) ||
                other.compileSdkVersion == compileSdkVersion) &&
            (identical(other.versionName, versionName) ||
                other.versionName == versionName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, bundleName, compileSdkVersion, versionName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppInfoImplCopyWith<_$AppInfoImpl> get copyWith =>
      __$$AppInfoImplCopyWithImpl<_$AppInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppInfoImplToJson(
      this,
    );
  }
}

abstract class _AppInfo implements AppInfo {
  const factory _AppInfo(
      {final String bundleName,
      final String compileSdkVersion,
      final String versionName}) = _$AppInfoImpl;

  factory _AppInfo.fromJson(Map<String, dynamic> json) = _$AppInfoImpl.fromJson;

  @override
  String get bundleName;
  @override
  String get compileSdkVersion;
  @override
  String get versionName;
  @override
  @JsonKey(ignore: true)
  _$$AppInfoImplCopyWith<_$AppInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RequestPermission _$RequestPermissionFromJson(Map<String, dynamic> json) {
  return _RequestPermission.fromJson(json);
}

/// @nodoc
mixin _$RequestPermission {
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestPermissionCopyWith<RequestPermission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestPermissionCopyWith<$Res> {
  factory $RequestPermissionCopyWith(
          RequestPermission value, $Res Function(RequestPermission) then) =
      _$RequestPermissionCopyWithImpl<$Res, RequestPermission>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$RequestPermissionCopyWithImpl<$Res, $Val extends RequestPermission>
    implements $RequestPermissionCopyWith<$Res> {
  _$RequestPermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestPermissionImplCopyWith<$Res>
    implements $RequestPermissionCopyWith<$Res> {
  factory _$$RequestPermissionImplCopyWith(_$RequestPermissionImpl value,
          $Res Function(_$RequestPermissionImpl) then) =
      __$$RequestPermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$RequestPermissionImplCopyWithImpl<$Res>
    extends _$RequestPermissionCopyWithImpl<$Res, _$RequestPermissionImpl>
    implements _$$RequestPermissionImplCopyWith<$Res> {
  __$$RequestPermissionImplCopyWithImpl(_$RequestPermissionImpl _value,
      $Res Function(_$RequestPermissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$RequestPermissionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestPermissionImpl
    with DiagnosticableTreeMixin
    implements _RequestPermission {
  const _$RequestPermissionImpl({this.name = ""});

  factory _$RequestPermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestPermissionImplFromJson(json);

  @override
  @JsonKey()
  final String name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RequestPermission(name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RequestPermission'))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestPermissionImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestPermissionImplCopyWith<_$RequestPermissionImpl> get copyWith =>
      __$$RequestPermissionImplCopyWithImpl<_$RequestPermissionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestPermissionImplToJson(
      this,
    );
  }
}

abstract class _RequestPermission implements RequestPermission {
  const factory _RequestPermission({final String name}) =
      _$RequestPermissionImpl;

  factory _RequestPermission.fromJson(Map<String, dynamic> json) =
      _$RequestPermissionImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$RequestPermissionImplCopyWith<_$RequestPermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Module _$ModuleFromJson(Map<String, dynamic> json) {
  return _Module.fromJson(json);
}

/// @nodoc
mixin _$Module {
  List<RequestPermission> get requestPermissions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModuleCopyWith<Module> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleCopyWith<$Res> {
  factory $ModuleCopyWith(Module value, $Res Function(Module) then) =
      _$ModuleCopyWithImpl<$Res, Module>;
  @useResult
  $Res call({List<RequestPermission> requestPermissions});
}

/// @nodoc
class _$ModuleCopyWithImpl<$Res, $Val extends Module>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestPermissions = null,
  }) {
    return _then(_value.copyWith(
      requestPermissions: null == requestPermissions
          ? _value.requestPermissions
          : requestPermissions // ignore: cast_nullable_to_non_nullable
              as List<RequestPermission>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleImplCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$$ModuleImplCopyWith(
          _$ModuleImpl value, $Res Function(_$ModuleImpl) then) =
      __$$ModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RequestPermission> requestPermissions});
}

/// @nodoc
class __$$ModuleImplCopyWithImpl<$Res>
    extends _$ModuleCopyWithImpl<$Res, _$ModuleImpl>
    implements _$$ModuleImplCopyWith<$Res> {
  __$$ModuleImplCopyWithImpl(
      _$ModuleImpl _value, $Res Function(_$ModuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestPermissions = null,
  }) {
    return _then(_$ModuleImpl(
      requestPermissions: null == requestPermissions
          ? _value._requestPermissions
          : requestPermissions // ignore: cast_nullable_to_non_nullable
              as List<RequestPermission>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleImpl with DiagnosticableTreeMixin implements _Module {
  const _$ModuleImpl(
      {final List<RequestPermission> requestPermissions = const []})
      : _requestPermissions = requestPermissions;

  factory _$ModuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleImplFromJson(json);

  final List<RequestPermission> _requestPermissions;
  @override
  @JsonKey()
  List<RequestPermission> get requestPermissions {
    if (_requestPermissions is EqualUnmodifiableListView)
      return _requestPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestPermissions);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Module(requestPermissions: $requestPermissions)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Module'))
      ..add(DiagnosticsProperty('requestPermissions', requestPermissions));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleImpl &&
            const DeepCollectionEquality()
                .equals(other._requestPermissions, _requestPermissions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_requestPermissions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      __$$ModuleImplCopyWithImpl<_$ModuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleImplToJson(
      this,
    );
  }
}

abstract class _Module implements Module {
  const factory _Module({final List<RequestPermission> requestPermissions}) =
      _$ModuleImpl;

  factory _Module.fromJson(Map<String, dynamic> json) = _$ModuleImpl.fromJson;

  @override
  List<RequestPermission> get requestPermissions;
  @override
  @JsonKey(ignore: true)
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModuleInfo _$ModuleInfoFromJson(Map<String, dynamic> json) {
  return _ModuleInfo.fromJson(json);
}

/// @nodoc
mixin _$ModuleInfo {
  AppInfo? get app => throw _privateConstructorUsedError;
  Module? get module => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModuleInfoCopyWith<ModuleInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleInfoCopyWith<$Res> {
  factory $ModuleInfoCopyWith(
          ModuleInfo value, $Res Function(ModuleInfo) then) =
      _$ModuleInfoCopyWithImpl<$Res, ModuleInfo>;
  @useResult
  $Res call({AppInfo? app, Module? module});

  $AppInfoCopyWith<$Res>? get app;
  $ModuleCopyWith<$Res>? get module;
}

/// @nodoc
class _$ModuleInfoCopyWithImpl<$Res, $Val extends ModuleInfo>
    implements $ModuleInfoCopyWith<$Res> {
  _$ModuleInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = freezed,
    Object? module = freezed,
  }) {
    return _then(_value.copyWith(
      app: freezed == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as AppInfo?,
      module: freezed == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as Module?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppInfoCopyWith<$Res>? get app {
    if (_value.app == null) {
      return null;
    }

    return $AppInfoCopyWith<$Res>(_value.app!, (value) {
      return _then(_value.copyWith(app: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ModuleCopyWith<$Res>? get module {
    if (_value.module == null) {
      return null;
    }

    return $ModuleCopyWith<$Res>(_value.module!, (value) {
      return _then(_value.copyWith(module: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ModuleInfoImplCopyWith<$Res>
    implements $ModuleInfoCopyWith<$Res> {
  factory _$$ModuleInfoImplCopyWith(
          _$ModuleInfoImpl value, $Res Function(_$ModuleInfoImpl) then) =
      __$$ModuleInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppInfo? app, Module? module});

  @override
  $AppInfoCopyWith<$Res>? get app;
  @override
  $ModuleCopyWith<$Res>? get module;
}

/// @nodoc
class __$$ModuleInfoImplCopyWithImpl<$Res>
    extends _$ModuleInfoCopyWithImpl<$Res, _$ModuleInfoImpl>
    implements _$$ModuleInfoImplCopyWith<$Res> {
  __$$ModuleInfoImplCopyWithImpl(
      _$ModuleInfoImpl _value, $Res Function(_$ModuleInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = freezed,
    Object? module = freezed,
  }) {
    return _then(_$ModuleInfoImpl(
      app: freezed == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as AppInfo?,
      module: freezed == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as Module?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleInfoImpl with DiagnosticableTreeMixin implements _ModuleInfo {
  const _$ModuleInfoImpl({this.app = null, this.module = null});

  factory _$ModuleInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleInfoImplFromJson(json);

  @override
  @JsonKey()
  final AppInfo? app;
  @override
  @JsonKey()
  final Module? module;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ModuleInfo(app: $app, module: $module)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ModuleInfo'))
      ..add(DiagnosticsProperty('app', app))
      ..add(DiagnosticsProperty('module', module));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleInfoImpl &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.module, module) || other.module == module));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, app, module);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleInfoImplCopyWith<_$ModuleInfoImpl> get copyWith =>
      __$$ModuleInfoImplCopyWithImpl<_$ModuleInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleInfoImplToJson(
      this,
    );
  }
}

abstract class _ModuleInfo implements ModuleInfo {
  const factory _ModuleInfo({final AppInfo? app, final Module? module}) =
      _$ModuleInfoImpl;

  factory _ModuleInfo.fromJson(Map<String, dynamic> json) =
      _$ModuleInfoImpl.fromJson;

  @override
  AppInfo? get app;
  @override
  Module? get module;
  @override
  @JsonKey(ignore: true)
  _$$ModuleInfoImplCopyWith<_$ModuleInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
