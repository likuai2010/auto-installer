import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'native_core_bindings_generated.dart';

Future<String> hdcCmd(String args, String tempDir) async {
  return await Isolate.run(() {
    final logPath = path.join(tempDir, "hdc_out.log");
    _hdcCmd(args, logPath);
    return File(logPath).readAsString();
  });
}

int _hdcCmd(String args, String tempDir) {
  final params = args.split(" ").map((p) => p.toNativeUtf8()).toList();
  final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(params.length);
  for (int i = 0; i < params.length; i++) {
    // 使用 toNativeUtf8 将 Dart 字符串转换为 C 字符串 (Pointer<Utf8>)
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

startHdcServer() {
  final ReceivePort receivePort = ReceivePort();
  Isolate.spawn((SendPort sendPort) async {
    _bindings.hdcServer();
    sendPort.send("");
  }, receivePort.sendPort);
}

Future<String> signCmd(String args, String tempDir) async {
  return await Isolate.run(() {
    final logPath = path.join(tempDir, "sign_out.log");
    _signCmd(args, logPath);
    return File(logPath).readAsString();
  });
}

_signCmd(String args, String tempDir) async {
  final params = args.split(" ").map((p) => p.toNativeUtf8()).toList();
  final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(params.length);
  for (int i = 0; i < params.length; i++) {
    charArray[i] = params[i].cast();
  }
  _bindings.signCmd(params.length, charArray, tempDir.toNativeUtf8().cast());
  calloc.free(charArray);
  return;
}

Future<String> unHap(String hapPath, String inFileName, String outPath) async {
  final hapPathString = hapPath.toNativeUtf8();
  final inFileNameString = inFileName.toNativeUtf8();
  final outPathString = outPath.toNativeUtf8();
  return await Isolate.run(() {
    final result = _bindings.unHap(
      hapPathString.cast(),
      inFileNameString.cast(),
      outPathString.cast(),
    );
    calloc.free(hapPathString);
    switch (result) {
      case 0:
        return "成功";
      case 100:
        return "文件打开失败";
      case 101:
        return "没有此文件: $inFileName";
      case 102:
        return "打开内部文件失败";
    }
    return "失败";
  });
}

Future<String> unApp(String hapPath, String outPath) async {
  final hapPathString = hapPath.toNativeUtf8();
  final outPathString = outPath.toNativeUtf8();
  return await Isolate.run(() {
    final result = _bindings.unApp(hapPathString.cast(), outPathString.cast());
    calloc.free(hapPathString);
    switch (result) {
      case 0:
        return "成功";
      case 100:
        return "文件打开失败";
      case 101:
      case 102:
        return "打开内部文件失败";
    }
    return "失败";
  });
}

Future<int> sumAsync(int a, int b) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumRequestId++;
  final _SumRequest request = _SumRequest(requestId, a, b);
  final Completer<int> completer = Completer<int>();
  _sumRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'native_core';

/// The dynamic library in which the symbols for [NativeCoreBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
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

/// A response with the result of `sum`.
///
/// Typically sent from one isolate to another.
class _SumResponse {
  final int id;
  final int result;

  const _SumResponse(this.id, this.result);
}

/// Counter to identify [_SumRequest]s and [_SumResponse]s.
int _nextSumRequestId = 0;

/// Mapping from [_SumRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<int>> _sumRequests = <int, Completer<int>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort =
      ReceivePort()..listen((dynamic data) {
        if (data is SendPort) {
          // The helper isolate sent us the port on which we can sent it requests.
          completer.complete(data);
          return;
        }
        if (data is _SumResponse) {
          // The helper isolate sent us a response to a request we sent.
          final Completer<int> completer = _sumRequests[data.id]!;
          _sumRequests.remove(data.id);
          completer.complete(data.result);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort =
        ReceivePort()..listen((dynamic data) {
          // On the helper isolate listen to requests and respond to them.
          if (data is _SumRequest) {
            //inal int result = _bindings.sum_long_running(data.a, data.b);
            //final _SumResponse response = _SumResponse(data.id, result);
            //sendPort.send(response);
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
