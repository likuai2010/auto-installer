import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'cert_item.dart';
import 'cert_list_item_widget.dart';

/// 证书列表卡片容器组件
///
/// 每一项都是独立的卡片，卡片之间间距 8px
/// 根据 Pixso 设计稿实现
class CertListCard extends StatelessWidget {
  /// 证书项数据列表
  final List<CertItem> items;

  /// 卡片外边距（默认左右16，上下8）
  final EdgeInsetsGeometry? margin;

  /// 空列表时显示的提示
  final Widget? emptyWidget;

  const CertListCard({
    super.key,
    required this.items,
    this.margin,
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
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            CertListItemWidget(item: items[i]),
            if (i < items.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
