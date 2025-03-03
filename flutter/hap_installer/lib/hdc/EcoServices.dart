import 'dart:io';
import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:hap_installer/models/AuthInfo.dart';



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
  AuthInfo? authInfo; 
  Future<String?> baseRequest(
    String url,
    Map data,
    Map<String, String>? headers, [
    String method = 'POST',
  ]) async {
    var httpClient = HttpClient();
    try {
      final uri = Uri.parse(url);
      final request = await httpClient.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set("oauth2Token", authInfo?.accessToken ?? "");
      request.headers.set("teamId", authInfo?.teamId ?? authInfo?.teamId ?? "");
      request.headers.set("uid", authInfo?.userId ?? "");
      if (headers != null) {
        for (var key in headers.keys) {
          request.headers.set(key, headers[key] ?? "");
        }
      }
      if(data.isNotEmpty){
        final body = utf8.encode(jsonEncode(data));
        request.contentLength = body.length;
        request.add(body);
      }
      final response = await request.close();
      if (response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      } else if (response.statusCode == 401) {
        throw Exception("登陆失效");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }
  initUserInfo(AuthInfo authInfo) async {
    this.authInfo = authInfo;
    print("authInfo" + jsonEncode(authInfo.toJson()));
  }

  Future<AuthInfo> getAuthInfoBytempToken(String tokenUrl) async {
    final params =  Uri.splitQueryString(tokenUrl);
    final tempToken = params["tempToken"];
    var  uri = "https://cn.devecostudio.huawei.com/authrouter/auth/api/temptoken/check?site=CN&tempToken=${tempToken}&appid=1007&version=0.0.0";
    final  jwtToken = await baseRequest(uri, {}, {}, "GET");
    if (jwtToken == null) {
      throw Exception("tempToken 无效");
    }
    uri = "https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check";
    final result = await baseRequest(uri, {},{ "refresh": "false", "jwtToken": jwtToken as String }, "GET");
    var json = jsonDecode(result as String)["userInfo"];
    final authInfo = AuthInfo.fromJson(json);
    await initUserInfo(authInfo);
    return authInfo;
  }
  userTeamList(){
    final uri = "https://connect-api.cloud.huawei.com/api/ups/user-permission-service/v1/user-team-list";
    return baseRequest(uri, {}, {}, "GET");
  }
  getCertList(){
    final uri = "https://connect-api.cloud.huawei.com/api/ups/user-permission-service/v1/user-team-list";
    return baseRequest(uri, {}, {}, "GET");
  }
  deleteCertList(Array<String> certIds){
    final uri ="https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/delete";
    return baseRequest(uri, {"certIds":certIds}, {}, "DELETE");
  }
  // type 1 debug 2 prod
  createCert(name, type, csr){
    final uri = "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/add";
    final params = {"csr":csr,"certName":name,"certType":type};
    return baseRequest(uri, params, {}, "POST");
  }
  createProfile(name, certId,deviceIds,moduleJson, [packageName="com.xiaobai.testgo",]){
      final uri = "https://connect-api.cloud.huawei.com/api/cps/provision-manage/v1/ide/test/provision/add";
      final params = {
            "provisionName": name,
            "aclPermissionList": this.getAcl(moduleJson),
            "deviceList": deviceIds,
            "certList": [certId],
            "packageName": packageName
      };
    return baseRequest(uri, params, {});
  }
  downloadObj(objId){
      final uri = "https://connect-api.cloud.huawei.com/api/amis/app-manage/v1/objects/url/reapply";
      final params  = { "sourceUrls": objId};
      return baseRequest(uri, params, {});
  }
  deviceList(){
      final uri = "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/list?start=1&pageSize=100&encodeFlag=0";
      return baseRequest(uri, {}, {}, "GET");
  }
  createDevice(deviceName, uuid){
      final uri = "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/add";
      final params  = {"deviceName": deviceName,"udid": uuid,"deviceType":4};
      return baseRequest(uri, params, {});
  }
  getAcl(moduleJson) {
        // if (!moduleJson || !moduleJson.module || !moduleJson.module.requestPermissions) {
        //     print("not found requestPermissions" + moduleJson);
        //   return [];
        // }
        // final pers = moduleJson.module.requestPermissions.map(d => d.name);
        // final set2 = new Set(pers);
        // final intersection = this.aclList.filter(value => set2.has(value));
        // print("found acl", intersection);
        // return intersection;
    }
    
}

final eco = EcoService();