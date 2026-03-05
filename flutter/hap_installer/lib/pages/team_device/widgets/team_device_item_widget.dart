import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'team_device_item.dart';

/// 团队设备列表项组件
///
/// 用于显示团队、设备、历史连接的列表项
/// 高度: 76px
/// 左侧图标: 24x24，padding 16px（无背景）
/// 选中状态: 显示绿色勾选图标
/// 历史项: 支持删除按钮
class TeamDeviceItemWidget extends StatelessWidget {
  /// 列表项数据
  final TeamDeviceItem item;

  /// 是否显示下边框
  final bool showDivider;

  /// 下边框颜色
  final Color dividerColor;

  const TeamDeviceItemWidget({
    super.key,
    required this.item,
    this.showDivider = true,
    this.dividerColor = AppColors.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: InkWell(
        onTap: item.onTap,
        child: DecoratedBox(
          decoration: showDivider
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                )
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 左侧图标（无背景容器）
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  child: _buildIcon(),
                ),
                // 文字区域
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleTextDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.descriptionTextLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // 右侧区域：选中勾选或删除按钮
                _buildTrailing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建左侧图标
  ///
  /// 根据类型使用不同的 Material Icons 作为 fallback
  Widget _buildIcon() {
    final iconData = _getIconData();
    return Icon(
      iconData,
      size: 24,
      color: AppColors.iconColor,
    );
  }

  /// 根据类型获取图标
  IconData _getIconData() {
    switch (item.itemType) {
      case TeamDeviceItemType.team:
        return Icons.group_outlined;
      case TeamDeviceItemType.device:
        return Icons.devices_outlined;
      case TeamDeviceItemType.history:
        return Icons.history_outlined;
    }
  }

  /// 构建右侧区域
  ///
  /// 选中状态显示绿色勾选图标
  /// 历史项支持删除按钮
  Widget _buildTrailing() {
    // 选中状态：显示绿色勾选图标
    if (item.isSelected) {
      return const Icon(
        Icons.check_circle,
        size: 24,
        color: AppColors.success,
      );
    }

    // 历史项：显示删除按钮
    if (item.itemType == TeamDeviceItemType.history && item.onDelete != null) {
      return InkWell(
        onTap: item.onDelete,
        borderRadius: BorderRadius.circular(20),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.delete_outline,
            size: 20,
            color: AppColors.descriptionTextLight,
          ),
        ),
      );
    }

    // 默认：无右侧内容
    return const SizedBox.shrink();
  }
}
