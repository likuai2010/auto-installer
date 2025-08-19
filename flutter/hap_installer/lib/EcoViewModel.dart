import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/models/AuthInfo.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';
import 'package:hap_installer/models/SignConfig.dart';
import 'package:hap_installer/pages/Home.dart';
import 'package:hap_installer/pages/more_page.dart';
import 'package:hap_installer/widget/DownloadDialog.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:process_run/shell.dart';
// import 'package:flutter_file_saver/flutter_file_saver.dart';

void toask(BuildContext context, [String message = ""]) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
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
  String port = "12345";

  HistoryViewModel? historyViewModel;

  EcoViewModel();
  Future<bool> init() async {
    cmd.startServer();
    

    cmd.javaHome = await getJavaDir();
    if(Platform.isMacOS){
      cmd.javaHome = path.join(cmd.javaHome, "Contents", "Home");
    }
    tempDir = await getTempDir();
    hdcDir = await getHdcDir();
    final storeDir = Directory(path.join(await getAppDir(), "store"));
    final debugDir = Directory(path.join(tempDir, "apps"));
    if (!await storeDir.exists()) {
      await storeDir.create(recursive: true);
    }
    if (!await debugDir.exists()) {
      await debugDir.create(recursive: true);
    }

    debugPath = debugDir.path;
    this.storeDir = storeDir.path;

    signConfigPath = path.join(await getAppDir(), "signConfig.json");
    userInfoPath = path.join(await getAppDir(), "userInfo.json");
    ipHistoryPath = path.join(await getAppDir(), "history.json");
    final javapath = await getJavaDir();
    
    await initSignConfig();

    await tarnsformAssert(javapath);
   
    await Isolate.run(() async {
        await initJavaRuntme(javapath, tempDir);
    });
    // if(!ohosAdapter.isOhos){
    //  
    // }else{
      
    // }
    final url = await getLocalUrl();
    firstUse = await getFirstUse() ?? true;
    await setFirstUse();
    ip = url?.split(":").first ?? ip;
    port = url?.split(":").last ?? port;
    readHistory();

    return true;
  }
  recordIp(String ip) async {
    if(historyList.contains(ip)){
      return;
    }
    historyList.add(ip);
    saveJsonToFile(jsonEncode(historyList), ipHistoryPath);
  }
  resetHistory(){
    historyList = [];
    notifyListeners();
    saveJsonToFile(jsonEncode(historyList), ipHistoryPath);
  }
  readHistory() async{
    historyList = await readIpHistoryFromFile(ipHistoryPath);
    notifyListeners();
  }
  String? baseHap() {
    if(hnpBaseHap == null) {
      return null;
    }
    return path.basename(hnpBaseHap!);
  }
  Future loadUserInfo(BuildContext context, [AuthInfo? authInfo]) async {
    if (authInfo != null) {
      saveJsonToFile(jsonEncode(authInfo.toJson()), userInfoPath);
    }
    userInfo = await readUserInfoFromFile(userInfoPath);
    if (userInfo == null) return;
    try {
      await eco.initUserInfo(userInfo);
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
    if(await savePath.exists() && ! await Directory(javaHome).exists()){
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
    try{
      final authInfo = await huawei.getAuthInfo();
      await loadUserInfo(context, authInfo);
    } catch(_){

    } 
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
      if (currentDevice == null){
          final result = await connectDevice(context, ip, port);
          if (!result) {
            builder();
          }
      }else{
        await checkDevices("$ip:$port");
        builder();
      }
    } catch (e) {
      toask(context, "检查设备失败 $e");
    }
    deviceLoaing = false;
    notifyListeners();
  }
  selectHnpType(String type){
    hnpType = type;
    notifyListeners();
  }

  toSelectFile(BuildContext context) async {
    if (!await checkJava(context)) return;
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {
      final filePath = await selectFile();
      if (filePath != null) {
        hapInfo = await _loadApp(context, filePath);
      }
    } on FormatException catch (e) {
      toask(context, e.message);
    } 
    catch (e) {
      toask(context, "$e");
    }
    fileLoading = false;
    notifyListeners();
  }


  selectBaseHap(BuildContext context) async{
    hnpBaseHap = null;
    final filePath = await selectFile();
    if (filePath?.endsWith(".hap") == true){
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
        var message = await cmd.baseHnp("hnpcli pack -i \"$fileDir\" -o \"$hnpOutPath\"   -n $hnpName -v $hnpVersion");
        if(!message.contains("ERROR")) {
          hasHap = true;
        } else{
          toask(context, message);
          hasHap = false;
        }
      }else{
        hasHap = false;
      }
    } on FormatException catch (e) {
      toask(context, e.message);
    } 
    catch (e) {
      print("buildHap error $e");
      toask(context, "$e");
      hasHap = false;
    }
    buildHnping = false;
    
    notifyListeners();
    return hasHap;
  }
 
  buildToHap(BuildContext context) async{
    if (!await checkJava(context)) return;
    if (buildHaping) return;
    buildHaping = true;
    notifyListeners();
   
    final hasHnp = await buildHnp(context);
    if(!hasHnp){
      buildHaping = false;
      notifyListeners();
      return; 
    }
   
   
    try {
      final temp = await getTempDir();
      
      final tempDir = hnpBaseHap ?? path.join(temp, "base_hnp.hap");
      
      final hnpInDir = path.join(temp, "base_hnp_in");
      final appsDir = path.join(temp, "apps");
      await cmd.unpackageHap(tempDir, hnpInDir);
      final hnpDir = Directory(path.join(hnpInDir, "hnp"));
      final hapInHnpDir =  Directory( path.join(hnpInDir, "hnp", "arm64-v8a"));

      try{
        await hnpDir.create(recursive: true);
      }catch(_){
        hnpDir.delete(recursive: true);
        await hnpDir.create(recursive: true);
      }
      await hapInHnpDir.create(recursive: true);
    
      final hapFile = File(path.join(hnpOutPath, "$hnpName.hnp"));
      hapFile.copy(path.join(hapInHnpDir.path,"$hnpName.hnp"));

      var moduleInfo = await cmd.readModuleInfo(hnpInDir);
      print("moduleInfo: ${jsonEncode(moduleInfo.toJson())}");
      // 追加当前信息
      var currentHnp = HnpPackage(package: "$hnpName.hnp", type:hnpType);
      var hnpPackages = moduleInfo.module!.hnpPackages.toList();
      hnpPackages.add(currentHnp);
      final module = moduleInfo.module!.copyWith(hnpPackages: hnpPackages);
      moduleInfo = moduleInfo.copyWith(module: module);
   
      moduleInfo = await cmd.updateModuleInfo(hnpInDir, moduleInfo);
      // 签名需要
      await File(path.join(hnpInDir, "module.json")).copy(path.join(appsDir, "module.json"));
      hapInfo = HapInfo(
        packageName: moduleInfo.app?.bundleName ?? "未知",
        pathList: ["$appsDir/base_hnp.hap"],
        version: moduleInfo.app?.versionName,
        deviceType: moduleInfo.module?.deviceTypes ?? []
      );

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
    if (fileLoading) return;
    fileLoading = true;
    notifyListeners();
    try {
      hapInfo = await _loadApp(context, filePath);
    } on FormatException catch (e) {
      toask(context, e.message);
    } catch (e) {
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
  }

  tryConnectToDevice(BuildContext context, String id) async {
    if(deviceList.contains(id)){
        currentDevice = id;
        cmd.changeTarget(id);
        notifyListeners();
    }else{
      Navigator.pop(context);
      deviceLoaing = true;
      notifyListeners();
      final ips = id.split(":");
      await connectDevice(context, ips.first,ips.last);
      deviceLoaing = false;
      notifyListeners();
    }
   
  }

  Future connectDevice(BuildContext context, String ip, String port) async {
    this.ip = ip;
    this.port = port;
    final deviceIp = "$ip:$port";
    await setLocalUrl("$ip:$port");
    var result = await _connectHdc(deviceIp);
    if (result == "连接成功") {
      recordIp(deviceIp);
    }
    toask(context, result);
    return result == "连接成功"; 
  }

  _connectHdc(String url) async {
    if (!_checkUrlOrPort(url)) {
      return "请输入正确端口或地址";
    } else {
      final result = await cmd.connectHdc(url);
      await checkDevices(url);
      
      return result;
    }
  }

  checkDevices(String? url) async {
    final result = await cmd.targetList();
    deviceList =
        result
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
      if(url != null && deviceList.any((d) => d == url)){
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
    final debugDir = Directory(debugPath);
    if (await debugDir.exists()) {
      await debugDir.delete(recursive: true);
    }
    await debugDir.create(recursive: true);
    List<String> pathList = [];
    if (path.extension(hapPath, 1).contains("app")) {
      await cmd.unzip_App(hapPath, debugPath);
      final files = Directory(debugPath).list();
      pathList =
          await files
              .where((f) => f.path.endsWith(".hap") || f.path.endsWith(".hsp"))
              .map((f) => f.path)
              .toList();
      pathList.sort((a, b) {
        return path.extension(b).compareTo(path.extension(a));
      });
    } else {
      pathList = [hapPath];
    }
    final err = await cmd.unzip_Hap(
      pathList.first,
      "module.json",
      path.join(debugPath, "module.json"),
    );
    if (err != "成功") {
      throw FormatException("解压文件失败: $err");
    }
    print("readModuleInfo  $hapPath  $err");
    final moduleInfo = await cmd.readModuleInfo(debugPath);
    return HapInfo(
      packageName: moduleInfo.app?.bundleName ?? "未知",
      pathList: pathList,
      version: moduleInfo.app?.versionName,
      deviceType: moduleInfo.module?.deviceTypes ?? []
    );
  }
  initJavaRuntme(javapath, tempDir) async {
    try {
      if(Platform.isMacOS){
        try {
        
          var result = await Process.run('tar', ['-xzvf', "$javapath.tar.gz", "-C", tempDir]);
          var ret =  result.outText + result.errText;
          print("tar: $ret");
        }catch (_){
            await installJava("$javapath.tar.gz", javapath);
        }
        final javaHome = "$javapath/Contents/Home/bin/java";
        if (File(javaHome).existsSync()){
            await Process.run('chmod', ['+x', javaHome]);
        }
      }
      if(Platform.isWindows){
          await installJava("$javapath.zip", javapath);
      }
      if(Platform.isLinux){
          await  installJava("$javapath.tar.gz", javapath);
          await Process.run('chmod', ['+x', "${cmd.javaHome}/bin/java"]);
      }
    } catch (e) {
      print("initJavaRuntme error: $e");
    }
  }
  tarnsformAssert(javapath) async {
    await copyAssert("store", "xiaobai.csr", storeDir);
    await copyAssert("store", "xiaobai.p12", storeDir);
    // debug test
    await copyAssert("store", "unsigned.hap", storeDir);
    await copyAssert("store", "xiaobai-debug.cer", storeDir);
    await copyAssert("store", "xiaobai-debug.p7b", storeDir);
 
    print("hdcDir: $hdcDir");
    await copyAssert("jar", "hap-sign-tool.jar", hdcDir);
    await copyAssert("jar", "app_packing_tool.jar", hdcDir);
    await copyAssert("jar", "app_unpacking_tool.jar", hdcDir);
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
        await Process.run('chmod', ['+x', "$hdcDir/hnpcli"]);
        await Process.run('chmod', ['+x', "$hdcDir/signer"]);
        await Process.run('chmod', ['+x', "$hdcDir/packing_tool"]);
      }
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      }
    }

    if (Platform.isWindows) {
      await copyAssert("windows", "$JavaVersion.zip", "$javapath.zip", "");
      await copyAssert("windows", "hdc.exe", hdcDir);
      await copyAssert("windows", "hnpcli.exe", hdcDir);
      await copyAssert("windows", "libusb_shared.dll", hdcDir);
    }
    if (Platform.isLinux) {
       await copyAssert(
          "windows",
          "$JavaVersion.tar.gz",
          "$javapath.tar.gz",
          "",
        );
      await copyAssert("linux", "hnpcli", hdcDir);
      await copyAssert("linux", "hdc", hdcDir);
      await copyAssert("linux", "libusb_shared.so", hdcDir);
      await Process.run('chmod', ['+x', "$hdcDir/hdc"]);
      await Process.run('chmod', ['+x', "$hdcDir/hnpcli"]);
    }
    return;
  }

  clearCache(BuildContext context) async {
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

  copyAssert(
    String dir,
    String fileName,
    String targetDir, [
    String? target,
  ]) async {
    try{
      final bytes = await rootBundle.load('assets/$dir/$fileName');
      File file = File(path.join(targetDir, target ?? fileName));
      if (!await file.exists()) {
        await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      }
    }catch(e){
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
  changeJaveHome(BuildContext context) async{
    final javahome = await selectDir();
    if(javahome != null){
      final java = await File(path.join(javahome, "bin", "java")).exists();
      final javaExe = await File(path.join(javahome, "bin", "java.exe")).exists();
      if (java || javaExe) {
        cmd.javaHome = javahome;
        toask(context, "指定成功");
      }else{
        toask(context, "不是有效的java目录! (必须含有bin目录)");
      }
    }
   
  }

  testSignHap(BuildContext context) async {
    String filePath = path.join(storeDir, "unsigned.hap");
    var error = await cmd.signHap(filePath, signConfig!);
    toask(context, error ?? "");
    //error = await cmd.installHap(await cmd.getOutPath(filePath));
    print("installHap: $error");
    toask(context, error ?? "");
  }

  installHap() async {
    if (hapInfo != null) {
      var hap = hapInfo!;
      var signConfig = this.signConfig!;
      bool nextStep = true;
      final model = historyViewModel!;
  
      model.createDebugHistory(hap);

      model.updateHistory((s) {
        s.finished = false;
      });
      model.updateStep(0, (setp) {
        return setp.copyWith(loading: false, error: !isLogin ? "未登录" : null);
      });
      nextStep = await model.startSetp(1, () async {
        if (Platform.isAndroid) {
          await _connectHdc("$ip:$port");
        }
        return currentDevice == null ? "未连接设备" : null;
      });

      signConfig.packageName = hap.packageName;
      signConfig.profilePath =
          "$storeDir/${hap.packageName.replaceAll(".", "_")}.p7b";

      if (nextStep) {
        nextStep = await model.startSetp(2, () async {
          final udid = await cmd.getUdid();
          var udids = signConfig.udids.toList();
          if (!udids.contains(udid)) {
            udids.add(udid);
            signConfig.udids = udids;
          }
          return null;
        }, "获取设备udid");
      }
      if (nextStep) {
        nextStep = await model.startSetp(2, () async {
          final module = await cmd.readModuleInfo(debugPath);
          await eco.autoCreateProfile(signConfig, module, () => !isLogin);
          return null;
        });
      }
      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.startSetp(3, () async {
            return await cmd.signHap(p, signConfig);
          }, "签名(${path.basename(p)})");
        }
      }

      for (var p in hap.pathList) {
        if (nextStep) {
          nextStep = await model.startSetp(4, () async {
            return await cmd.installHap(await cmd.getOutPath(p));
          }, "调试(${path.basename(p)})");
        }
      }
      model.updateHistory((setp) {
        setp.finished = true;
      });
    }
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
