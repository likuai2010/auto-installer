import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';

/// 证书提示卡片组件
///
/// 显示证书有效期相关的提示信息
/// 根据 Pixso 设计稿 (item-id: 5:16912) 实现
/// 水平布局：左侧图标 + 右侧内容（标题 + 正文）
/// 容器内边距: 16px
/// 图标与内容间距: 16px
/// 标题与正文间距: 8px
class CertTipCard extends StatelessWidget {
  /// 标题文本
  final String headline;

  /// 提示内容列表（每个元素为一段）
  final List<String> contentLines;

  /// 卡片外边距
  final EdgeInsetsGeometry? margin;

  /// 图标资源路径
  final String iconPath;

  const CertTipCard({
    super.key,
    this.headline = '温馨提示',
    this.contentLines = const [
      '1.未进行开发者认证的华为账号证书有效期仅14天，进行开发者实名认证后可提升至180天（约6个月）。',
      '注意：华为账号实名与开发者认证不通用，需要单独进行。',
      '2.受华为签名服务器限制，目前无法在中国大陆外签名、安装软件，请您在中国大陆使用本软件或使用代理等方式使用中国大陆IP进行签名。',
    ],
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.iconPath = 'lib/assets/tips.svg',
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧图标
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 16),
          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  headline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    height: 24 / 16, // line-height: 24px
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                // 正文内容
                Text(
                  contentLines.join('\n'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    height: 20 / 14, // line-height: 20px
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
