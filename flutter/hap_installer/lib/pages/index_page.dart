import 'package:flutter/material.dart';
import 'package:hap_installer/widget/common.dart';

import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/pages/debug_detail_page.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Expanded(
      child: ListView(
        children: <Widget>[
          AppInfoBox(name: "小白调试助手", style: textTheme.titleLarge!),
          DebugSteps(),
          Consumer<EcoViewModel>(
            builder: (context, model, child) {
              if (model.hapInfo?.packageName == null ||
                  model.userInfo == null ||
                  model.currentDevice == null) {
                return Container();
              }
              return Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DebugDetailPage()),
                    );
                    model.installHap();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("开始调试"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DebugSteps extends StatelessWidget {
  DebugSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (context, model, child) {
        return GroupDecoration(
          children: [
            ListItem(
              leading: Icon(Icons.person),
              title: model.isLogin ? model.userInfo?.nickName ?? "匿名" : "未登录",
              subTitle: "华为账号",
              tailling: TextButton(
                onPressed: () {
                  viewmodel.toLogin(context);
                },
                child:
                    !model.loading
                        ? Text(model.isLogin ? "更换账号" : "登录账号")
                        : CircularProgressIndicator(value: null),
              ),
            ),
            ListItem(
              leading: Icon(
                Icons.signal_wifi_off_outlined,
              ), //Icon(Icons.signal_wifi_4_bar)
              title: model.currentDevice ?? "未连接",
              subTitle:
                  model.currentDevice?.contains(".") == true ? "无线连接" : "USB连接",
              tailling: TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    showDragHandle: true,
                    isScrollControlled: true,
                    context: context,
                    constraints: const BoxConstraints(maxHeight: 600),
                    builder: (context) {
                      return AnimatedPadding(
                        padding: MediaQuery.of(context).viewInsets,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          height: 300,
                          child: ConnectDeviceBox(
                            ip: model.ip,
                            port: model.port,
                          ),
                        ),
                      );
                      //return ConnectDeviceBox(ip: model.ip, port: model.port);
                    },
                  );
                },
                child: Text("连接设备"),
              ),
            ),
            ListItem(
              leading: Icon(Icons.apps_outage), //Icon(Icons.apps_outlined)
              title: model.hapInfo?.packageName ?? "未选择",
              subTitle: "仅.hap文件",
              tailling: TextButton(
                onPressed: () {
                  model.toSelectFile(context);
                },
                child: Text("选择"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AppInfoBox extends StatelessWidget {
  const AppInfoBox({super.key, required this.name, required this.style});

  final String name;
  final String github = "url";
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return GroupDecoration(label: "", children: [Text(name, style: style)]);
  }
}
