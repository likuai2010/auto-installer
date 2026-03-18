import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/pages/home/home_page.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:hap_installer/pages/more/more_page.dart';
import 'package:hap_installer/widget/DownloadDialog.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:process_run/shell.dart';

import 'ThemeViewModel.dart';
// import 'package:flutter_file_saver/flutter_file_saver.dart';

/// 显示 SnackBar 消息提示
void toask(BuildContext context, [String message = ""]) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      /// 根据当前主题自动适配深色/浅色模式配色：
      content: Text(
        message,
        style: TextStyle(
          color: AppColors.snackBarTextDynamic(context),
        ),
      ),
      backgroundColor: AppColors.snackBarBackgroundDynamic(context),
    ),
  );
}

void showDownloadDialog(BuildContext context, String javaPath) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DownloadDialog(javaPath: javaPath);
    },
  );
}
const defalut_port = 12345;

class EcoViewModel extends ChangeNotifier {
  bool isLogin = false;
  bool firstUse = false;
  bool loading = false;
  bool fileLoading = false;
  bool deviceLoaing = false;

  bool buildHnping = false;
  bool buildHaping = false;
  String hnpName = "base";
  String hnpVersion = "1.0.0";
  String hnpType = "public";
  String hnpOutPath = "";
  String? hnpBaseHap;

  List<TeamInfo> teamList = [];
  List<String> deviceList = [];
  List<String> historyList = [];
  AuthInfo? userInfo;
  HapInfo? hapInfo;
  String? currentDevice;
  SignConfig? signConfig;
  String storeDir = "";
  String hdcDir = "";
  String tempDir = "";
  String signConfigPath = "";
  String userInfoPath = "";
  String ipHistoryPath = "";
  String debugPath = "";
  String ip = "127.0.0.1";
  String port = "$defalut_port";

  HistoryViewModel? historyViewModel;
  ThemeViewModel? themeHistoryViewModel;
  EcoViewModel();
  initDebugPath() async {
    if (debugPath == "") {
      tempDir = await getTempDir();
      final debugDir = Directory(path.join(tempDir, "apps"));
      if (!await debugDir.exists()) {
        await debugDir.create(recursive: true);
      }
      debugPath = debugDir.path;
    }
  }

  Future<bool> init(BuildContext context) async {
    await cmd.startServer();
    cmd.javaHome = await getJavaDir();
    if (Platform.isMacOS) {
      cmd.javaHome = path.join(cmd.javaHome, "Contents", "Home");
    }
    hdcDir = await getHdcDir();
    final storeDir = Directory(path.join(await getAppDir(), "store"));

    if (!await storeDir.exists()) {
      await storeDir.create(recursive: true);
    }
    await initDebugPath();
    this.storeDir = storeDir.path;

    signConfigPath = path.join(await getAppDir(), "signConfig.json");
    userInfoPath = path.join(await getAppDir(), "userInfo.json");
    ipHistoryPath = path.join(await getAppDir(), "history.json");
    final javapath = await getJavaDir();

    await initSignConfig();

    await tarnsformAssert(javapath);
    var result =  await ohosAdapter.canOpenLink("xiaobai://com.xiaobai.auto_installer/open");
    firstUse = await getFirstUse() ?? true;
    await setFirstUse();
    final url = await getLocalUrl();
    ip = url?.split(":").first ?? ip;
    port = url?.split(":").last ?? port;
    await loadUserInfo(context);
    await readHistory();
    await autoConnect( context, () => showConnectDeviceBox(context, viewmodel));

    return true;
  }

  /// 自动连接设备
  ///
  /// 如果自动连接设置关闭，直接调用 builder 回调
  /// 否则尝试连接到保存的设备 URL
  autoConnect(BuildContext context, Function() builder) async {
    // 检查自动连接设置
    final autoConnectEnabled = await getAutoConnect();
   
    if (!autoConnectEnabled) {
      builder();
      return;
    }

    if (currentDevice == null) {
      final url = await getLocalUrl();
      if (url == null || url == "") {
        builder();
      } else {
        var result = await tryConnectToDevice(context, url);
        if (!result) {
          builder();
        }
      }
    }
  }

  recordIp(String ip) async {
    if (historyList.contains(ip)) {
      return;
    }
    historyList.add(ip);
    saveJsonToFile(jsonEncode(historyList), ipHistoryPath);
  }

