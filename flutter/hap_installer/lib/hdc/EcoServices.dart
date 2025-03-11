import 'dart:io';
import 'dart:convert';

import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';

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
  AuthInfo? authInfo;

  Future<EcoResult?> base(
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
      if (data.isNotEmpty) {
        final body = utf8.encode(jsonEncode(data));
        request.contentLength = body.length;
        request.add(body);
      }
      final response = await request.close();
      if (response.statusCode == 200) {
        final strResult = await response.transform(utf8.decoder).join();
        try {
          return EcoResult.fromJson(jsonDecode(strResult));
        } catch (e) {
          print('jsonDecode Error: $e');
          return EcoResult(code: 0, msg: strResult);
        }
      } else if (response.statusCode == 401) {
        throw Exception("登陆失效");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  downloadFile(String debugCertUrl, String certPath) async {
    var httpClient = HttpClient();
    try {
      final uri = Uri.parse(debugCertUrl);
      final request = await httpClient.openUrl("GET", uri);
      request.headers.contentType = ContentType.binary;
      final response = await request.close();
      if (response.statusCode == 200) {
        File file = File(certPath);
        IOSink sink = file.openWrite();
        await response.pipe(sink);
        await sink.close();
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception("登陆失效");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
      return false;
    }
  }

  initUserInfo(AuthInfo? authInfo) async {
    this.authInfo = authInfo;
    if (authInfo == null) return;
    print("authInfo" + jsonEncode(authInfo.toJson()));
  }

  Future<AuthInfo?> getAuthInfoBytempToken(String tokenUrl) async {
    final params = Uri.splitQueryString(tokenUrl);
    final tempToken = params["tempToken"];
    var uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/temptoken/check?site=CN&tempToken=${tempToken}&appid=1007&version=0.0.0";
    final jwtToken = await base(uri, {}, {}, "GET");
    if (jwtToken == null) {
      throw Exception("tempToken 无效");
    }
    uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check";
    final result = await base(uri, {}, {
      "refresh": "false",
      "jwtToken": jwtToken.msg,
    }, "GET");
    if (result?.userInfo == null) {
      throw Exception("登陆失败");
    }
    initUserInfo(result!.userInfo!);
    return result.userInfo;
  }

  Future<List<TeamInfo>> getUserTeamList() async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/ups/user-permission-service/v1/user-team-list";
    final result = await base(uri, {}, {}, "GET");
    return result?.teams ?? List.empty();
  }

  Future<List<CertInfo>> getCertList() async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/list";
    final result = await base(uri, {}, {}, "GET");
    return result?.certList ?? List.empty();
  }

  deleteCertList(List<String> certIds) {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/delete";
    return base(uri, {"certIds": certIds}, {}, "DELETE");
  }

  // type 1 debug 2 prod
  Future<CertInfo> createCert(name, type, csr) async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/add";
    final params = {"csr": csr, "certName": name, "certType": type};
    final result = await base(uri, params, {}, "POST");
    if (result?.harmonyCert == null) {
      throw Exception("证书创建失败: ${result?.msg}");
    }
    return result!.harmonyCert!;
  }

  Future<String> createProfile(
    String name,
    String certId,
    List<String> deviceIds,
    ModuleInfo? moduleJson, [
    String packageName = "com.xiaobai.testgo",
  ]) async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/provision-manage/v1/ide/test/provision/add";
    final params = {
      "provisionName": name,
      "aclPermissionList": getAcl(moduleJson),
      "deviceList": deviceIds,
      "certList": [certId],
      "packageName": packageName,
    };
    final result = await base(uri, params, {});
    if (result?.provisionFileUrl == null) {
      throw Exception("Profile创建失败: ${result?.msg}");
    }
    return result!.provisionFileUrl!;
  }

  Future<List<UrlInfo>> downloadObj(String objId) async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/amis/app-manage/v1/objects/url/reapply";
    final params = {"sourceUrls": objId};
    final result = await base(uri, params, {});
    return result?.urlsInfo ?? List.empty();
  }

  Future<List<DeviceInfo>> deviceList() async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/list?start=1&pageSize=100&encodeFlag=0";
    final result = await base(uri, {}, {}, "GET");
    return result?.list ?? List.empty();
  }

  createDevice(deviceName, uuid) {
    final uri =
        "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/add";
    final params = {"deviceName": deviceName, "udid": uuid, "deviceType": 4};
    return base(uri, params, {});
  }

  getAcl(ModuleInfo? moduleJson) {
    if (moduleJson?.module?.requestPermissions == null) {
      print("not found requestPermissions");
      return [];
    }
    final pers =
        moduleJson?.module?.requestPermissions.map((p) => p.name) ?? [];
    final intersectionList = Set.from(pers).intersection(Set.from(aclList));
    print("found acl" + intersectionList.toString());
    return intersectionList;
  }

  Future<bool> autoCreateProfile(
    SignConfig config,
    ModuleInfo moduleJson,
    Function unLogin,
  ) async {
    const certName = "xiaobai-debug";
    if (config.certId != "") {
      print("testTag EcoService create cert");
      if (unLogin()) return false;
      final certList = await getCertList();
      final debugCert = certList.firstWhere((c) => c.certName == certName);
      final debugCerts = certList.where((d) => d.certType == 1);
      final deleteIds =
          debugCerts
              .where((d) => d.certName == certName)
              .map((d) => d.id)
              .toList();
      await deleteCertList(deleteIds);
      final csr = await readCsr(config.csrPath);
      final harmonyCert = await createCert(certName, 1, csr);
      final urlsInfo = await downloadObj(harmonyCert.certObjectId);
      if (!await File(config.certPath).exists()) {
        await downloadFile(urlsInfo.first.newUrl, config.certPath);
      }
      config.certId = debugCert.id;
    } else {
      print("testTag EcoService cert 存在");
    }
    var udid = config.udid.trim();
    if (udid != "") {
      if (unLogin()) return false;
      var deviceList = await this.deviceList();
      if (deviceList.where((d) => d.udid == udid).isEmpty) {
        try {
          var result = await createDevice(
            "xiaobai-device-" + udid.substring(0, 10),
            udid,
          );
          deviceList = await this.deviceList();
        } catch (e) {
          throw new Exception("注册设备失败: 请检查设备udid:" + udid);
        }
      }
    }

    final profileName =
        "xiaobai-debug_${config.packageName.replaceAll(".", "_")}";
    if (!await File(config.profilePath).exists()) {
      final deviceList = await this.deviceList();
      final deviceIds = deviceList.map((d) => d.id).toList();
      if (unLogin()) return false;
      var provisionFileUrl = await createProfile(
        profileName,
        config.certId,
        deviceIds,
        moduleJson,
        config.packageName,
      );
      await downloadFile(provisionFileUrl, config.profilePath);
      print("testTag ${profileName} profile 创建成功");
    } else {
      print("testTag ${profileName} profile 存在");
    }
    return true;
  }

  Future<String?> readCsr(String csrPath) async {
    try {
      File file = File(csrPath);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }
}

final eco = EcoService();
