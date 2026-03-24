import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/ThemeViewModel.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/pages/privacy_page.dart';
import 'package:hap_installer/pages/user_guide_page.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/pages/acl/acl_page.dart';
import 'package:hap_installer/pages/terminal/terminal_page.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import 'widgets/more_card.dart';
import 'widgets/more_item.dart';

/// 显示温馨提示弹窗
void showTips(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.compBackgroundPrimaryDynamic(context),
        title: const Text('温馨提示'),
        content: const Text(
          '使用本工具安装App需要打开"开发者模式"，当您关闭"开发者模式"后，所有使用本工具安装的App都将失效。请前往设置-关于本机页面连点5次"软件版本"以开启开发者模式。具体安装步骤请查看更多-使用教程',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              '知道了',
              style: TextStyle(color: AppColors.fontSecondaryDynamic(context)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          if (!Platform.isLinux)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandDynamic(context),
                foregroundColor: AppColors.buttonTextPrimary,
              ),
              child: const Text('查看使用教程'),
              onPressed: () {
                Navigator.of(ctx).pop();
                toPage(context, (_) => const UserGuidePage());
              },
            ),
        ],
      );
    },
  );
}

/// 更多页面
///
/// 根据 Pixso 设计稿 (item-id: 5:19773) 重构
/// 采用卡片式分组布局，使用 MoreCard 和 MoreItemWidget 组件
class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  /// 应用版本
  final String _appVersion = '3.1.0';

  /// 自动连接开关状态
  bool _autoConnect = true;

  @override
  void initState() {
    super.initState();
    _loadAutoConnect();
  }

  /// 加载自动连接设置
  Future<void> _loadAutoConnect() async {
    final value = await getAutoConnect();
    if (mounted) {
      setState(() => _autoConnect = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeViewModel>();
    return Container(
      color: AppColors.pageBackgroundDynamic(context),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // 工具类
          MoreCard(items: _buildToolItems()),
          // 设置类
          MoreCard(items: _buildSettingItems()),
          // 显示类
          MoreCard(items: _buildDisplayItems()),
          // 帮助类
          MoreCard(items: _buildHelpItems()),
          // 关于类
          MoreCard(items: _buildAboutItems()),
        ],
      ),
    );
  }

  /// 构建工具类列表项
  List<MoreItem> _buildToolItems() {
    return [
      MoreItem(
        title: '命令行工具',
        icon: 'lib/assets/more_console.svg',
        onTap: () {
          toPage(context, (_) => const TerminalPage());
        },
      ),
      MoreItem.withIcon(
        title: 'ACL权限',
        iconData: Icons.settings_cell,
        onTap: () {
          toPage(context, (_) => const AclPage());
        },
      ),
    ];
  }

  /// 构建设置类列表项
  List<MoreItem> _buildSettingItems() {
    final theme = context.read<ThemeViewModel>();
    return [
      MoreItem(
        title: '清空数据',
        icon: 'lib/assets/more_cleanCache.svg',
        onTap: () {
          showAlert(
            context,
            title: const Text('是否所有数据?'),
            content: const Text('清空后,将重新登录和连接设备'),
            onConfirm: () {
              viewmodel.clearAll(context);
            },
          );
        },
      ),
      MoreItem(
        title: '重置证书配置',
        icon: 'lib/assets/more_resetcer.svg',
        onTap: () {
          showAlert(
            context,
            title: const Text('是否还原默认证书配置?'),
            content: const Text('使用自定义证书配置后，可通过此功能还原默认值证书配置'),
            onConfirm: () {
              viewmodel.resetSignConfig();
            },
          );
        },
      ),
       MoreItem(
        title: '自动无线调试端口',
        icon: 'lib/assets/more_dark.svg',
        itemType: MoreItemType.switch_,
        switchValue: theme.autoPort,
        onSwitchChanged: (value) {
          showAlert(context, title: const Text("无线调试端口"), content: const Text(
            "连接设备成功后将设置无线调试端口为(12345). 后续无需输入端口自动连接"
          ), onConfirm: () => theme.setAutoPort(value));
        },
      ),
      MoreItem.withIcon(
        title: '查看目录',
        iconData: Icons.folder_outlined,
        onTap: () async {
          final appDir = await getAppDir();
          final hdc = await getHdcDir();
          final temp = await getTempDir();
          if (mounted) {
            showAlert(
              context,
              title: const Text('缓存路径'),
              content: SizedBox(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText('appDir: $appDir'),
                    SelectableText('tempDir: $temp'),
                    SelectableText('hdcDir: $hdc'),
                  ],
                ),
              ),
            );
          }
        },
      ),
      // 仅桌面平台显示（暂时屏蔽）
      /* if (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
        MoreItem.withIcon(
          title: '指定JavaHome',
          iconData: Icons.coffee_outlined,
          onTap: () {
            viewmodel.changeJaveHome(context);
          },
        ), */
    ];
  }

  /// 构建显示类列表项（深色模式相关）
  List<MoreItem> _buildDisplayItems() {
    final theme = context.read<ThemeViewModel>();
    return [
      MoreItem(
        title: '随系统切换深色模式',
        icon: 'lib/assets/more_autoMode.svg',
        itemType: MoreItemType.switch_,
        switchValue: theme.followSystemDarkMode,
        onSwitchChanged: (value) {
          theme.setFollowSystemDarkMode(value);
        },
      ),
      MoreItem(
        title: '深色模式',
        icon: 'lib/assets/more_dark.svg',
        itemType: MoreItemType.switch_,
        switchValue: theme.darkMode,
        onSwitchChanged: (value) {
          theme.setDarkMode(value);
        },
      ),
    ];
  }

  /// 构建帮助类列表项
  List<MoreItem> _buildHelpItems() {
    return [
      MoreItem(
        title: '温馨提示',
        icon: 'lib/assets/more_tips.svg',
        onTap: () => showTips(context),
      ),
      // 非 Linux 平台显示使用教程
      if (!Platform.isLinux)
        MoreItem(
          title: '使用教程',
          icon: 'lib/assets/more_help.svg',
          onTap: () {
            toPage(context, (_) => const UserGuidePage());
          },
        ),
      // 仅 Android 平台显示免责声明
      if (Platform.isAndroid)
        MoreItem.withIcon(
          title: '免责声明',
          iconData: Icons.privacy_tip_outlined,
          onTap: () {
            toPage(context, (_) => const PrivacyPage());
          },
        ),
    ];
  }

  /// 构建关于类列表项
  List<MoreItem> _buildAboutItems() {
    return [
      MoreItem(
        title: '应用版本',
        icon: 'lib/assets/tips.svg',
        itemType: MoreItemType.text,
        trailingText: _appVersion,
      ),
    ];
  }
}