  resetHistory() {
    historyList = [];
    notifyListeners();
    saveJsonToFile(jsonEncode(historyList), ipHistoryPath);
  }

  readHistory() async {
    historyList = await readIpHistoryFromFile(ipHistoryPath);
    notifyListeners();
  }

  String? baseHap() {
    if (hnpBaseHap == null) {
      return null;
    }
    return path.basename(hnpBaseHap!);
  }

  Future loadUserInfo(BuildContext context, [AuthInfo? authInfo]) async {
    if (authInfo != null) {
      await saveJsonToFile(jsonEncode(authInfo.toJson()), userInfoPath);
    }
    userInfo = await readUserInfoFromFile(userInfoPath);
    if (userInfo == null) return;
    await eco.initUserInfo(userInfo);
    if (await eco.autoRefreshToken()) {
      await saveJsonToFile(jsonEncode(eco.authInfo!.toJson()), userInfoPath);
    }
    try {
      final list = await eco.getUserTeamList();
      if (list != null) {
        teamList = list;
        if (teamList.isNotEmpty &&
            !teamList.any((t) => t.id == userInfo?.teamId)) {
          userInfo?.changeTeamId(teamList.first);
        }
      } else {
        toask(context, '获取团队信息失败(tip: 请关闭代理软件, ip必须在国内!)');
      }
      isLogin = true;
    } catch (e) {
      isLogin = false;
    }
    if (!Platform.isAndroid && !ohosAdapter.isOhos) {
      await checkDevices(null);
    }
    notifyListeners();
  }

  installJava(filePath, javaHome) async {
    final savePath = File("$filePath");
    if (await savePath.exists() && !await Directory(javaHome).exists()) {
      await extractFileToDisk(savePath.path, savePath.parent.path);
    }
  }

  // only windows and linux
  checkJava(BuildContext context) async {
    return true;
    // if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return true;
    // final hasJava = await hasJavaBySys();
    // if (hasJava) return true;

    // var javaPath = await getJavaDir();
    // if (!await Directory(javaPath).exists()) {
    //   showAlert(
    //     context,
    //     title: const Text("警告!"),
    //     content: const Text("缺少java环境! 请指定java目录"),
    //     onConfirm: () {
    //       openByUrl("https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/");
    //       changeJaveHome(context);
    //     },
    //   );
    //   return false;
    // } else {
    //   return true;
    // }
  }

  exportLog() async {
    final logPath = "${await getTempDir()}hdc.log";

    // FlutterFileSaver().writeFileAsString(
    //   fileName: 'hdc_log.txt',
    //   data: await File(logPath).readAsString(),
    // );
  }

  toLogin(BuildContext context) async {
    if (firstUse) {
      showTips(context);
      firstUse = false;
    }
    if (!await checkJava(context)) return;
    if (loading) return;
    loading = true;
    notifyListeners();
    final huawei = LoginHuawei();
    huawei.openUrl();
    try {
      final authInfo = await huawei.getAuthInfo();
      await loadUserInfo(context, authInfo);
    } catch (_) {}
    loading = false;
    notifyListeners();
  }

  toAuthDev(BuildContext context) async {
    final huawei = LoginHuawei();
    huawei.toDev();
  }

  toConnect(BuildContext context, Function() builder) async {
    deviceLoaing = true;
    notifyListeners();
    try {
      if (currentDevice == null) {
        final result = await tryConnectToDevice(context, "$ip:$port");
        if (!result) {
          builder();
        }
      } else {
        await checkDevices("$ip:$port");
        builder();
      }
    } catch (e) {
      toask(context, "检查设备失败 $e");
    }
    deviceLoaing = false;
    notifyListeners();
  }

  selectHnpType(String type) {
    hnpType = type;
    notifyListeners();
  }

  toSelectFile(BuildContext context) async {
    var result =  await ohosAdapter.canOpenLink("xiaobai://com.xiaobai.auto_installer/open");
    if (!await checkJava(context)) return;
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {

      // var hap = File("/data/storage/el1/bundle/entry.hap");
      // var reusult = await hap.exists();
      // await hap.copy("/data/storage/el2/base/haps/entry/files/entry.hap");
      final filePath = await selectFile();
      if (filePath != null) {
        hapInfo = await _loadApp(context, filePath);
      }
    } on FormatException catch (e) {
      toask(context, e.message);
    } catch (e) {
      toask(context, "$e");
    }
    fileLoading = false;
    notifyListeners();
  }

