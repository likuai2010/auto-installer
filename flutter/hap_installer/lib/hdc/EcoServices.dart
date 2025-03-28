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
    Map<String, dynamic> data,
    Map<String, String>? headers, [
    String method = 'POST',
  ]) async {
    var httpClient = HttpClient();
    try {
      final uri = Uri.parse(url);
      final request = await httpClient.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set("oauth2Token", authInfo?.accessToken ?? "");
      request.headers.set("teamId", authInfo?.teamId ?? authInfo?.userId ?? "");
      request.headers.set("uid", authInfo?.userId ?? "");
      if (headers != null) {
        for (var key in headers.keys) {
          request.headers.set(key, headers[key] ?? "");
        }
      }
      if (data.isNotEmpty) {
        final body = utf8.encode(jsonEncode(data));
        print("base body: ${url.substring(url.length - 10, url.length)}");
        request.contentLength = body.length;
        request.add(body);
      }
      final response = await request.close();
      final strResult = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // print("base result: ${strResult}");
        try {
          return EcoResult.fromJson(jsonDecode(strResult));
        } catch (e) {
          print('jsonDecode Error: $e');
          return EcoResult(ret: Ret(code: 0, msg: strResult));
        }
      } else if (response.statusCode == 401) {
        return EcoResult(ret: Ret(code: 401, msg: "登录信息过期"));
      }
    } catch (e) {
      print('Error: $e');
      return EcoResult(ret: Ret(code: 403, msg: "$e"));
    } finally {
      httpClient.close();
    }
    return null;
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
        throw FormatException("登陆信息失效");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  initUserInfo(AuthInfo? authInfo) async {
    this.authInfo = authInfo;
    if (authInfo == null) return;
  }

  Future<AuthInfo?> getAuthInfoBytempToken(String tokenUrl) async {
    final params = Uri.splitQueryString(tokenUrl);
    final tempToken = params["tempToken"];
    var uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/temptoken/check?site=CN&tempToken=${tempToken}&appid=1007&version=0.0.0";
    final jwtToken = await base(uri, {}, {}, "GET");
    if (jwtToken == null) {
      throw FormatException("tempToken 无效");
    }
    uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check";
    final result = await base(uri, {}, {
      "refresh": "false",
      "jwtToken": jwtToken.ret.msg,
    }, "GET");
    if (result?.userInfo == null) {
      throw FormatException("登陆失败");
    }
    return result?.userInfo;
  }

  Future<List<TeamInfo>?> getUserTeamList() async {
    final uri =
        "https://connect-api.cloud.huawei.com/api/ups/user-permission-service/v1/user-team-list";
    final result = await base(uri, {}, {}, "GET");
    // 没有权限获取
    if (result?.ret.code == 403) {
      return null;
    }
    if (result?.ret.code == 401) {
      throw FormatException(result?.ret.msg ?? "");
    }
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
      throw FormatException("证书创建失败: ${result?.ret.msg}");
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
    print("createProfile ${params}");
    final result = await base(uri, params, {});
    if (result?.provisionFileUrl == null) {
      throw FormatException("Profile创建失败: ${result?.ret.msg}");
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

  List<String> getAcl(ModuleInfo? moduleJson) {
    if (moduleJson?.module?.requestPermissions == null) {
      print("not found requestPermissions");
      return [];
    }
    final pers =
        moduleJson?.module?.requestPermissions.map((p) => p.name) ?? [];
    final intersectionList = Set<String>.from(
      pers,
    ).intersection(Set<String>.from(aclList));
    print("found acl ${intersectionList.toList()}");
    return intersectionList.toList();
  }

  Future<bool> autoCreateProfile(
    SignConfig config,
    ModuleInfo moduleJson,
    Function unLogin,
  ) async {
    const certName = "xiaobai-debug";
    if (config.certId.isEmpty) {
      print(" EcoService create cert");
      if (unLogin()) {
        throw FormatException("请登录华为账号");
      }
      final certList = await getCertList();
      final debugCerts = certList.where((d) => d.certType == 1);
      CertInfo? xiaobaiDebug;
      final devCerts = debugCerts.where((d) => d.certName == certName);
      if (devCerts.isNotEmpty) {
        xiaobaiDebug = devCerts.first;
      }
      // 没有则创建
      if (xiaobaiDebug == null) {
        // 最多三个证书
        if (certList.length > 2) {
          final sortList = debugCerts.toList();
          sortList.sort((a, b) => a.expireTime.compareTo(b.expireTime));
          await deleteCertList([sortList.first.id]);
        }
        final csr = await readCsr(config.csrPath);
        xiaobaiDebug = await createCert(certName, 1, csr);
      }
      {
        final urlsInfo = await downloadObj(xiaobaiDebug.certObjectId);
        await downloadFile(urlsInfo.first.newUrl, config.certPath);
      }
      config.certId = xiaobaiDebug.id;
    } else {
      print(" EcoService cert 存在");
    }
    var udid = config.udids.first;
    if (udid.isNotEmpty) {
      if (unLogin()) {
        throw FormatException("请登录华为账号");
      }
      var deviceList = await this.deviceList();
      if (deviceList.where((d) => d.udid == udid).isEmpty) {
        try {
          await createDevice("xiaobai-device-${udid.substring(0, 10)}", udid);
          deviceList = await this.deviceList();
        } catch (e) {
          throw FormatException("注册设备失败: 请检查设备udid:$udid");
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
      print(" ${profileName} profile 创建成功");
    } else {
      print(" ${profileName} profile 存在");
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
