import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/viewmodels/CertViewModel.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:provider/provider.dart';

import 'cert_item.dart';
import 'widgets/cert_list_card.dart';
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
            color: AppColors.scaffoldBackground,
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
  /// [context] 构建上下文
  /// [model] 证书视图模型
  Widget _buildLoginPrompt(BuildContext context, CertViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 48,
              color: AppColors.hintText,
            ),
            SizedBox(height: 16),
            Text(
              '未登录账号',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '请先登录华为开发者账号以查看证书',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.hintText,
              ),
            ),
          ],
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