  selectBaseHap(BuildContext context) async {
    hnpBaseHap = null;
    final filePath = await selectFile();
    if (filePath?.endsWith(".hap") == true) {
      hnpBaseHap = filePath!;
    }
    notifyListeners();
  }

  buildHnp(BuildContext context) async {
    if (!await checkJava(context)) return false;
    if (buildHnping) return false;
    buildHnping = true;
    notifyListeners();
    var hasHap = false;
    try {
      final fileDir = await selectDir();
      if (fileDir != null) {
        hnpOutPath = Directory(fileDir).parent.path;
        var message = await cmd.baseHnp(
            "hnpcli pack -i \"$fileDir\" -o \"$hnpOutPath\"   -n $hnpName -v $hnpVersion");
        if (!message.contains("ERROR")) {
          hasHap = true;
        } else {
          toask(context, message);
          hasHap = false;
        }
      } else {
        hasHap = false;
      }
    } on FormatException catch (e) {
      toask(context, e.message);
    } catch (e) {
      print("buildHap error $e");
      toask(context, "$e");
      hasHap = false;
    }
    buildHnping = false;

    notifyListeners();
    return hasHap;
  }

  buildToHap(BuildContext context) async {
    if (!await checkJava(context)) return;
    if (buildHaping) return;
    buildHaping = true;
    notifyListeners();

    final hasHnp = await buildHnp(context);
    if (!hasHnp) {
      buildHaping = false;
      notifyListeners();
      return;
    }

    try {
      final temp = await getTempDir();

      final tempDir = hnpBaseHap ?? path.join(temp, "base_hnp.hap");

      final hnpInDir = path.join(temp, "base_hnp_in");
      final appsDir = path.join(temp, "apps");
      final hnpDir = Directory(path.join(hnpInDir, "hnp"));
      final hapInHnpDir = Directory(path.join(hnpInDir, "hnp", "arm64-v8a"));
      try {
        await hnpDir.create(recursive: true);
      } catch (_) {
        hnpDir.delete(recursive: true);
        await hnpDir.create(recursive: true);
      }
      await hapInHnpDir.create(recursive: true);
      await cmd.unpackageHap(tempDir, hnpInDir);
      final hapFile = File(path.join(hnpOutPath, "$hnpName.hnp"));
      hapFile.copy(path.join(hapInHnpDir.path, "$hnpName.hnp"));

      var moduleInfo = await cmd.readModuleInfo(hnpInDir);
      print("moduleInfo: ${jsonEncode(moduleInfo.toJson())}");
      // 追加当前信息
      var currentHnp = HnpPackage(package: "$hnpName.hnp", type: hnpType);
      var hnpPackages = moduleInfo.module!.hnpPackages.toList();
      hnpPackages.add(currentHnp);
      final module = moduleInfo.module!.copyWith(hnpPackages: hnpPackages);
      moduleInfo = moduleInfo.copyWith(module: module);

      moduleInfo = await cmd.updateModuleInfo(hnpInDir, moduleInfo);
      // 签名需要
      await File(path.join(hnpInDir, "module.json"))
          .copy(path.join(appsDir, "module.json"));
      hapInfo = HapInfo(
          packageName: moduleInfo.app?.bundleName ?? "未知",
          pathList: ["$appsDir/base_hnp.hap"],
          version: moduleInfo.app?.versionName ?? "未知",
          deviceType: moduleInfo.module?.deviceTypes ?? []);

      final message = await cmd.buildHap(hnpInDir, "$appsDir/base_hnp.hap");
      if (message != "") {
        toask(context, "$message");
      }
      print("buildhap $message");
    } on FormatException catch (e) {
      print("error $e");
      toask(context, e.message);
    } catch (e) {
      print("error $e");
      toask(context, "$e");
    }
    buildHaping = false;
    notifyListeners();
    Navigator.pop(context);
  }

