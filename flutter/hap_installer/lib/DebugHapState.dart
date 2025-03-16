import 'package:flutter/material.dart';

class SetpInfo {
  SetpInfo({required this.name, this.loading, this.error});
  final String name;
  String? error;
  bool? loading;
}

class DebughapState extends ChangeNotifier {
    SetpInfo deviceInfo = SetpInfo(name: "连接状态检查");
    SetpInfo loginInfo = SetpInfo(name: "登录状态检查");
    SetpInfo signInfo = SetpInfo(name: "签名应用");
    SetpInfo installInfo = SetpInfo(name: "签名应用");

}