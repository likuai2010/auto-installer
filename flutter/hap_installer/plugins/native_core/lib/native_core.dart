import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'native_core_bindings_generated.dart';

Future<String> hdcCmd(List<String> args, String tempDir) async {
  return await Isolate.run(() {
    final logPath = path.join(tempDir, "hdc_out.log");
    _hdcCmd(args, logPath);
    return File(logPath).readAsString();
  });
}

int _hdcCmd(List<String> args, String tempDir) {
  final params = args.map((p) => p.toNativeUtf8()).toList();
  final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(params.length);
  for (int i = 0; i < params.length; i++) {
    charArray[i] = params[i].cast();
  }
  final result = _bindings.hdcCmd(
    params.length,
    charArray,
    tempDir.toNativeUtf8().cast(),
  );
  calloc.free(charArray);
  return result;
}

startHdcServer(String tempDir) {
  final ReceivePort receivePort = ReceivePort();
  Isolate.spawn((SendPort sendPort) async {
    print("startServer");
    _bindings.hdcServer(tempDir.toNativeUtf8().cast());
    sendPort.send("");
  }, receivePort.sendPort);
}

Future<String> signCmd(List<String> args, String tempDir) async {
  // final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  // final int requestId = _nextSumRequestId++;
  // final _SignRequest request = _SignRequest(requestId, args, tempDir);
  // final Completer<String> completer = Completer<String>();
  // _cmdRequests[requestId] = completer;
  // helperIsolateSendPort.send(request);
  // return completer.future;
  return await Isolate.run(() {
    // final logPath = path.join(tempDir, "sign_out.log");
    return _signCmd(args, "");
  });
}

_signCmd(List<String> args, String tempDir) {
  final params = args.map((p) => p.toNativeUtf8()).toList();
  final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(params.length);
  for (int i = 0; i < params.length; i++) {
    charArray[i] = params[i].cast();
  }
  final result = _bindings.signCmd(
      params.length, charArray, tempDir.toNativeUtf8().cast());
  calloc.free(charArray);
  if (result == 0) {
    return "success";
  } else {
    return "签名失败";
  }
}

Future<String> unHap(String hapPath, String inFileName, String outPath) async {
  return await Isolate.run(() {
    final hapPathString = hapPath.toNativeUtf8();
    final inFileNameString = inFileName.toNativeUtf8();
    final outPathString = outPath.toNativeUtf8();
    final result = _bindings.unHap(
      hapPathString.cast(),
      inFileNameString.cast(),
      outPathString.cast(),
    );
    calloc.free(hapPathString);
    calloc.free(inFileNameString);
    calloc.free(outPathString);
    switch (result) {
      case 0:
        return "成功";
      case 100:
        return "文件打开失败: ${hapPath}";
      case 101:
        return "没有此文件: $inFileName";
      case 102:
        return "打开内部文件失败";
    }
    return "失败";
  });
}

Future<String> unApp(String hapPath, String outPath) async {
  return await Isolate.run(() {
    final hapPathString = hapPath.toNativeUtf8();
    final outPathString = outPath.toNativeUtf8();
    final result = _bindings.unApp(hapPathString.cast(), outPathString.cast());
    calloc.free(hapPathString);
    switch (result) {
      case 0:
        return "成功";
      case 100:
        return "文件打开失败: ${hapPath}";
      case 101:
      case 102:
        return "打开内部文件失败";
    }
    return "失败";
  });
}
// const char* result = native_jvm(
//   "-Djava.class.path=.xxx.jar", 
//   "MainClass",
//    NULL, 
//    "/Library/Java/JavaVirtualMachines/graalvm-jdk-17.0.12+8.1/Contents/Home/lib/server/libjvm.dylib"
// );
// printf(result);
Future<String> nativeJvm(String options, String mainClass, List<String> params, String jvmLib) async {
  return await Isolate.run(() {
    final optionsCString = options.toNativeUtf8();
    final mainClassCString = mainClass.toNativeUtf8();
    final jvmLibCString = jvmLib.toNativeUtf8();
    final argsPtr = calloc<Pointer<Char>>(params.length);
    for (var i = 0; i < params.length; i++) {
      argsPtr[i] = params[i].toNativeUtf8().cast<Char>();
    }
    final result = _bindings.native_jvm(optionsCString.cast(), mainClassCString.cast(), argsPtr, params.length, jvmLibCString.cast());
    calloc.free(optionsCString);
    calloc.free(mainClassCString);
    calloc.free(jvmLibCString);
    for (var i = 0; i < params.length; i++) {
      calloc.free(argsPtr[i]);
    }
    return result.cast<Utf8>().toDartString();
  });
}



Future<String> sumAsync(int a, int b) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumRequestId++;
  final _SumRequest request = _SumRequest(requestId, a, b);
  final Completer<String> completer = Completer<String>();
  _cmdRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'native_core';

/// The dynamic library in which the symbols for [NativeCoreBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid ||
      Platform.isLinux ||
      Platform.operatingSystem == "ohos") {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeCoreBindings _bindings = NativeCoreBindings(_dylib);

/// A request to compute `sum`.
///
/// Typically sent from one isolate to another.
class _SumRequest {
  final int id;
  final int a;
  final int b;

  const _SumRequest(this.id, this.a, this.b);
}

class _SignRequest {
  final int id;
  final String a;
  final String b;

  const _SignRequest(this.id, this.a, this.b);
}

class _CmdResponse {
  final int id;
  final String result;

  const _CmdResponse(this.id, this.result);
}

int _nextSumRequestId = 0;

final Map<int, Completer<String>> _cmdRequests = <int, Completer<String>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _CmdResponse) {
        final Completer<String> completer = _cmdRequests[data.id]!;
        _cmdRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) async {
        // On the helper isolate listen to requests and respond to them.
        if (data is _SumRequest) {
          //inal int result = _bindings.sum_long_running(data.a, data.b);
          final response = _CmdResponse(data.id, "");
          sendPort.send(response);
          return;
        }
        if (data is _SignRequest) {
          // final logPath = path.join(data.b, "sign_out.log");
          // print("signtool ");
          // // _signCmd(data.a, logPath);
          // final result = await File(logPath).readAsString();
          //  print("signtool ");
          // final response = _CmdResponse(data.id, result);
          // sendPort.send(response);
          return;
        }
        throw UnsupportedError(
          'Unsupported message type: ${data.runtimeType}',
        );
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
