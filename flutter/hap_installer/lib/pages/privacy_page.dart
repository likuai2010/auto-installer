import 'package:flutter/material.dart';
import 'package:hap_installer/widget/local_web_view.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('免责声明')),
      body: const LocalWebView(url: "assets/html/disclaimer.html", isFile: true),
    );
  }
}
