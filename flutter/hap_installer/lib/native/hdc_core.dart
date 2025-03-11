import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'hdc_ffi_generated.dart';

class CoreLib {
  static CoreLib? _instance;
  Future<int> hdcCmd(String args) async {
    final params = args
        .split(" ")
        .map((p) => p.toNativeUtf8().cast<Pointer<Char>>());
    final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(
      params.length,
    );
    final result = hdcBindings.server();
    calloc.free(charArray);
    return result;
  }

  Future<int> sginCmd(String args) async {
    // final params = args.split(" ").map((p) => p.toNativeUtf8()).toList();
    // final Pointer<Pointer<Char>> charArray = calloc<Pointer<Char>>(
    //   params.length,
    // );
    // for (int i = 0; i < params.length; i++) {
    //   // 使用 toNativeUtf8 将 Dart 字符串转换为 C 字符串 (Pointer<Utf8>)
    //   charArray[i] = params[i].cast();
    // }
    // final result = _bindings.hdcCmd(params.length, charArray);
    // final dartString = result.cast<Utf8>().toDartString();
    // calloc.free(result);
    // calloc.free(charArray);
    return 1;
  }

  Future<String> unHap(
    String hapPath,
    String inFileName,
    String outPath,
  ) async {
    // final result = _bindings.uzip(
    //   hapPath.toNativeUtf8().cast(),
    //   inFileName.toNativeUtf8().cast(),
    //   outPath.toNativeUtf8().cast(),
    // );
    // final dartString = result.cast<Utf8>().toDartString();
    return "dartString";
  }

  DynamicLibrary _dylib(String libName) {
    if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('$libName.framework/$libName');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('lib$libName.so');
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('$libName.exe');
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }

  late final NativeCoreBindings hdcBindings;
  CoreLib._load() {
    hdcBindings = NativeCoreBindings(_dylib("hdc"));
  }

  factory CoreLib() {
    _instance ??= CoreLib._load();
    return _instance!;
  }
}
