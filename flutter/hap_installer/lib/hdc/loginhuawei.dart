import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ohos_adapter/ohos_adapter.dart';

const String EcoUrl =
    "https://cn.devecostudio.huawei.com/console/DevEcoIDE/apply?port=8888&appid=1007&code=20698961dd4f420c8b44f49010c6f0cc";

class LoginHuawei {
  int port;
  LoginHuawei() : port = 3333 + Random().nextInt(1000);

  Future<void> openUrl() async {
    if (await ohosAdapter.isOhos()) {
      ohosAdapter.openUrl(EcoUrl.replaceAll("8888", "$port"));
    }
    if (Platform.isAndroid) {
      await launchUrl(
        Uri.parse(EcoUrl.replaceAll("8888", "$port")),
        mode: LaunchMode.externalApplication,
      );
    } else {
      await launchUrl(Uri.parse(EcoUrl.replaceAll("8888", "$port")));
    }
  }

  Future<AuthInfo?> getAuthInfo() async {
    AuthInfo? authInfo;
    return Isolate.run(() async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await for (var request in server) {
        if (request.uri.path == '/callback') {
          final content = await utf8.decoder.bind(request).join();
          var message = '登录成功！请返回!';
          try {
            authInfo = await eco.getAuthInfoBytempToken(content);
          } catch (e) {
            message = "登录失败!, $e";
          }
          request.response
            ..statusCode = HttpStatus.ok
            ..write(message)
            ..close();
          break;
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('404 Not Found ${request.uri.path}')
            ..close();
        }
      }
      return authInfo;
    });
  }
}
