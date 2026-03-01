import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/pages/debug_detail_page.dart';
import 'package:hap_installer/pages/home/home_setting_item.dart';
import 'package:hap_installer/pages/user_guide_page.dart';
import 'package:hap_installer/viewmodels/HomeViewModel.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:provider/provider.dart';

import 'widgets/app_info_card.dart';
import 'widgets/home_setting_card.dart';

/// 首页
///
/// 根据 Pixso 设计稿实现
/// 背景色: rgba(241, 243, 245, 1)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (context, vm, _) {
        return Container(
          height: double.infinity,
          color: AppColors.scaffoldBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 应用信息卡片
                AppInfoCard(
                  buttons: [
                    AppInfoButton(
                      label: 'GitHub',
                      icon: Icons.code,
                      onTap: () => homeViewModel.openGitHub(),
                    ),
                    AppInfoButton(
                      label: '赞助我们',
                      icon: Icons.favorite,
                      onTap: () => homeViewModel.openSponsor(),
                    ),
                    AppInfoButton(
                      label: '使用教程',
                      icon: Icons.menu_book_outlined,
                      onTap: () => _openTutorial(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 设置列表卡片
                HomeSettingCard(
                  items: _buildSettingItems(context, vm),
                ),
                // 开始调试按钮（条件显示）
                if (_canStartDebug(vm)) ...[
                  const SizedBox(height: 8),
                  _buildStartButton(context, vm),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建设置项列表
  ///
  /// 根据 EcoViewModel 状态生成设置项数据
  List<HomeSettingItem> _buildSettingItems(
      BuildContext context, EcoViewModel vm) {
    return [
      // 1. 华为账号
      HomeSettingItem(
        title: vm.isLogin ? (vm.userInfo?.nickName ?? '已登录') : '未登录',
        description: '华为账号',
        icon: 'lib/assets/account_un_login.svg',
        activeIcon: 'lib/assets/account_login.svg',
        buttonLabel: vm.isLogin ? '更换账号' : '登录账号',
        isActive: vm.isLogin,
        onButtonTap: () => vm.toLogin(context), // 始终可点击
      ),
      // 2. 设备连接
      HomeSettingItem(
        title: vm.currentDevice ?? '未连接',
        description: '设备',
        icon: 'lib/assets/link_off.svg',
        activeIcon: 'lib/assets/wifi_success.svg',
        buttonLabel: vm.currentDevice != null ? '更换地址' : '无线调试',
        isActive: vm.currentDevice != null,
        isVisible: vm.isLogin,
        // USB连接时禁用（地址不含"."），无线连接时可点击
        onButtonTap: vm.currentDevice != null &&
                !vm.currentDevice!.contains('.')
            ? null
            : () => vm.toConnect(context, () {}),
      ),
      // 3. 安装包选择
      HomeSettingItem(
        title: vm.hapInfo?.packageName ?? '未选择',
        description: '软件安装包',
        icon: 'lib/assets/file_un_select.svg',
        activeIcon: 'lib/assets/file_select.svg',
        buttonLabel: vm.hapInfo != null ? '更换' : '选择',
        isActive: vm.hapInfo != null,
        isVisible: vm.currentDevice != null,
        onButtonTap: () => vm.toSelectFile(context), // 始终可点击
      ),
    ];
  }

  /// 判断是否可以开始调试
  ///
  /// 条件：已登录 + 设备已连接 + 已选择安装包
  bool _canStartDebug(EcoViewModel vm) {
    return vm.isLogin && vm.currentDevice != null && vm.hapInfo != null;
  }

  /// 构建开始调试按钮
  Widget _buildStartButton(BuildContext context, EcoViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: () => _startDebug(context, vm),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Center(
            child: Text(
              '开始调试',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 打开使用教程
  ///
  /// 跳转到用户引导页面
  Future<void> _openTutorial(BuildContext context) async {
    toPage(context, (_) => const UserGuidePage());
  }

  /// 开始调试
  ///
  /// 将 HAP 安装到设备
  void _startDebug(BuildContext context, EcoViewModel vm) {
    // 导航到调试详情页
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DebugDetailPage()),
    );
    // 安装 HAP 到设备
    vm.installHap(context);
  }
}