  openFile(BuildContext context, String filePath) async {
    print("openFile $filePath");
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {
      hapInfo = await _loadApp(context, filePath);
    } on FormatException catch (e) {
      print("openFile error ${e.message}");
      toask(context, e.message);
    } catch (e) {
      print("openFile error $e");
      toask(context, "$e");
    }
    fileLoading = false;
    notifyListeners();
  }

  changeTeam(TeamInfo info) {
    if (userInfo != null) {
      userInfo!.changeTeamId(info);
      eco.initUserInfo(userInfo);
      saveJsonToFile(jsonEncode(userInfo!.toJson()), userInfoPath);
      notifyListeners();
    }
  }

  changeDevice(String id) {
    currentDevice = id;
    cmd.changeTarget(id);
    notifyListeners();
    historyViewModel?.initDebugAppList();
  }

  Future tryConnectToDevice(BuildContext context, String id) async {
    if (deviceList.contains(id)) {
      changeDevice(id);
      return true;
    } else {
      final ips = id.split(":");
      var result = await connectDevice(context, ips.first, ips.last);
      if (result) {
        if(themeHistoryViewModel?.autoPort == true && !ips.last.contains("$defalut_port")){
          var message = await cmd.setRemoteDebug();
          print("setRemoteDebug: $message");
          if(message.contains("successful")){
            result = await connectDevice(context, ips.first, "$defalut_port");
          }
        }
      }
      return result;
    }
  }

  Future<bool> connectDevice(BuildContext context, String ip, String port) async {
    deviceLoaing = true;
    notifyListeners();
    this.ip = ip;
    this.port = port;
    final deviceIp = "$ip:$port";
    await setLocalUrl("$ip:$port");
    var result = await _connectHdc(deviceIp);
    if (result == "连接成功") {
      recordIp(deviceIp);
    }
    deviceLoaing = false;
    notifyListeners();
    toask(context, result);
    return result == "连接成功";
  }

  _connectHdc(String url) async {
    if (!_checkUrlOrPort(url)) {
      return "请输入正确端口或地址";
    } else {
      final result = await cmd.connectHdc(url);
      var count = 0;
      while(true){
        count += 1;
        final deviceList = await cmd.targetList();
        if(count > 4){
          if(deviceList.contains("Unauthorized"))
            return "设备未授权!";
          break;
        }
        if(deviceList.contains("Unauthorized") || deviceList.contains('[Empty]')){
          await Future.delayed(const Duration(seconds: 1));
          continue;
        } else if(deviceList.contains(url)){
          await checkDevices(url);
          return "连接成功";
        }
        await Future.delayed(const Duration(seconds: 1));
      }
      return result;
    }
  }

  checkDevices(String? url) async {
    final result = await cmd.targetList();
    deviceList = result
        .split("\n")
        .where((d) => d != '' && !d.contains('[Empty]'))
        .toList();
    if (deviceList.isNotEmpty) {
      if (currentDevice == null || !deviceList.any((d) => d == currentDevice)) {
        if (deviceList.first.contains("server failed")) {
          currentDevice = "hdc服务启动失败，请重启应用!";
        } else {
          changeDevice(deviceList.first);
        }
      }
      if (url != null && deviceList.any((d) => d == url)) {
        changeDevice(url);
      }
    } else {
      currentDevice = null;
    }
    deviceLoaing = false;
    notifyListeners();
  }

  Future<HapInfo> _loadApp(BuildContext context, String hapPath) async {
    final appFile = File(hapPath);
    if (!await appFile.exists()) {
      throw FormatException("文件不存在: $hapPath");
    }
    await initDebugPath();

    final tempDir = Directory(path.join(debugPath, "temp"));
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
    await tempDir.create(recursive: true);
    List<String> pathList = [];
    if (path.extension(hapPath, 1).contains("app")) {
      await cmd.unzip_App(hapPath, tempDir.path);
      final files = tempDir.list();
      pathList = await files
          .where((f) => f.path.endsWith(".hap") || f.path.endsWith(".hsp"))
          .map((f) => f.path)
          .toList();
      pathList.sort((a, b) {
        return path.extension(b).compareTo(path.extension(a));
      });
    } else {
      pathList = [hapPath];
    }
    return await dumpHapInfo(pathList, debugPath);
  }

