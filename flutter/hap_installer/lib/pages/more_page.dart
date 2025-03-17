import 'package:flutter/material.dart';
import 'package:hap_installer/pages/privacy_page.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/pages/hdc_cmd_page.dart';

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
              ListItem(
                leading: Icon(Icons.branding_watermark),
                title: "命令行工具",
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HdcCmdPage()),
                  );
                },
              ),
              ListItem(
                leading: Icon(Icons.settings_cell),
                title: "重启设备",
                onClick: () {},
              ),
            ],
          ),
          GroupDecoration(
            label: "应用设置",
            children: [
              // ListItem(
              //   leading: Icon(Icons.color_lens),
              //   title: "深色模式",
              //   tailling: MenuAnchor(
              //         builder: (context, controller, child) {
              //           return TextButton(
              //             child: Text("跟随系统"),
              //             onPressed: () {
              //               if (controller.isOpen) {
              //                 controller.close();
              //               } else {
              //                 controller.open();
              //               }
              //             },
              //           );
              //         },
              //         menuChildren: [
              //           MenuItemButton(child: const Text('跟随系统'), onPressed: () {}),
              //           MenuItemButton(child: const Text('始终浅色'), onPressed: () {}),
              //           MenuItemButton(child: const Text('始终黑色'), onPressed: () {}),
              //       ],
              //   ),
              // ),
              ListItem(
                leading: Icon(Icons.color_lens),
                title: "清理缓存",
                onClick: () => {showAlert(context, title: Text("是否清理缓存?"))},
              ),
            ],
          ),
          GroupDecoration(
            label: "提示",
            children: [
              ListItem(
                leading: Icon(Icons.privacy_tip),
                title: "温馨提示",
                onClick:
                    () => {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('温馨提示'),
                            content: const Text(
                              '使用本工具安装App需要打开“开发者模式”，当您关闭“开发者模式”后，所有使用本工具安装的App都将失效。请前往设置-关于本机页面连点5次“软件版本”以开启开发者模式。具体安装步骤请查看更多-使用教程',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('知道了'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FilledButton(
                                child: const Text('查看使用教程'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      ),
                    },
              ),
              ListItem(
                leading: Icon(Icons.privacy_tip),
                title: "免责声明",
                onClick:
                    () => {
                      toPage(context, (_) {
                        return PrivacyPage();
                      }),
                    },
              ),
              ListItem(
                leading: Icon(Icons.quiz),
                title: "使用教程",
                onClick:
                    () => {
                      toPage(context, (_) {
                        return PrivacyPage();
                      }),
                    },
              ),
            ],
          ),
          GroupDecoration(
            label: "关于",
            children: [ListItem(title: "应用版本", tailling: Text("2.0.0"))],
          ),
        ],
      ),
    );
  }
}
