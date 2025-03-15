import 'package:flutter/material.dart';
import 'package:hap_installer/pages/common.dart';
import 'package:hap_installer/pages/index_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Expanded(
      child: ListView(
        children: <Widget>[
          GroupDecoration(
            label: "小工具",
            children: [
              ListItem(leading: Icon(Icons.branding_watermark), title: "命令行工具"),
              ListItem(leading: Icon(Icons.settings_cell), title: "重启设备"),
            ],
          ),
          GroupDecoration(
            label: "应用设置",
            children: [
              ListItem(leading: Icon(Icons.color_lens), title: "深色模式"),
            ],
          ),
          GroupDecoration(
            label: "关于",
            children: [
              ListItem(leading: Icon(Icons.tips_and_updates), title: "温馨提示"),
              ListItem(leading: Icon(Icons.privacy_tip), title: "免责声明"),
              ListItem(leading: Icon(Icons.quiz), title: "使用教程"),
            ],
          ),
          GroupDecoration(label: "关于", children: [ListItem(title: "应用版本")]),
        ],
      ),
    );
  }
}
