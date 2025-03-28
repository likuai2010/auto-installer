// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../PayList.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayList {

 String get time; List<PayInfo> get payList;
/// Create a copy of PayList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayListCopyWith<PayList> get copyWith => _$PayListCopyWithImpl<PayList>(this as PayList, _$identity);

  /// Serializes this PayList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayList&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.payList, payList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,const DeepCollectionEquality().hash(payList));

@override
String toString() {
  return 'PayList(time: $time, payList: $payList)';
}


}

/// @nodoc
abstract mixin class $PayListCopyWith<$Res>  {
  factory $PayListCopyWith(PayList value, $Res Function(PayList) _then) = _$PayListCopyWithImpl;
@useResult
$Res call({
 String time, List<PayInfo> payList
});




}
/// @nodoc
class _$PayListCopyWithImpl<$Res>
    implements $PayListCopyWith<$Res> {
  _$PayListCopyWithImpl(this._self, this._then);

  final PayList _self;
  final $Res Function(PayList) _then;

/// Create a copy of PayList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? payList = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,payList: null == payList ? _self.payList : payList // ignore: cast_nullable_to_non_nullable
as List<PayInfo>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PayList implements PayList {
  const _PayList({this.time = "", final  List<PayInfo> payList = const []}): _payList = payList;
  factory _PayList.fromJson(Map<String, dynamic> json) => _$PayListFromJson(json);

@override@JsonKey() final  String time;
 final  List<PayInfo> _payList;
@override@JsonKey() List<PayInfo> get payList {
  if (_payList is EqualUnmodifiableListView) return _payList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payList);
}


/// Create a copy of PayList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayListCopyWith<_PayList> get copyWith => __$PayListCopyWithImpl<_PayList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayList&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other._payList, _payList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,const DeepCollectionEquality().hash(_payList));

@override
String toString() {
  return 'PayList(time: $time, payList: $payList)';
}


}

/// @nodoc
abstract mixin class _$PayListCopyWith<$Res> implements $PayListCopyWith<$Res> {
  factory _$PayListCopyWith(_PayList value, $Res Function(_PayList) _then) = __$PayListCopyWithImpl;
@override @useResult
$Res call({
 String time, List<PayInfo> payList
});




}
/// @nodoc
class __$PayListCopyWithImpl<$Res>
    implements _$PayListCopyWith<$Res> {
  __$PayListCopyWithImpl(this._self, this._then);

  final _PayList _self;
  final $Res Function(_PayList) _then;

/// Create a copy of PayList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? payList = null,}) {
  return _then(_PayList(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,payList: null == payList ? _self._payList : payList // ignore: cast_nullable_to_non_nullable
as List<PayInfo>,
  ));
}


}


/// @nodoc
mixin _$PayInfo {

 String get nick; String get amount;
/// Create a copy of PayInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayInfoCopyWith<PayInfo> get copyWith => _$PayInfoCopyWithImpl<PayInfo>(this as PayInfo, _$identity);

  /// Serializes this PayInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayInfo&&(identical(other.nick, nick) || other.nick == nick)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nick,amount);

@override
String toString() {
  return 'PayInfo(nick: $nick, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PayInfoCopyWith<$Res>  {
  factory $PayInfoCopyWith(PayInfo value, $Res Function(PayInfo) _then) = _$PayInfoCopyWithImpl;
@useResult
$Res call({
 String nick, String amount
});




}
/// @nodoc
class _$PayInfoCopyWithImpl<$Res>
    implements $PayInfoCopyWith<$Res> {
  _$PayInfoCopyWithImpl(this._self, this._then);

  final PayInfo _self;
  final $Res Function(PayInfo) _then;

/// Create a copy of PayInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nick = null,Object? amount = null,}) {
  return _then(_self.copyWith(
nick: null == nick ? _self.nick : nick // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PayInfo implements PayInfo {
  const _PayInfo({this.nick = "", this.amount = ""});
  factory _PayInfo.fromJson(Map<String, dynamic> json) => _$PayInfoFromJson(json);

@override@JsonKey() final  String nick;
@override@JsonKey() final  String amount;

/// Create a copy of PayInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayInfoCopyWith<_PayInfo> get copyWith => __$PayInfoCopyWithImpl<_PayInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayInfo&&(identical(other.nick, nick) || other.nick == nick)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nick,amount);

@override
String toString() {
  return 'PayInfo(nick: $nick, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$PayInfoCopyWith<$Res> implements $PayInfoCopyWith<$Res> {
  factory _$PayInfoCopyWith(_PayInfo value, $Res Function(_PayInfo) _then) = __$PayInfoCopyWithImpl;
@override @useResult
$Res call({
 String nick, String amount
});




}
/// @nodoc
class __$PayInfoCopyWithImpl<$Res>
    implements _$PayInfoCopyWith<$Res> {
  __$PayInfoCopyWithImpl(this._self, this._then);

  final _PayInfo _self;
  final $Res Function(_PayInfo) _then;

/// Create a copy of PayInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nick = null,Object? amount = null,}) {
  return _then(_PayInfo(
nick: null == nick ? _self.nick : nick // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
