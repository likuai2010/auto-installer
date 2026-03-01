import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../home_setting_item.dart';
import 'home_setting_item_widget.dart';

/// 首页设置卡片容器组件
///
/// 自动处理子项之间的分隔线
/// 根据 Pixso 设计稿 (item-id: 5:16387) 实现
/// 分隔线: 1px，颜色 rgba(0, 0, 0, 0.1)
class HomeSettingCard extends StatelessWidget {
  /// 设置项数据列表
  final List<HomeSettingItem> items;

  /// 卡片外边距（默认左右16，上下8）
  final EdgeInsetsGeometry? margin;

  /// 分隔线颜色
  final Color dividerColor;

  const HomeSettingCard({
    super.key,
    required this.items,
    this.margin,
    this.dividerColor = AppColors.dividerColor,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleItems.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
            indent: 80,
          ),
          itemBuilder: (context, index) {
            return HomeSettingItemWidget(item: visibleItems[index]);
          },
        ),
      ),
    );
  }
}
