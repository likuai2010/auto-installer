import 'package:hap_installer/models/EcoResult.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/AuthInfo.g.dart';

@JsonSerializable()
class AuthInfo {
  String? accessToken;
  String? userId;
  String? teamId;
  String? nickName;
  AuthInfo({required this.accessToken, required this.userId}) : teamId = userId;
  
  changeTeamId(TeamInfo team) {
    teamId = team.id;
  }

  factory AuthInfo.fromJson(Map<String, dynamic> json) =>
      _$AuthInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthInfoToJson(this);
}
