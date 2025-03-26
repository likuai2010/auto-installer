import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/pages/user_guide_page.dart';
import 'package:hap_installer/widget/common.dart';

import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/pages/debug_detail_page.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatelessWidget {
  static const platform = MethodChannel("com.xiaobai.hap_instaler/openFile");
  BuildContext? context;
  IndexPage({super.key}) {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "openFile") {
        print("openFile ${call.arguments.toString()}");
        if (call.arguments is Map<String, dynamic>) {
          var url = call.arguments['url'];
          if (context != null) {
            viewmodel.openFile(context!, url);
          }
        } else {
          print('Arguments are not in the expected format');
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
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
                  child: const Padding(
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
  const DebugSteps({super.key});
  String userName(EcoViewModel model) {
    var nickname = model.userInfo?.nickName ?? "匿名";
    if (model.teamList.isEmpty) {
      nickname += "(未实名)";
    }
    return model.isLogin ? nickname : "未登录";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (context, model, child) {
        return GroupDecoration(
          children: [
            ListItem(
              leading: Icon(Icons.person),
              title: userName(model),
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
                  model.toConnect(context, () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      constraints: const BoxConstraints(maxHeight: 600),
                      builder: (context) {
                        return AnimatedPadding(
                          padding: MediaQuery.of(context).viewInsets,
                          duration: const Duration(milliseconds: 100),
                          child: SizedBox(
                            height: 300,
                            child: ConnectDeviceBox(
                              ip: model.ip,
                              port: model.port,
                            ),
                          ),
                        );
                      },
                    );
                  });
                },
                child:
                    !model.deviceLoaing
                        ? Text("连接设备")
                        : CircularProgressIndicator(value: null),
              ),
            ),
            ListItem(
              leading: Icon(Icons.apps_outage), //Icon(Icons.apps_outlined)
              title: model.hapInfo?.packageName ?? "未选择",
              subTitle: "支持.app,.hap,.hsp",
              tailling: TextButton(
                onPressed: () {
                  model.toSelectFile(context);
                },
                child:
                    !model.fileLoading
                        ? Text("选择")
                        : CircularProgressIndicator(value: null),
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
    return GroupDecoration(
      label: "",
      children: [
        Center(child: Text(name, style: style)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  openByUrl("https://github.com/likuai2010/auto-installer/");
                },
                child: Text("GitHub"),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  toPage(context, (_) => UserGuidePage());
                },
                child: Text("使用教程"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
