// TODO 未使用到的文件，后续考虑删除

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/pages/user_guide_page.dart';
import 'package:hap_installer/widget/BuildHnpBox.dart';
import 'package:hap_installer/widget/FileDropArea.dart';
import 'package:hap_installer/widget/common.dart';

import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/pages/history/debug_detail_page.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatelessWidget {
  static const platform = MethodChannel("com.xiaobai.hap_instaler/openFile");
  BuildContext? context;
  IndexPage({super.key}) {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "openFile") {
        var url = call.arguments['url'];
        print("openFile MethodCall ${url}");
        if (context != null) {
          viewmodel.openFile(context!, url);
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
          const DebugSteps(),
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
                      MaterialPageRoute(
                          builder: (_) => const DebugDetailPage()),
                    );
                    model.installHap(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("开始调试"),
                  ),
                ),
              );
            },
          ),
          Container(height: 20),
          Consumer<EcoViewModel>(
            builder: (context, model, child) {
              if (model.currentDevice == null) {
                return Container();
              }
              return Center(
                child: FilledButton(
                  onPressed: () {
                    model.toGitStore();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("下载小白盒子"),
                  ),
                ),
              );
            },
          ),
          Platform.isMacOS ? const BuildHnp() : Container()
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
      nickname += "(未开发者实名)";
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
              leading: const Icon(Icons.person),
              title: userName(model),
              subTitle: "华为账号",
              tailling: TextButton(
                onPressed: () {
                  viewmodel.toLogin(context);
                },
                child: !model.loading
                    ? Text(model.isLogin ? "切换账号" : "登录账号")
                    : const CircularProgressIndicator(value: null),
              ),
            ),
            model.teamList.isEmpty && model.isLogin
                ? ListItem(
                    leading: const Icon(Icons.person),
                    title: "开发者认证",
                    subTitle: "该账号未进行开发者认证",
                    tailling: TextButton(
                      onPressed: () {
                        viewmodel.toAuthDev(context);
                      },
                      child: const Text("开发者认证"),
                    ),
                  )
                : Container(),
            ListItem(
              leading: const Icon(
                Icons.signal_wifi_off_outlined,
              ), //Icon(Icons.signal_wifi_4_bar)
              title: model.currentDevice ?? "未连接",
              subTitle:
                  model.currentDevice?.contains(".") == true ? "无线连接" : "USB连接",
              tailling: TextButton(
                // USB连接时禁用按钮（地址不含"."），无线连接时可点击
                onPressed: model.currentDevice != null &&
                        !model.currentDevice!.contains(".")
                    ? null
                    : () {
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
                child: !model.deviceLoaing
                    ? Text(model.currentDevice != null ? "切换设备" : "连接设备")
                    : const CircularProgressIndicator(value: null),
              ),
            ),
            FileDropArea(
              child: ListItem(
                leading:
                    const Icon(Icons.apps_outage), //Icon(Icons.apps_outlined)
                title: model.hapInfo?.packageName == null
                    ? "未选择"
                    : "包名: ${model.hapInfo?.packageName} 支持设备: ${model.hapInfo?.deviceType}",
                subTitle: "文件格式: .app,.hap,.hsp",
                tailling: TextButton(
                  onPressed: () {
                    model.toSelectFile(context);
                  },
                  child: !model.fileLoading
                      ? Text(model.hapInfo?.packageName != null ? "更换" : "选择")
                      : const CircularProgressIndicator(value: null),
                ),
              ),
              onSearch: (file) {
                if (file.path != null) {
                  model.openFile(context, file.path!);
                }
              },
            ),
            // TextButton(
            //       onPressed: () {
            //         model.testSignHap(context);
            //       },
            //       child:
            //           !model.fileLoading
            //               ? const Text("test sign")
            //               : const CircularProgressIndicator(value: null),
            //     )
            // Platform.isAndroid
            //     ? TextButton(
            //       onPressed: () {
            //         model.exportLog();
            //       },
            //       child:
            //           !model.fileLoading
            //               ? Text("导出Hdc日志")
            //               : CircularProgressIndicator(value: null),
            //     )
            //     : Container(),
          ],
        );
      },
    );
  }
}

class BuildHnp extends StatelessWidget {
  const BuildHnp({super.key});

  @override
  Widget build(BuildContext context) {
    if (ohosAdapter.isOhos) {
      return Container();
    }
    return Consumer<EcoViewModel>(
      builder: (context, model, child) {
        return GroupDecoration(children: [
          ListItem(
            leading: const Icon(Icons.apps_outage), //Icon(Icons.apps_outlined)
            title: "构建hnp包",
            subTitle: "支持构建hnp到hap进行安装(仅鸿蒙pc)",
            tailling: TextButton(
              onPressed: () {
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
                        child: BuildHnpBox(
                            // ip: model.ip,
                            // port: model.port,
                            ),
                      ),
                    );
                  },
                );
              },
              child: const Text("开始构建"),
            ),
          )
        ]);
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
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  openByUrl("https://github.com/likuai2010/auto-installer/");
                },
                child: const Text("GitHub"),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  toPage(context, (_) => const UserGuidePage());
                },
                child: const Text("使用教程"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
