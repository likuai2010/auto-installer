import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'home_setting_item.dart';
import 'home_setting_item_widget.dart';

/// 首页设置卡片容器组件
///
/// 自动处理子项之间的分隔线
/// 根据 Pixso 设计稿 (item-id: 5:16382) 实现
/// 分隔线: 下边框样式，1px，颜色 rgba(0, 0, 0, 0.1)，左边距 80px
class HomeSettingCard extends StatelessWidget {
  /// 设置项数据列表
  final List<HomeSettingItem> items;

  /// 卡片外边距（默认左右16，上下8）
  final EdgeInsetsGeometry? margin;

  const HomeSettingCard({
    super.key,
    required this.items,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    // 过滤不可见的项
    final visibleItems = items.where((item) => item.isVisible).toList();

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.compBackgroundPrimaryDynamic(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            return HomeSettingItemWidget(
              item: visibleItems[index],
              showDivider: index < visibleItems.length - 1,
            );
          },
        ),
      ),
    );
  }
}
