import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';

/// 打开 GitHub 仓库链接（顶级函数，可用于 const 上下文）
Future<void> openGitHub() async {
  const url = 'https://github.com/likuai2010/auto-installer';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

/// 打开赞助我们页面链接（顶级函数，可用于 const 上下文）
Future<void> openSponsor() async {
  const url = 'https://github.com/likuai2010/auto-installer';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

/// 打开使用教程页面链接（顶级函数，可用于 const 上下文）
Future<void> openTutorial() async {
  const url = 'https://github.com/likuai2010/auto-installer';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

/// 应用信息按钮数据类
class AppInfoButton {
  /// 按钮标签
  final String label;

  /// 按钮图标
  final IconData icon;

  /// 点击回调
  final Future<void> Function()? onTap;

  const AppInfoButton({
    required this.label,
    this.icon = Icons.code,
    this.onTap,
  });
}

/// 应用信息卡片组件
///
/// 显示应用图标、名称、描述和操作按钮
class AppInfoCard extends StatelessWidget {
  /// 中心图标路径
  final String iconPath;

  /// 应用标题
  final String title;

  /// 应用描述
  final String description;

  /// 按钮列表
  final List<AppInfoButton> buttons;

  const AppInfoCard({
    super.key,
    this.iconPath = 'lib/assets/Icon.svg',
    this.title = '小白调试助手',
    this.description = '仅供开发调试使用',
    this.buttons = const [
      AppInfoButton(label: 'GitHub', icon: Icons.code, onTap: openGitHub),
      AppInfoButton(label: '赞助我们', icon: Icons.favorite, onTap: openSponsor),
      AppInfoButton(
          label: '使用教程', icon: Icons.menu_book_outlined, onTap: openTutorial),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 中心图标
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'lib/assets/Icon.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.apps,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 标题
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.titleTextDark,
            ),
          ),
          const SizedBox(height: 8),
          // 描述
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.descriptionTextLight,
            ),
          ),
          const SizedBox(height: 24),
          // 按钮行
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: buttons.map((button) => _buildButton(button)).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建按钮（响应式：小屏幕隐藏图标）
  Widget _buildButton(AppInfoButton button) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 使用卡片宽度判断是否为小屏幕
        // 卡片宽度 < 280 认为是移动端，隐藏图标
        final isSmallScreen = constraints.maxWidth < 280;

        return InkWell(
          onTap: button.onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.buttonBorderLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isSmallScreen) ...[
                  Icon(button.icon, size: 14, color: AppColors.buttonLabelText),
                  const SizedBox(width: 6),
                ],
                Text(
                  button.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.buttonLabelText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