  initJavaRuntme(javapath, tempDir) async {
    try {
      if (Platform.isMacOS) {
        try {
          var result = await Process.run(
              'tar', ['-xzvf', "$javapath.tar.gz", "-C", tempDir]);
          var ret = result.outText + result.errText;
          print("tar: $ret");
        } catch (_) {
          await installJava("$javapath.tar.gz", javapath);
        }
        final javaHome = "$javapath/Contents/Home/bin/java";
        if (File(javaHome).existsSync()) {
          await Process.run('chmod', ['+x', javaHome]);
        }
      }
      if (Platform.isWindows) {
        await installJava("$javapath.zip", javapath);
      }
      if (Platform.isLinux) {
        await installJava("$javapath.tar.gz", javapath);
        await Process.run('chmod', ['+x', "${cmd.javaHome}/bin/java"]);
      }
    } catch (e) {
      print("initJavaRuntme error: $e");
    }
  }

  tarnsformAssert(javapath) async {
    await copyAssert("store", "xiaobai.csr", storeDir);
    await copyAssert("store", "xiaobai.p12", storeDir);
    await copyAssert("store", "key.pem", storeDir);
    // debug test
    await copyAssert("store", "unsigned.hap", storeDir);
    await copyAssert("store", "xiaobai-debug.cer", storeDir);
    await copyAssert("store", "xiaobai-debug.p7b", storeDir);

    print("hdcDir: $hdcDir");
    // await copyAssert("jar", "hap-sign-tool.jar", hdcDir);
    // await copyAssert("jar", "app_packing_tool.jar", hdcDir);
    // await copyAssert("jar", "app_unpacking_tool.jar", hdcDir);
    await copyAssert("jar", "base_hnp.hap", tempDir);

    if (Platform.isMacOS) {
      // 双架构
      await copyAssert("macos", "signer", hdcDir);
      await copyAssert("macos", "packing_tool", hdcDir);
      await copyAssert("macos", "hnpcli", hdcDir);
      final arch = await getArchitecture();
      if (arch.contains("x86_64")) {
        await copyAssert("macos", "hdc_x86_64", hdcDir, "hdc");
        await copyAssert(
          "macos",
          "libusb_shared_x86_64.dylib",
          hdcDir,
          "libusb_shared.dylib",
        );
      } else {
        await copyAssert("macos", "hdc", hdcDir);
        await copyAssert("macos", "libusb_shared.dylib", hdcDir);
      }
      await Process.run('chmod', ['+x', "$hdcDir/hnpcli"]);
      await Process.run('chmod', ['+x', "$hdcDir/signer"]);
      await Process.run('chmod', ['+x', "$hdcDir/packing_tool"]);
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      }
    }

