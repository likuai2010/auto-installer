import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'team_device_item.dart';
import 'team_device_item_widget.dart';

/// 团队设备卡片容器组件
///
/// 带标题栏的卡片容器，用于包装列表项
/// 卡片背景：白色
/// 卡片圆角：16px
/// 卡片外边距：水平 16px，垂直 8px
class TeamDeviceCard extends StatelessWidget {
  /// 卡片标题
  final String title;

  /// 列表项数据
  final List<TeamDeviceItem> items;

  /// 标题栏右侧操作按钮文本（如"清除"）
  final String? actionText;

  /// 标题栏右侧操作按钮点击回调
  final VoidCallback? onAction;

  /// 空状态提示文本
  final String emptyText;

  const TeamDeviceCard({
    super.key,
    required this.title,
    required this.items,
    this.actionText,
    this.onAction,
    this.emptyText = '暂无数据',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          _buildHeader(),
          // 列表内容或空状态
          if (items.isEmpty)
            _buildEmptyState()
          else
            _buildItemList(),
        ],
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.tertiaryText,
            ),
          ),
          const Spacer(),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(40, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.hintText,
          ),
        ),
      ),
    );
  }

  /// 构建列表项
  Widget _buildItemList() {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          TeamDeviceItemWidget(
            item: items[i],
            showDivider: i < items.length - 1,
          ),
      ],
    );
  }
}
