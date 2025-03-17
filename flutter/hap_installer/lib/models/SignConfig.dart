import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:path/path.dart' as path;

part 'generated/SignConfig.freezed.dart';
part 'generated/SignConfig.g.dart';

@unfreezed
abstract class SignConfig with _$SignConfig {
  factory SignConfig({
    @Default("") String packageName,
    @Default([]) List<String> udids,
    @Default("") String csrPath,
    @Default("") String certPath,
    @Default("") String certId,
    @Default("") String profilePath,
    @Default("") String keystoreFile,
    @Default("") String keystorePwd,
    @Default("") String keyAlias,
  }) = _SignConfig;

  // 从JSON构建
  factory SignConfig.fromJson(Map<String, dynamic> json) =>
      _$SignConfigFromJson(json);
}