    if (Platform.isWindows) {
      await copyAssert("windows", "signer.exe", hdcDir);
      await copyAssert("windows", "hdc.exe", hdcDir);
      await copyAssert("windows", "hnpcli.exe", hdcDir);
      await copyAssert("windows", "libusb_shared.dll", hdcDir);
      await copyAssert("windows", "packing_tool.exe", hdcDir);
      await copyAssert("windows", "libcjson.dll", hdcDir);
      await copyAssert("windows", "libcrypto-3-x64.dll", hdcDir);
      await copyAssert("windows", "libgcc_s_seh-1.dll", hdcDir);
      await copyAssert("windows", "libstdc++-6.dll", hdcDir);
      await copyAssert("windows", "libwinpthread-1.dll", hdcDir);
    }
    if (Platform.isLinux) {
      await copyAssert(
        "windows",
        "$JavaVersion.tar.gz",
        "$javapath.tar.gz",
        "",
      );
      await copyAssert("linux", "signer", hdcDir);
      await copyAssert("linux", "hnpcli", hdcDir);
      await copyAssert("linux", "hdc", hdcDir);
      await copyAssert("linux", "packing_tool", hdcDir);
      await copyAssert("linux", "libusb_shared.so", hdcDir);
      await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      await Process.run('chmod', ['+x', "$hdcDir/hnpcli"]);
      await Process.run('chmod', ['+x', "$hdcDir/signer"]);
      await Process.run('chmod', ['+x', "$hdcDir/packing_tool"]);
    }
    return;
  }

  clearAll(BuildContext context) async {
    final temp = await getTempDir();
    final hdc = await getHdcDir();
    await Directory(hdc).delete(recursive: true);
    await Directory(temp).delete(recursive: true);
    try {
      await FilePicker.platform.clearTemporaryFiles();
      resetHistory();
      // ignore: empty_catches
    } catch (e) {}
    toask(context, "清理完成! 请重启应用");
  }
  clearCache(BuildContext context) async {
    final hdc = await getHdcDir();
    await Directory(hdc).delete(recursive: true);
    await Directory(debugPath).delete(recursive: true);
    try {
      await FilePicker.platform.clearTemporaryFiles();
      resetHistory();
      // ignore: empty_catches
    } catch (e) {}
    toask(context, "清理完成! 请重启应用");
  }

  copyAssert(
    String dir,
    String fileName,
    String targetDir, [
    String? target,
  ]) async {
    try {
      final bytes = await rootBundle.load('assets/$dir/$fileName');
      File file = File(path.join(targetDir, target ?? fileName));
      if (!await file.exists()) {
        await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      }
    } catch (e) {
      print("copyAssert error $e");
    }
  }

  initSignConfig() async {
    final defaultConfig = SignConfig(
      udids: List.empty(),
      certId: "",
      csrPath: path.join(storeDir, "xiaobai.csr"),
      keystoreFile: path.join(storeDir, "key.pem"),
      keystorePwd: "xiaobai123",
      keyAlias: "xiaobai",
      profilePath: path.join(storeDir, "xiaobai-debug.p7b"),
      certPath: path.join(storeDir, "xiaobai-debug.cer"),
    );
    try {
      signConfig =
          await readSignConfigFromFile(signConfigPath) ?? defaultConfig;
    } catch (e) {
      signConfig = defaultConfig;
    }
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
    return true;
  }

  saveSignConfig() async {
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
  }

  resetSignConfig() async {
    final defaultConfig = SignConfig(
      udids: List.empty(),
      certId: "",
      csrPath: path.join(storeDir, "xiaobai.csr"),
      keystoreFile: path.join(storeDir, "key.pem"),
      keystorePwd: "xiaobai123",
      keyAlias: "xiaobai",
      profilePath: path.join(storeDir, "xiaobai-debug.p7b"),
      certPath: path.join(storeDir, "xiaobai-debug.cer"),
    );
    signConfig = defaultConfig;
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
  }

  changeCertConfig(CertInfo info) async {
    signConfig!.certId = info.id;
    signConfig!.certPath = path.join(storeDir, "${info.certName}.cer");
    await saveJsonToFile(jsonEncode(signConfig!.toJson()), signConfigPath);
    return signConfig;
  }

  changeJaveHome(BuildContext context) async {
    final javahome = await selectDir();
    if (javahome != null) {
      final java = await File(path.join(javahome, "bin", "java")).exists();
      final javaExe =
          await File(path.join(javahome, "bin", "java.exe")).exists();
      if (java || javaExe) {
        cmd.javaHome = javahome;
        toask(context, "指定成功");
      } else {
        toask(context, "不是有效的java目录! (必须含有bin目录)");
      }
    }
  }

  toGitStore() {
    cmd.toApp("org.xbstudio.gitstorebox");
  }

  testSignHap(BuildContext context) async {
    String filePath = path.join(storeDir, "unsigned.hap");
    var error = await cmd.signHap(filePath, signConfig!);
    toask(context, error ?? "");
    //error = await cmd.installHap(await cmd.getOutPath(filePath));
    print("installHap: $error");
    toask(context, error ?? "");
  }
  installAutoInstaller() async{
    const papckage = "com.xiaobai.autoinstaller";
    final time = await cmd.dumpAppInstallTime(papckage);
    if(!time.contains("installTime")){
        await copyAssert("ohos", "auto_installer.hap", tempDir);
        var signConfig = this.signConfig!;
        signConfig.packageName = papckage;
        signConfig.profilePath = "$storeDir/${signConfig.packageName.replaceAll(".", "_")}.p7b";
        await eco.autoCreateProfile(signConfig, []);
        final hapPath = path.join(tempDir, "auto_installer.hap");
        var result = await cmd.signHap(hapPath, signConfig);
        final outPath = await cmd.getOutPath(hapPath);
        result = await cmd.installHap(outPath);
        await File(hapPath).delete();
        await File(outPath).delete();
        return result;
    }
  }

  _installHap(HapInfo hap, [SignConfig? signConfig, bool recert = false, bool reinstall = false]) async {
    final model = historyViewModel!;
    final current = model.createDebugHistory(hap);
    bool nextStep = true;
    model.updateHistory(current, (debug){
      return debug.copyWith(finished: false);
    });
    if(signConfig == null) {
        nextStep = await model.newSetp(current, "设备检查", () async {
          return currentDevice == null ? "未连接设备" : null;
        });
        for (var p in hap.pathList) {
          if (nextStep) {
            nextStep = await model.newSetp(current, "调试(${path.basename(p)})", () async {
              String? result;
              // 证书变更需要卸载重装
              if (reinstall){
                await cmd.unInstall(hap.packageName, hap.pathList.length > 1, !recert);
              } 
              result = await cmd.installHap(p);
              if (result == null){
                await model.updateDebugApp(hap, null);
              }
              return result;
            });
          }
        }
        if (nextStep){
          await model.newSetp(current, "更新历史", () async {
            await model.updateDebugApp(hap, null);
              return null;
          });
        }
    } else {
      signConfig.packageName = hap.packageName;
      signConfig.profilePath =
        "$storeDir/${hap.packageName.replaceAll(".", "_")}.p7b";
      final model = historyViewModel!;
      nextStep = await model.newSetp(current, "登录检查", () async {
        return !isLogin ? "未登录" : null;
      });
      if (nextStep) {
        nextStep = await model.newSetp(current, "设备检查", () async {
          return currentDevice == null ? "未连接设备" : null;
        });
      }
      if (nextStep) {
        nextStep = await model.newSetp(current, "获取设备udid", () async {
          final udid = await cmd.getUdid();
          if (udid.length != 64) {
            throw FormatException("UDID不合法: $udid");
          }
          var udids = signConfig.udids.toList();
          if (!udids.contains(udid)) {
            udids.add(udid);
            signConfig.udids = udids;
          }
          return null;
        });
      }
      if (await eco.autoRefreshToken()) {
        await saveJsonToFile(jsonEncode(eco.authInfo!.toJson()), userInfoPath);
      }
      if (nextStep) {
        nextStep = await model.newSetp(current, "请求签名", () async {
          if (recert) {
            await eco.deleteCertList([signConfig.certId]);
            signConfig.certId = "";
          }
          if (recert || reinstall) {
            if (await File(signConfig.profilePath).exists()){
              await File(signConfig.profilePath).delete();
            }
          }
          await eco.autoCreateProfile(signConfig, hap.acl);
          return null;
        });
      }
      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.newSetp(current, "签名(${path.basename(p)})", () async {
            return await cmd.signHap(p, signConfig);
          });
        }
      }
      final outPathList = <String>[];
      for (var p in hap.pathList) {
        outPathList.add(await cmd.getOutPath(p));
      }

      final unSignedList = hap.pathList;
      hap = hap.copyWith(pathList: outPathList);

     

      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.newSetp(current, "调试(${path.basename(p)})", () async {
            if(hap.packageName == "com.xiaobai.hap_installer" && ohosAdapter.isOhos){
              var result = await installAutoInstaller();
              if (result != null) {
                return result;
              }
              return await cmd.instalerSelf(p, hap.packageName);
            } 
            String? result;
            // 证书变更需要卸载重装
            if (reinstall){
              await cmd.unInstall(hap.packageName, hap.pathList.length > 1, !recert);
            } 
            result = await cmd.installHap(p);
            return result;
          });
        }
      }
      await model.newSetp(current, "更新调试历史", () async {
        if(nextStep && !reinstall){
          for (var p in unSignedList) {
              await File(p).delete();
          }
        }
        await model.updateDebugApp(hap, signConfig.certPath);
        return null;
      });
    }
    model.updateHistory(current, (debug){
      return debug.copyWith(finished: true);
    });
  }
  installHap(HapInfo hap, [bool recert = false, bool reinstall = false]) async {
    _installHap(hap, signConfig = signConfig, recert = recert, reinstall = reinstall);
  }

  bool _checkUrlOrPort(String url) {
    int? number = int.tryParse(url);
    if (url.length <= 5 && number != null) {
      return false;
    } else if (url.length > 5 && !url.contains(":")) {
      return false;
    }
    return true;
  }
}

final viewmodel = EcoViewModel();
