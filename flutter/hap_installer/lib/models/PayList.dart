
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/PayList.freezed.dart';
part 'generated/PayList.g.dart';

@freezed
abstract class PayList with _$PayList {
  const factory PayList({
    @Default("") String time,
    @Default([]) List<PayInfo> payList,
  }) = _PayList;
  factory PayList.fromJson(Map<String, dynamic> json) =>
      _$PayListFromJson(json);
}


@freezed
abstract class PayInfo with _$PayInfo {
  const factory PayInfo({
    @Default("") String nick,
    @Default("") String amount,
  }) = _PayInfo;
  factory PayInfo.fromJson(Map<String, dynamic> json) =>
      _$PayInfoFromJson(json);
}
