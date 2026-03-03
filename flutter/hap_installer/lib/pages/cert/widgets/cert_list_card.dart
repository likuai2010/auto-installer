import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../cert_item.dart';
import 'cert_list_item_widget.dart';

/// 证书列表卡片容器组件
///
/// 自动处理子项之间的分隔线
/// 根据 Pixso 设计稿 (item-id: 5:16608) 实现
/// 白色背景，16px 圆角，分隔线 indent 80px
class CertListCard extends StatelessWidget {
  /// 证书项数据列表
  final List<CertItem> items;

  /// 卡片外边距（默认左右16，上下8）
  final EdgeInsetsGeometry? margin;

  /// 分隔线颜色
  final Color dividerColor;

  /// 空列表时显示的提示
  final Widget? emptyWidget;

  const CertListCard({
    super.key,
    required this.items,
    this.margin,
    this.dividerColor = AppColors.dividerColor,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return emptyWidget ??
          Container(
            margin: margin,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '暂无证书',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.hintText,
                ),
              ),
            ),
          );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
            indent: 80,
          ),
          itemBuilder: (context, index) {
            return CertListItemWidget(item: items[index]);
          },
        ),
      ),
    );
  }
}
