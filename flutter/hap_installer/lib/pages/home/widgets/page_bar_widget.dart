import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// 页面标题栏组件
///
/// 可复用的页面顶部标题栏，遵循 Material Design 3 规范
/// 设计规范：高度64px, 内边距horizontal 16px, vertical 8px
/// 标题样式：24px Medium, 颜色 rgb(29, 27, 32)
class PageBarWidget extends StatelessWidget {
  /// 页面标题
  final String title;

  /// 背景颜色
  final Color backgroundColor;

  const PageBarWidget({
    super.key,
    required this.title,
    this.backgroundColor = AppColors.pageBarBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.pageBarTitle,
        ),
      ),
    );
  }
}
