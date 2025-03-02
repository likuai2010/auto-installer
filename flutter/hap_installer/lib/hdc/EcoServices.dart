import 'dart:io';
import 'dart:convert';

class EcoService {
  var aclList = [
    "ohos.permission.READ_AUDIO",
    "ohos.permission.WRITE_AUDIO",
    "ohos.permission.READ_IMAGEVIDEO",
    "ohos.permission.WRITE_IMAGEVIDEO",
    "ohos.permission.SHORT_TERM_WRITE_IMAGEVIDEO",
    "ohos.permission.READ_CONTACTS",
    "ohos.permission.WRITE_CONTACTS",
    "ohos.permission.SYSTEM_FLOAT_WINDOW",
    "ohos.permission.ACCESS_DDK_USB",
    "ohos.permission.ACCESS_DDK_HID",
    "ohos.permission.INPUT_MONITORING",
    "ohos.permission.INTERCEPT_INPUT_EVENT",
    "ohos.permission.READ_PASTEBOARD",
  ];
  var oauth2Token = "";
  var teamId = "";
  var uid = "";
  Future<String?> baseRequest(
    String url,
    Map data,
    Map<String, String>? headers, [
    String method = 'Post',
  ]) async {
    var httpClient = HttpClient();
    try {
      var uri = Uri.parse(url);
      var request = await httpClient.openUrl(method, uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set("oauth2Token", oauth2Token);
      request.headers.set("teamId", teamId);
      request.headers.set("uid", uid);
      if (headers != null) {
        for (var key in headers.keys) {
          request.headers.set(key, headers[key] ?? "");
        }
      }
      request.add(utf8.encode(jsonEncode(data)));

      var response = await request.close();
      if (response.statusCode == 200) {
        var jsonResponse = await response.transform(utf8.decoder).join();
        try {
          jsonDecode(jsonResponse);
        } catch (e) {}
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception("登陆失效");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  deviceList() {
    var uri =
        "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/list?start=1&pageSize=100&encodeFlag=0";
    return baseRequest(uri, {}, {}, "GET");
  }
}
