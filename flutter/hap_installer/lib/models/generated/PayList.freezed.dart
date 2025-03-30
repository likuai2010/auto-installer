// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../PayList.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayList _$PayListFromJson(Map<String, dynamic> json) {
  return _PayList.fromJson(json);
}

/// @nodoc
mixin _$PayList {
  String get time => throw _privateConstructorUsedError;
  List<PayInfo> get payList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PayListCopyWith<PayList> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayListCopyWith<$Res> {
  factory $PayListCopyWith(PayList value, $Res Function(PayList) then) =
      _$PayListCopyWithImpl<$Res, PayList>;
  @useResult
  $Res call({String time, List<PayInfo> payList});
}

/// @nodoc
class _$PayListCopyWithImpl<$Res, $Val extends PayList>
    implements $PayListCopyWith<$Res> {
  _$PayListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
              as List<PayInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayListImplCopyWith<$Res> implements $PayListCopyWith<$Res> {
  factory _$$PayListImplCopyWith(
          _$PayListImpl value, $Res Function(_$PayListImpl) then) =
      __$$PayListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String time, List<PayInfo> payList});
}

/// @nodoc
class __$$PayListImplCopyWithImpl<$Res>
    extends _$PayListCopyWithImpl<$Res, _$PayListImpl>
    implements _$$PayListImplCopyWith<$Res> {
  __$$PayListImplCopyWithImpl(
      _$PayListImpl _value, $Res Function(_$PayListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? payList = null,
  }) {
    return _then(_$PayListImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      payList: null == payList
          ? _value._payList
          : payList // ignore: cast_nullable_to_non_nullable
              as List<PayInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayListImpl implements _PayList {
  const _$PayListImpl({this.time = "", final List<PayInfo> payList = const []})
      : _payList = payList;

  factory _$PayListImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayListImplFromJson(json);

  @override
  @JsonKey()
  final String time;
  final List<PayInfo> _payList;
  @override
  @JsonKey()
  List<PayInfo> get payList {
    if (_payList is EqualUnmodifiableListView) return _payList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payList);
  }

  @override
  String toString() {
    return 'PayList(time: $time, payList: $payList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayListImpl &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality().equals(other._payList, _payList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, time, const DeepCollectionEquality().hash(_payList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayListImplCopyWith<_$PayListImpl> get copyWith =>
      __$$PayListImplCopyWithImpl<_$PayListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayListImplToJson(
      this,
    );
  }
}

abstract class _PayList implements PayList {
  const factory _PayList({final String time, final List<PayInfo> payList}) =
      _$PayListImpl;

  factory _PayList.fromJson(Map<String, dynamic> json) = _$PayListImpl.fromJson;

  @override
  String get time;
  @override
  List<PayInfo> get payList;
  @override
  @JsonKey(ignore: true)
  _$$PayListImplCopyWith<_$PayListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PayInfo _$PayInfoFromJson(Map<String, dynamic> json) {
  return _PayInfo.fromJson(json);
}

/// @nodoc
mixin _$PayInfo {
  String get nick => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PayInfoCopyWith<PayInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayInfoCopyWith<$Res> {
  factory $PayInfoCopyWith(PayInfo value, $Res Function(PayInfo) then) =
      _$PayInfoCopyWithImpl<$Res, PayInfo>;
  @useResult
  $Res call({String nick, String amount});
}

/// @nodoc
class _$PayInfoCopyWithImpl<$Res, $Val extends PayInfo>
    implements $PayInfoCopyWith<$Res> {
  _$PayInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayInfoImplCopyWith<$Res> implements $PayInfoCopyWith<$Res> {
  factory _$$PayInfoImplCopyWith(
          _$PayInfoImpl value, $Res Function(_$PayInfoImpl) then) =
      __$$PayInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nick, String amount});
}

/// @nodoc
class __$$PayInfoImplCopyWithImpl<$Res>
    extends _$PayInfoCopyWithImpl<$Res, _$PayInfoImpl>
    implements _$$PayInfoImplCopyWith<$Res> {
  __$$PayInfoImplCopyWithImpl(
      _$PayInfoImpl _value, $Res Function(_$PayInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = null,
    Object? amount = null,
  }) {
    return _then(_$PayInfoImpl(
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayInfoImpl implements _PayInfo {
  const _$PayInfoImpl({this.nick = "", this.amount = ""});

  factory _$PayInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayInfoImplFromJson(json);

  @override
  @JsonKey()
  final String nick;
  @override
  @JsonKey()
  final String amount;

  @override
  String toString() {
    return 'PayInfo(nick: $nick, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayInfoImpl &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nick, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayInfoImplCopyWith<_$PayInfoImpl> get copyWith =>
      __$$PayInfoImplCopyWithImpl<_$PayInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayInfoImplToJson(
      this,
    );
  }
}

abstract class _PayInfo implements PayInfo {
  const factory _PayInfo({final String nick, final String amount}) =
      _$PayInfoImpl;

  factory _PayInfo.fromJson(Map<String, dynamic> json) = _$PayInfoImpl.fromJson;

  @override
  String get nick;
  @override
  String get amount;
  @override
  @JsonKey(ignore: true)
  _$$PayInfoImplCopyWith<_$PayInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
