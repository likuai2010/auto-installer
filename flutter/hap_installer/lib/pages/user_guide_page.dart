import 'package:flutter/material.dart';
import 'package:hap_installer/widget/local_web_view.dart';

/// 使用教程页面
///
/// 通过 WebView 嵌入展示在线教程内容
class UserGuidePage extends StatelessWidget {
  /// 教程 URL
  static const String tutorialUrl =
      'https://gitee.com/xiaobai-studio/XiaoBaiGuide/blob/master/README.md';

  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('使用教程')),
      body: const LocalWebView(
        url: tutorialUrl,
        isFile: false,
      ),
    );
  }
}
