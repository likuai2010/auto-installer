import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
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
        if (model.loadingAppList) {
          return Center(child: CircularProgressIndicator());
        }
        return model.appList.appList.isNotEmpty
            ? ListView.builder(
                itemCount: model.appList.appList.length,
                itemBuilder: (_, i) =>
                    DebugAppItem(info: model.appList.appList[i]),
              )
            : const Center(child: Text("没有调试的APP"));
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

  title() {
    if (info.appInfo == null) {
      return "${info.appInfo?.label ?? "未知"} (${info.packageName})";
    }
    return "${info.appInfo?.label ?? "未知"} \n(${info.appInfo?.version} ${info.appInfo?.deviceType})";
  }

  time() {
    var endTime = info.certEndTime;
    if (endTime == null && info.installTime != null) {
      endTime = info.installTime!.add(Duration(days: 180));
    }
    var isAfter = endTime != null ? DateTime.now().isAfter(endTime) : false;
    return "安装时间: ${info.installTime ?? "未知"} \n过期时间: ${endTime ?? "未知"} ${isAfter ? "已过期" : ""}";
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
              tailling: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCapsuleButton(
                      context: context,
                      isLoading: model.loadingGameMode,
                      label: info.isGame ? "游戏模式" : "应用模式",
                      onTap: () async {
                        if (info.isGame) {
                          showAlert(context,
                              title: Text("关闭游戏模式"),
                              content: Text("需要重启手机才能生效"),
                              onConfirm: () async {
                            await model.setGame(info, context);
                          });
                        } else {
                          showAlert(context,
                              title: Text("切换游戏模式"),
                              content: Text(
                                  "目前不支持支持328以上系统版本, 切换游戏模式后, 长按底部状态条开启高性能开关"),
                              onConfirm: () async {
                            await model.setGame(info, context);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (info.appInfo != null && info.canReInstall) ...[
                          _buildCapsuleButton(
                            context: context,
                            isLoading: model.loadingReinstall,
                            label: "延期",
                            onTap: model.loadingReinstall
                                ? null
                                : () {
                                    showConfirm(
                                      context,
                                      title: Text("确定延期?"),
                                      content: Text(
                                          "目前支持500m以下的应用. \n创建新证书将自动删除当前证书. 已安装的其他应用不受影响"),
                                      confirmLabel: "创建新证书",
                                      cancelLabel: "使用当前证书",
                                      onConfirm: () {
                                        model.reInstall(
                                            context, info.appInfo!, true);
                                      },
                                      onCancel: () {
                                        model.reInstall(
                                            context, info.appInfo!, false);
                                      },
                                    );
                                  },
                          ),
                          const SizedBox(width: 6),
                        ],
                        _buildCapsuleButton(
                          context: context,
                          isLoading: false,
                          label: "卸载",
                          onTap: () {
                            showAlert(context, title: Text("确定卸载?"),
                                onConfirm: () {
                              model.unInstall(info.appInfo!);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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

/// 构建胶囊形按钮，风格与首页设置项按钮保持一致
///
/// [isLoading] 为 true 时显示加载指示器
/// [label] 按钮文字
/// [onTap] 点击回调，为 null 时按钮禁用
Widget _buildCapsuleButton({
  required BuildContext context,
  required bool isLoading,
  required String label,
  VoidCallback? onTap,
}) {
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
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.brandDynamic(context)),
          ),
        ),
      ),
    );
  }
  final buttonEnabled = onTap != null;
  final disabledBgColor =
      AppColors.brandDynamic(context).withValues(alpha: 0.04);
  final disabledTextColor =
      AppColors.brandDynamic(context).withValues(alpha: 0.5);
  return SizedBox(
    width: 80,
    height: 30,
    child: InkWell(
      onTap: onTap,
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

class AppIconItem extends StatelessWidget {
  const AppIconItem({super.key, required this.info});
  final HapInfo info;

  iconPath(EcoViewModel model, String packageName, String icon) {
    return path.join(model.debugPath, packageName.replaceAll(".", "_"), icon);
  }

  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(builder: (context, model, _) {
      return Stack(
        children: info.icon.map((path) {
          if (File(iconPath(model, info.packageName, path)).existsSync()) {
            if (path.contains("svg")) {
              return SvgPicture.file(
                File(iconPath(model, info.packageName, path)),
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
                  File(iconPath(model, info.packageName, path)),
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
    });
  }
}
