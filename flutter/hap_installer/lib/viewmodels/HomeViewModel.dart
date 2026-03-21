import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/pages/history/debug_detail_page.dart';
import 'package:hap_installer/pages/user_guide_page.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/widget/common.dart';

/// 首页视图模型
///
/// 负责首页相关的业务逻辑，包括打开外部链接等
class HomeViewModel {
  /// 打开 GitHub 仓库页面
  Future<void> openGitHub() async {
    await openByUrl('https://github.com/likuai2010/auto-installer');
  }

  /// 打开赞助页面
  Future<void> openSponsor() async {
    await openByUrl('https://afdian.com/a/xiaobaigroup');
  }

  /// 打开使用教程
  /// 跳转到用户引导页面
  Future<void> openTutorial() async {
    await openByUrl('https://gitee.com/xiaobai-studio/XiaoBaiGuide');
  }

  /// 开始调试
  ///
  /// 将 HAP 安装到设备
  void startDebug(BuildContext context, EcoViewModel vm) {
    // 导航到调试详情页
    toPage(context, (_) => const DebugDetailPage());
    // 安装 HAP 到设备
    if (vm.hapInfo != null){
      vm.installHap(vm.hapInfo!);
    }
  }
}

final homeViewModel = HomeViewModel();
