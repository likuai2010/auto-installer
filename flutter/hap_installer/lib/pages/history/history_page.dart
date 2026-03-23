import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:intl/intl.dart';
import 'package:ohos_adapter/ohos_adapter.dart';
import 'debug_detail_page.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, model, child) {
        if(model.loadingAppList){
          return  const Center(child: CircularProgressIndicator());
        }
        return model.appList.appList.isNotEmpty ? ListView.builder(
                  itemCount: model.appList.appList.length,
                  itemBuilder: (_, i) =>
                      DebugAppItem(info: model.appList.appList[i]),
                ) : const Center(child: Text("没有调试的APP"));
      },
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.info});
  final DebugHistory info;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HistoryViewModel>(context);
  
    return GroupDecoration(
      children: [
        ListItem(
          leading: const Icon(Icons.check_circle),
          title: info.hapInfo.packageName,
          subTitle: info.hapInfo.version ?? "0.0.0",
          tailling: Container(),
          onClick: () {
            model.selectDebugHistory(info);
            toPage(context, (_) => const DebugDetailPage());
          },
        ),
      ],
    );
  }
}

class DebugAppItem extends StatelessWidget {
  const DebugAppItem({super.key, required this.info});
  final DebugApp info;

  /// 获取应用标题
  String title() {
    if (info.appInfo == null) {
      return "${info.appInfo?.label ?? "未知"} (${info.packageName})";
    }
    return "${info.appInfo?.label ?? "未知"} \n(${info.appInfo?.version})";
  }

  /// 获取安装和过期时间信息
  String time() {
    var endTime = info.certEndTime;
    if (endTime == null && info.installTime != null) {
      endTime = info.installTime!.add(Duration(days: 180));
    }
    var isAfter = endTime != null ? DateTime.now().isAfter(endTime) : false;
    String formatted1 = DateFormat('yyyy-MM-dd').format(endTime!);
    String formatted2 = DateFormat('yyyy-MM-dd').format(info.installTime!);
    return "安装时间: $formatted2 \n过期时间: $formatted1 ${isAfter ? "已过期" : ""}";
  }

  /// 构建胶囊形按钮
  ///
  /// 按钮尺寸: 80x30
  /// 圆角: 100（胶囊形）
  /// 背景: rgba(10,89,247,0.08)
  /// 文字: 蓝色 12px
  /// 加载中: 显示圆环加载条
  Widget _buildCapsuleButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    // 加载中状态
    if (isLoading) {
      return SizedBox(
        width: 80,
        height: 30,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandDynamic(context)),
            ),
          ),
        ),
      );
    }

    final buttonEnabled = onTap != null;
    final disabledBgColor = AppColors.brandDynamic(context).withValues(alpha: 0.04);
    final disabledTextColor = AppColors.brandDynamic(context).withValues(alpha: 0.5);

    return SizedBox(
      width: 80,
      height: 30,
      child: InkWell(
        onTap: buttonEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonEnabled
                ? AppColors.buttonLightBackgroundDynamic(context)
                : disabledBgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: buttonEnabled
                  ? AppColors.buttonLabelTextDynamic(context)
                  : disabledTextColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, model, _) {
        return GroupDecoration(
          children: [
            ListItem(
              leading: info.appInfo == null
                  ? const Icon(Icons.check_circle)
                  : AppIconItem(info: info.appInfo!),
              title: title(),
              subTitle: time(),
              tailling: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 顶部：游戏模式/应用模式 + 日程提醒（仅 HarmonyOS）
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCapsuleButton(
                        context: context,
                        label: info.isGame ? "游戏模式" : "应用模式",
                        isLoading: model.loadingGameMode,
                        onTap: () async {
                          if (info.isGame) {
                            showAlert(context, title: Text("关闭游戏模式"), content: Text("需要重启手机才能生效"),
                                onConfirm: () async {
                              await model.setGame(info, context);
                            });
                          } else {
                            showAlert(
                                context,
                                title: Text("切换游戏模式"),
                                content: Text("目前不支持支持328以上系统版本, 切换游戏模式后, 长按底部状态条开启高性能开关"),
                                onConfirm: () async {
                              await model.setGame(info, context);
                            });
                          }
                        },
                      ),
                      if (info.appInfo != null && info.canReInstall && ohosAdapter.isOhos) ...[
                        SizedBox(width: 6),
                        _buildCapsuleButton(
                          context: context,
                          label: "日程提醒",
                          onTap: () => {
                            showAlert(context, title: Text("确定添加日程提醒?"), onConfirm: () {
                              model.addCalendar(context, info);
                            })
                          },
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6),
                  // 底部：续期 + 卸载
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (info.appInfo != null && info.canReInstall)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _buildCapsuleButton(
                            context: context,
                            label: "续期",
                            isLoading: model.loadingReinstall,
                            onTap: !model.loadingReinstall
                                ? () => {
                                      showConfirm(
                                          context,
                                          title: Text("确定续期?"),
                                          content: Text("目前支持500m以下的应用. \n创建新证书将自动删除当前证书. 已安装的其他应用不受影响"),
                                          confirmLabel: "创建新证书",
                                          cancelLabel: "使用当前证书",
                                          onConfirm: () {
                                            model.reInstall(context, info.appInfo!, true);
                                          },
                                          onCancel: () {
                                            model.reInstall(context, info.appInfo!, false);
                                          })
                                    }
                                : null,
                        ),
                        ),
                      _buildCapsuleButton(
                        context: context,
                        label: "卸载",
                        onTap: () => {
                          showAlert(context, title: Text("确定卸载?"), onConfirm: () {
                            model.unInstall(info.packageName);
                          })
                        },
                      ),
                    ],
                  ),
                ],
              ),
              onClick: () {
                // toPage(context, (_) => const DebugDetailPage());
              },
            ),
          ],
        );
      },
    );
  }
}

class AppIconItem extends StatelessWidget {
  const AppIconItem({super.key, required this.info});
  final HapInfo info;

  /// 获取图标文件路径
  String iconPath(EcoViewModel model, String packageName, String icon) {
    final tempPath = path.join( model.debugPath, packageName.replaceAll(".", "_"), icon);
    final appPath = path.join(model.historyViewModel?.getHistoryDir() ?? model.debugPath, packageName.replaceAll(".", "_"), icon);
    if(File(appPath).existsSync()){
      return appPath;
    }
    return tempPath;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (context, model, _) {
        return Stack(
          children: info.icon.map((iconPathStr) {
            if (File(iconPath(model, info.packageName, iconPathStr)).existsSync()) {
              if (iconPathStr.contains("svg")) {
                return SvgPicture.file(
                  File(iconPath(model, info.packageName, iconPathStr)),
                  colorFilter: ColorFilter.mode(
                    AppColors.iconPrimaryDynamic(context),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(iconPath(model, info.packageName, iconPathStr)),
                    width: 24,
                    height: 24,
                  ),
                ),
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}