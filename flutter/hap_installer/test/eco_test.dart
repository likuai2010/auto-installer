import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hap_installer/hdc/EcoServices.dart';

import 'package:hap_installer/main.dart';
import 'package:hap_installer/models/AuthInfo.dart';

void main() {
  final TestAuthInfo = AuthInfo(
    accessToken:
        "DQEAAB4tlg8XuZnEv3WNZcIUwo2d1qWqY0QVlJDLCX7giARNHjxnsGbHGyzLYi1UpP9F5HaApC80JRKnC+t8WBVJIB1aVwn4e0l6D/aymI2chSz4dZb3iH6okAYqVQ1hrQ==",
    userId: "2850086000506643987",
  );
  group("test eco services", () {
    final eco = EcoService();
    test("test base", () async {
      eco.initUserInfo(TestAuthInfo);
      final deviceList = await eco.deviceList();
      print("deviceList:" + deviceList.toString());
      final teams = await eco.getUserTeamList();
      print("getUserTeamList:" + teams.toString());
      final result = await eco.getCertList();
      print("getCertList:" + result.toString());
    });
  });
}
