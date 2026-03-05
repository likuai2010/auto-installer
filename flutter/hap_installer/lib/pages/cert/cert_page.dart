import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/viewmodels/CertViewModel.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:provider/provider.dart';

import 'widgets/cert_list_card.dart';
import 'widgets/cert_item.dart';
import 'widgets/cert_tip_card.dart';

/// 证书管理页面
///
/// 显示证书列表，支持使用和删除证书操作
/// 根据 Pixso 设计稿 (item-id: 5:16608) 重构
class CertPage extends StatelessWidget {
  const CertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CertViewModel(),
      child: Consumer<CertViewModel>(
        builder: (context, model, child) {
          return Container(
            color: AppColors.pageBackground,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 提示卡片
                  const CertTipCard(),
                  // 证书列表卡片或未登录提示
                  if (model.isLogin)
                    CertListCard(
                      items: _buildItems(context, model),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    )
                  else
                    _buildLoginPrompt(context, model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建证书列表项
  ///
  /// [context] 构建上下文
  /// [model] 证书视图模型
  List<CertItem> _buildItems(BuildContext context, CertViewModel model) {
    return model.certInfoList
        .map((CertInfo info) => CertItem.fromCertInfo(
              info,
              model.currentId,
              onUse: () => _showUseConfirmDialog(context, model, info),
              onDelete: () => _showDeleteConfirmDialog(context, model, info),
              onLongPress: () => _showContextMenu(context, model, info),
            ))
        .toList();
  }

  /// 构建未登录提示
  ///
  /// 根据 Pixso 设计稿 (item-id: 5:17648) 实现
  /// 采用水平列表项样式，更符合 HarmonyOS 设计规范
  ///
  /// [context] 构建上下文
  /// [model] 证书视图模型
  Widget _buildLoginPrompt(BuildContext context, CertViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => viewmodel.toLogin(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 图标
              SvgPicture.asset(
                'lib/assets/account_un_login.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              // 内容区域
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '您未登录华为账号',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '请登录以继续',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              // 登录按钮
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.buttonLightBackground,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '登录账号',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.buttonLabelText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示使用证书确认对话框
  ///
  /// [context] 构建上下文
  /// [model] 证书视图模型
  /// [info] 证书信息
  void _showUseConfirmDialog(
      BuildContext context, CertViewModel model, CertInfo info) {
    showAlert(
      context,
      title: const Text('是否下载证书并应用?'),
      content: const Text('注意: 需要使用对应的p12文件, 不一致将导致签名失败(p12是自己创建的密钥)'),
      onConfirm: () {
        model.useCert(context, info);
      },
    );
  }

  /// 显示删除证书确认对话框
  ///
  /// [context] 构建上下文
  /// [model] 证书视图模型
  /// [info] 证书信息
  void _showDeleteConfirmDialog(
      BuildContext context, CertViewModel model, CertInfo info) {
    showAlert(
      context,
      title: const Text('是否删除当前证书?'),
      content: const Text('注意: 删除后此证书签名的Profile将失效'),
      onConfirm: () {
        model.deleteCert(context, info);
      },
    );
  }

  /// 显示长按上下文菜单
  ///
  /// [context] 构建上下文
  /// [model] 证书视图模型
  /// [info] 证书信息
  void _showContextMenu(
      BuildContext context, CertViewModel model, CertInfo info) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          onTap: () => _showDeleteConfirmDialog(context, model, info),
          child: const Text('删除'),
        ),
      ],
    );
  }
}
