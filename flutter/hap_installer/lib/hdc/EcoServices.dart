import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
final defaultAcl = [
    "ohos.permission.SYSTEM_FLOAT_WINDOW",
    "ohos.permission.READ_CONTACTS",
    "ohos.permission.WRITE_CONTACTS",
    "ohos.permission.READ_AUDIO",
    "ohos.permission.WRITE_AUDIO",
    "ohos.permission.READ_IMAGEVIDEO",
    "ohos.permission.WRITE_IMAGEVIDEO",
    "ohos.permission.READ_WRITE_DESKTOP_DIRECTORY",
    "ohos.permission.ACCESS_DDK_USB",
    "ohos.permission.ACCESS_DDK_HID",
    "ohos.permission.READ_PASTEBOARD",
    "ohos.permission.FILE_ACCESS_PERSIST",
    "ohos.permission.INTERCEPT_INPUT_EVENT",
    "ohos.permission.INPUT_MONITORING",
    "ohos.permission.SHORT_TERM_WRITE_IMAGEVIDEO",
    "ohos.permission.READ_WRITE_USER_FILE",
    "ohos.permission.READ_WRITE_USB_DEV",
    "ohos.permission.GET_WIFI_PEERS_MAC",
    "ohos.permission.SET_TELEPHONY_ESIM_STATE_OPEN",
    "ohos.permission.kernel.DISABLE_CODE_MEMORY_PROTECTION",
    "ohos.permission.kernel.ALLOW_WRITABLE_CODE_MEMORY",
    "ohos.permission.kernel.ALLOW_EXECUTABLE_FORT_MEMORY",
    "ohos.permission.MANAGE_PASTEBOARD_APP_SHARE_OPTION",
    "ohos.permission.MANAGE_UDMF_APP_SHARE_OPTION",
    "ohos.permission.ACCESS_DISK_PHY_INFO",
    "ohos.permission.PRELOAD_FILE",
    "ohos.permission.SET_PAC_URL",
    "ohos.permission.PERSONAL_MANAGE_RESTRICTIONS",
    "ohos.permission.START_PROVISIONING_MESSAGE",
    "ohos.permission.USE_FRAUD_CALL_LOG_PICKER",
    "ohos.permission.USE_FRAUD_MESSAGES_PICKER",
    "ohos.permission.PERSISTENT_BLUETOOTH_PEERS_MAC",
    "ohos.permission.ACCESS_VIRTUAL_SCREEN",
    "ohos.permission.MANAGE_APN_SETTING",
    "ohos.permission.GET_WIFI_LOCAL_MAC",
    "ohos.permission.kernel.ALLOW_USE_JITFORT_INTERFACE",
    "ohos.permission.GET_ETHERNET_LOCAL_MAC",
    "ohos.permission.kernel.DISABLE_GOTPLT_RO_PROTECTION",
    "ohos.permission.USE_FRAUD_APP_PICKER",
    "ohos.permission.ACCESS_DDK_DRIVERS",
    "ohos.permission.ACCESS_DDK_SCSI_PERIPHERAL",
    "ohos.permission.kernel.SUPPORT_PLUGIN",
    "ohos.permission.CUSTOM_SANDBOX",
    "ohos.permission.MANAGE_SCREEN_TIME_GUARD",
    "ohos.permission.CUSTOMIZE_SAVE_BUTTON",
    "ohos.permission.GET_ABILITY_INFO",
    "ohos.permission.ACCESS_FIDO2_ONLINEAUTH",
    "ohos.permission.USE_FLOAT_BALL",
    "ohos.permission.DLP_GET_HIDE_STATUS",
    "ohos.permission.READ_LOCAL_DEVICE_NAME",
    "ohos.permission.KEEP_BACKGROUND_RUNNING_SYSTEM",
    "ohos.permission.LINKTURBO",
    "ohos.permission.ACCESS_NET_TRACE_INFO",
    "ohos.permission.READ_WHOLE_CALENDAR",
    "ohos.permission.WRITE_WHOLE_CALENDAR",
    "ohos.permission.SET_SYSTEMSHARE_APPLAUNCHTRUSTLIST",
    "ohos.permission.HOOK_KEY_EVENT",
    "ohos.permission.WEB_NATIVE_MESSAGING",
    "ohos.permission.SUBSCRIBE_NOTIFICATION",
    "ohos.permission.CUSTOM_SCREEN_RECORDING",
    "ohos.permission.GET_IP_MAC_INFO",
    "ohos.permission.ACCESS_USER_FULL_DISK",
    "ohos.permission.kernel.LOAD_INDEPENDENT_LIBRARY",
    "ohos.permission.CRYPTO_EXTENSION_REGISTER"
];
class EcoService {
  var aclList = defaultAcl;
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
        return const EcoResult(ret: Ret(code: 401, msg: "登录信息过期"));
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
        throw const FormatException("登陆信息失效");
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
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/temptoken/check?site=CN&tempToken=$tempToken&appid=1007&version=0.0.0";
    final jwtToken = await base(uri, {}, {}, "GET");
    if (jwtToken == null) {
      throw const FormatException("tempToken 无效");
    }
    uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check";
    final result = await base(uri, {}, {
      "refresh": "false",
      "jwtToken": jwtToken.ret.msg,
    }, "GET");
    if (result?.userInfo == null) {
      throw const FormatException("登陆失败");
    }
    result?.userInfo?.setJwtToken(jwtToken.ret.msg);
    return result?.userInfo;
  }
 Future<bool> autoRefreshToken() async{
    try {
      await getUserTeamList();
      return false;
    } catch (e) {
      authInfo = await refreshToken(authInfo);
      return true;
    }
  
  }
  Future<AuthInfo?> refreshToken(AuthInfo? authInfo) async {
    var uri =
        "https://cn.devecostudio.huawei.com/authrouter/auth/api/jwToken/check";
    final result = await base(uri, {}, {
      "refresh": "true",
      "jwtToken": authInfo?.jwtToken ?? "",
    }, "GET");
    if (result?.userInfo == null) {
      throw const FormatException("token失效, 重新登录");
    }
    result?.userInfo?.setJwtToken(authInfo?.jwtToken ?? "");
    return result?.userInfo;
  }

  Future<List<TeamInfo>?> getUserTeamList() async {
    const uri =
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
    const uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/list";
    final result = await base(uri, {}, {}, "GET");
    return result?.certList ?? List.empty();
  }

  deleteCertList(List<String> certIds) {
    const uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/delete";
    return base(uri, {"certIds": certIds}, {}, "DELETE");
  }

  // type 1 debug 2 prod
  Future<CertInfo> createCert(name, type, csr) async {
    const uri =
        "https://connect-api.cloud.huawei.com/api/cps/harmony-cert-manage/v1/cert/add";
    final params = {"csr": csr, "certName": name, "certType": type};
    final result = await base(uri, params, {}, "POST");
    if (result?.harmonyCert == null) {
      var msg = result?.ret.msg ?? "";
      throw FormatException("证书创建失败: $msg");
    }
    return result!.harmonyCert!;
  }

  Future<String> createProfile(
    String name,
    String certId,
    List<String> deviceIds,
    List<String> aclList, [
    String packageName = "com.xiaobai.testgo",
  ]) async {
    const uri =
        "https://connect-api.cloud.huawei.com/api/cps/provision-manage/v1/ide/test/provision/add";
    final params = {
      "provisionName": name,
      "aclPermissionList": aclList,
      "deviceList": deviceIds,
      "certList": [certId],
      "packageName": packageName,
    };
    final result = await base(uri, params, {});
    if (result?.provisionFileUrl == null) {
      var msg = result?.ret.msg ?? "";
      if (msg.contains("certList")) {
        msg = "当前证书失效, 请点击下方重置证书";
      }
       if (msg.contains("not exist")) {
        msg = "当前证书不存在, 请点击下方重置证书";
      }
      if(msg.contains("exceeds limit")){
        msg = "本月签名过多,请使用其他账号或团队";
      }
      throw FormatException("${msg}");
    }
    return result!.provisionFileUrl!;
  }

  Future<List<UrlInfo>> downloadObj(String objId) async {
    const uri =
        "https://connect-api.cloud.huawei.com/api/amis/app-manage/v1/objects/url/reapply";
    final params = {"sourceUrls": objId};
    final result = await base(uri, params, {});
    return result?.urlsInfo ?? List.empty();
  }

  Future<List<DeviceInfo>> deviceList() async {
    const uri =
        "https://connect-api.cloud.huawei.com/api/cps/device-manage/v1/device/list?start=1&pageSize=100&encodeFlag=0";
    final result = await base(uri, {}, {}, "GET");
    return result?.list ?? List.empty();
  }

  createDevice(deviceName, uuid) {
    const uri =
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
    print("found acl  ${intersectionList.toList()} ${pers}");
    return intersectionList.toList();
  }

  Future<bool> autoCreateProfile(
    SignConfig config,
    List<String> acl,
  ) async {
    const certName = "xiaobai-debug";
    if (config.certId.isEmpty) {
      print(" EcoService create cert");
      final certList = await getCertList();
      final debugCerts = certList.where((d) => d.certType == 1);
      CertInfo? xiaobaiDebug;
      final devCerts = debugCerts.where((d) => d.certName == certName);
      if (devCerts.isNotEmpty) {
        xiaobaiDebug = devCerts.first;
        // 无效证书
        if(xiaobaiDebug.status == 2){
           await deleteCertList([xiaobaiDebug.id]);
           xiaobaiDebug = null;
        }
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
    var udid = config.udids.last;
    if (udid.isNotEmpty) {
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
      var provisionFileUrl = await createProfile(
        profileName,
        config.certId,
        deviceIds,
        acl,
        config.packageName,
      );
      await downloadFile(provisionFileUrl, config.profilePath);
      print(" $profileName profile 创建成功");
    } else {
      print(" $profileName profile 存在");
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
