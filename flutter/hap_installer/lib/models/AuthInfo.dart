import 'package:hap_installer/models/EcoResult.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/AuthInfo.g.dart';

@JsonSerializable()
class AuthInfo {
  String? accessToken;
  String? userId;
  String? teamId;
  String? nickName;
  String? jwtToken;
  AuthInfo({required this.accessToken, required this.userId, this.jwtToken}) : teamId = userId;
  
  changeTeamId(TeamInfo team) {
    teamId = team.id;
  }
  setJwtToken(String jwt){
    jwtToken = jwt;
  }

  factory AuthInfo.fromJson(Map<String, dynamic> json) =>
      _$AuthInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthInfoToJson(this);
}
