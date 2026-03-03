import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// 证书提示卡片组件
///
/// 显示证书有效期相关的提示信息
/// 根据 Pixso 设计稿 (item-id: 5:16608) 实现
/// 白色背景，16px 圆角，内边距 16px
class CertTipCard extends StatelessWidget {
  /// 提示文本内容
  final String tipText;

  /// 卡片外边距
  final EdgeInsetsGeometry? margin;

  const CertTipCard({
    super.key,
    this.tipText =
        '提示: 未实名开发者账号证书有效14天，实名后六个月。由于华为服务器的限制，目前无法在中国大陆以外签名、安装软件，请您在中国大陆使用本软件或使用代理等方法使用中国大陆IP进行签名',
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tipText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
          height: 1.5,
        ),
      ),
    );
  }
}
