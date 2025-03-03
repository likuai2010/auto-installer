// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../ModuleInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppInfo implements DiagnosticableTreeMixin {

 String get bundleName; String get compileSdkVersion; String get versionName;
/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInfoCopyWith<AppInfo> get copyWith => _$AppInfoCopyWithImpl<AppInfo>(this as AppInfo, _$identity);

  /// Serializes this AppInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppInfo'))
    ..add(DiagnosticsProperty('bundleName', bundleName))..add(DiagnosticsProperty('compileSdkVersion', compileSdkVersion))..add(DiagnosticsProperty('versionName', versionName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInfo&&(identical(other.bundleName, bundleName) || other.bundleName == bundleName)&&(identical(other.compileSdkVersion, compileSdkVersion) || other.compileSdkVersion == compileSdkVersion)&&(identical(other.versionName, versionName) || other.versionName == versionName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bundleName,compileSdkVersion,versionName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppInfo(bundleName: $bundleName, compileSdkVersion: $compileSdkVersion, versionName: $versionName)';
}


}

/// @nodoc
abstract mixin class $AppInfoCopyWith<$Res>  {
  factory $AppInfoCopyWith(AppInfo value, $Res Function(AppInfo) _then) = _$AppInfoCopyWithImpl;
@useResult
$Res call({
 String bundleName, String compileSdkVersion, String versionName
});




}
/// @nodoc
class _$AppInfoCopyWithImpl<$Res>
    implements $AppInfoCopyWith<$Res> {
  _$AppInfoCopyWithImpl(this._self, this._then);

  final AppInfo _self;
  final $Res Function(AppInfo) _then;

/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bundleName = null,Object? compileSdkVersion = null,Object? versionName = null,}) {
  return _then(_self.copyWith(
bundleName: null == bundleName ? _self.bundleName : bundleName // ignore: cast_nullable_to_non_nullable
as String,compileSdkVersion: null == compileSdkVersion ? _self.compileSdkVersion : compileSdkVersion // ignore: cast_nullable_to_non_nullable
as String,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppInfo with DiagnosticableTreeMixin implements AppInfo {
  const _AppInfo({this.bundleName = "", this.compileSdkVersion = "", this.versionName = ""});
  factory _AppInfo.fromJson(Map<String, dynamic> json) => _$AppInfoFromJson(json);

@override@JsonKey() final  String bundleName;
@override@JsonKey() final  String compileSdkVersion;
@override@JsonKey() final  String versionName;

/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInfoCopyWith<_AppInfo> get copyWith => __$AppInfoCopyWithImpl<_AppInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppInfo'))
    ..add(DiagnosticsProperty('bundleName', bundleName))..add(DiagnosticsProperty('compileSdkVersion', compileSdkVersion))..add(DiagnosticsProperty('versionName', versionName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInfo&&(identical(other.bundleName, bundleName) || other.bundleName == bundleName)&&(identical(other.compileSdkVersion, compileSdkVersion) || other.compileSdkVersion == compileSdkVersion)&&(identical(other.versionName, versionName) || other.versionName == versionName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bundleName,compileSdkVersion,versionName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppInfo(bundleName: $bundleName, compileSdkVersion: $compileSdkVersion, versionName: $versionName)';
}


}

/// @nodoc
abstract mixin class _$AppInfoCopyWith<$Res> implements $AppInfoCopyWith<$Res> {
  factory _$AppInfoCopyWith(_AppInfo value, $Res Function(_AppInfo) _then) = __$AppInfoCopyWithImpl;
@override @useResult
$Res call({
 String bundleName, String compileSdkVersion, String versionName
});




}
/// @nodoc
class __$AppInfoCopyWithImpl<$Res>
    implements _$AppInfoCopyWith<$Res> {
  __$AppInfoCopyWithImpl(this._self, this._then);

  final _AppInfo _self;
  final $Res Function(_AppInfo) _then;

/// Create a copy of AppInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bundleName = null,Object? compileSdkVersion = null,Object? versionName = null,}) {
  return _then(_AppInfo(
bundleName: null == bundleName ? _self.bundleName : bundleName // ignore: cast_nullable_to_non_nullable
as String,compileSdkVersion: null == compileSdkVersion ? _self.compileSdkVersion : compileSdkVersion // ignore: cast_nullable_to_non_nullable
as String,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RequestPermission implements DiagnosticableTreeMixin {

 String get name;
/// Create a copy of RequestPermission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestPermissionCopyWith<RequestPermission> get copyWith => _$RequestPermissionCopyWithImpl<RequestPermission>(this as RequestPermission, _$identity);

  /// Serializes this RequestPermission to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RequestPermission'))
    ..add(DiagnosticsProperty('name', name));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestPermission&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RequestPermission(name: $name)';
}


}

/// @nodoc
abstract mixin class $RequestPermissionCopyWith<$Res>  {
  factory $RequestPermissionCopyWith(RequestPermission value, $Res Function(RequestPermission) _then) = _$RequestPermissionCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$RequestPermissionCopyWithImpl<$Res>
    implements $RequestPermissionCopyWith<$Res> {
  _$RequestPermissionCopyWithImpl(this._self, this._then);

  final RequestPermission _self;
  final $Res Function(RequestPermission) _then;

/// Create a copy of RequestPermission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RequestPermission with DiagnosticableTreeMixin implements RequestPermission {
  const _RequestPermission({this.name = ""});
  factory _RequestPermission.fromJson(Map<String, dynamic> json) => _$RequestPermissionFromJson(json);

@override@JsonKey() final  String name;

/// Create a copy of RequestPermission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestPermissionCopyWith<_RequestPermission> get copyWith => __$RequestPermissionCopyWithImpl<_RequestPermission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestPermissionToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RequestPermission'))
    ..add(DiagnosticsProperty('name', name));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestPermission&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RequestPermission(name: $name)';
}


}

/// @nodoc
abstract mixin class _$RequestPermissionCopyWith<$Res> implements $RequestPermissionCopyWith<$Res> {
  factory _$RequestPermissionCopyWith(_RequestPermission value, $Res Function(_RequestPermission) _then) = __$RequestPermissionCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$RequestPermissionCopyWithImpl<$Res>
    implements _$RequestPermissionCopyWith<$Res> {
  __$RequestPermissionCopyWithImpl(this._self, this._then);

  final _RequestPermission _self;
  final $Res Function(_RequestPermission) _then;

/// Create a copy of RequestPermission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_RequestPermission(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Module implements DiagnosticableTreeMixin {

 List<RequestPermission> get requestPermissions;
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleCopyWith<Module> get copyWith => _$ModuleCopyWithImpl<Module>(this as Module, _$identity);

  /// Serializes this Module to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Module'))
    ..add(DiagnosticsProperty('requestPermissions', requestPermissions));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Module&&const DeepCollectionEquality().equals(other.requestPermissions, requestPermissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(requestPermissions));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Module(requestPermissions: $requestPermissions)';
}


}

/// @nodoc
abstract mixin class $ModuleCopyWith<$Res>  {
  factory $ModuleCopyWith(Module value, $Res Function(Module) _then) = _$ModuleCopyWithImpl;
@useResult
$Res call({
 List<RequestPermission> requestPermissions
});




}
/// @nodoc
class _$ModuleCopyWithImpl<$Res>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._self, this._then);

  final Module _self;
  final $Res Function(Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestPermissions = null,}) {
  return _then(_self.copyWith(
requestPermissions: null == requestPermissions ? _self.requestPermissions : requestPermissions // ignore: cast_nullable_to_non_nullable
as List<RequestPermission>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Module with DiagnosticableTreeMixin implements Module {
  const _Module({final  List<RequestPermission> requestPermissions = const []}): _requestPermissions = requestPermissions;
  factory _Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

 final  List<RequestPermission> _requestPermissions;
@override@JsonKey() List<RequestPermission> get requestPermissions {
  if (_requestPermissions is EqualUnmodifiableListView) return _requestPermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requestPermissions);
}


/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleCopyWith<_Module> get copyWith => __$ModuleCopyWithImpl<_Module>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModuleToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Module'))
    ..add(DiagnosticsProperty('requestPermissions', requestPermissions));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Module&&const DeepCollectionEquality().equals(other._requestPermissions, _requestPermissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requestPermissions));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Module(requestPermissions: $requestPermissions)';
}


}

/// @nodoc
abstract mixin class _$ModuleCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$ModuleCopyWith(_Module value, $Res Function(_Module) _then) = __$ModuleCopyWithImpl;
@override @useResult
$Res call({
 List<RequestPermission> requestPermissions
});




}
/// @nodoc
class __$ModuleCopyWithImpl<$Res>
    implements _$ModuleCopyWith<$Res> {
  __$ModuleCopyWithImpl(this._self, this._then);

  final _Module _self;
  final $Res Function(_Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestPermissions = null,}) {
  return _then(_Module(
requestPermissions: null == requestPermissions ? _self._requestPermissions : requestPermissions // ignore: cast_nullable_to_non_nullable
as List<RequestPermission>,
  ));
}


}


/// @nodoc
mixin _$ModuleInfo implements DiagnosticableTreeMixin {

 AppInfo? get app; Module? get module;
/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleInfoCopyWith<ModuleInfo> get copyWith => _$ModuleInfoCopyWithImpl<ModuleInfo>(this as ModuleInfo, _$identity);

  /// Serializes this ModuleInfo to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ModuleInfo'))
    ..add(DiagnosticsProperty('app', app))..add(DiagnosticsProperty('module', module));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleInfo&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ModuleInfo(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class $ModuleInfoCopyWith<$Res>  {
  factory $ModuleInfoCopyWith(ModuleInfo value, $Res Function(ModuleInfo) _then) = _$ModuleInfoCopyWithImpl;
@useResult
$Res call({
 AppInfo? app, Module? module
});


$AppInfoCopyWith<$Res>? get app;$ModuleCopyWith<$Res>? get module;

}
/// @nodoc
class _$ModuleInfoCopyWithImpl<$Res>
    implements $ModuleInfoCopyWith<$Res> {
  _$ModuleInfoCopyWithImpl(this._self, this._then);

  final ModuleInfo _self;
  final $Res Function(ModuleInfo) _then;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_self.copyWith(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as AppInfo?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as Module?,
  ));
}
/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppInfoCopyWith<$Res>? get app {
    if (_self.app == null) {
    return null;
  }

  return $AppInfoCopyWith<$Res>(_self.app!, (value) {
    return _then(_self.copyWith(app: value));
  });
}/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleCopyWith<$Res>? get module {
    if (_self.module == null) {
    return null;
  }

  return $ModuleCopyWith<$Res>(_self.module!, (value) {
    return _then(_self.copyWith(module: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ModuleInfo with DiagnosticableTreeMixin implements ModuleInfo {
  const _ModuleInfo({this.app = null, this.module = null});
  factory _ModuleInfo.fromJson(Map<String, dynamic> json) => _$ModuleInfoFromJson(json);

@override@JsonKey() final  AppInfo? app;
@override@JsonKey() final  Module? module;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleInfoCopyWith<_ModuleInfo> get copyWith => __$ModuleInfoCopyWithImpl<_ModuleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModuleInfoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ModuleInfo'))
    ..add(DiagnosticsProperty('app', app))..add(DiagnosticsProperty('module', module));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleInfo&&(identical(other.app, app) || other.app == app)&&(identical(other.module, module) || other.module == module));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,module);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ModuleInfo(app: $app, module: $module)';
}


}

/// @nodoc
abstract mixin class _$ModuleInfoCopyWith<$Res> implements $ModuleInfoCopyWith<$Res> {
  factory _$ModuleInfoCopyWith(_ModuleInfo value, $Res Function(_ModuleInfo) _then) = __$ModuleInfoCopyWithImpl;
@override @useResult
$Res call({
 AppInfo? app, Module? module
});


@override $AppInfoCopyWith<$Res>? get app;@override $ModuleCopyWith<$Res>? get module;

}
/// @nodoc
class __$ModuleInfoCopyWithImpl<$Res>
    implements _$ModuleInfoCopyWith<$Res> {
  __$ModuleInfoCopyWithImpl(this._self, this._then);

  final _ModuleInfo _self;
  final $Res Function(_ModuleInfo) _then;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = freezed,Object? module = freezed,}) {
  return _then(_ModuleInfo(
app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as AppInfo?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as Module?,
  ));
}

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppInfoCopyWith<$Res>? get app {
    if (_self.app == null) {
    return null;
  }

  return $AppInfoCopyWith<$Res>(_self.app!, (value) {
    return _then(_self.copyWith(app: value));
  });
}/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleCopyWith<$Res>? get module {
    if (_self.module == null) {
    return null;
  }

  return $ModuleCopyWith<$Res>(_self.module!, (value) {
    return _then(_self.copyWith(module: value));
  });
}
}

// dart format on
