import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../home_setting_item.dart';

/// 首页设置列表项组件
///
/// 用于显示带图标、标题、描述和按钮的设置项
/// 根据 Pixso 设计稿 (item-id: 5:16382) 实现
/// 列表项高度: 76px
/// 左侧图标: 24x24，padding 16px（无背景）
/// 右侧按钮: 80x30，圆角100（胶囊形），背景 rgba(57,107,223,0.08)，文字蓝色 12px
/// 下边框: 1px，颜色 rgba(0, 0, 0, 0.1)，左边距 80px
class HomeSettingItemWidget extends StatelessWidget {
  /// 设置项数据
  final HomeSettingItem item;

  /// 是否显示下边框
  final bool showDivider;

  /// 下边框颜色
  final Color dividerColor;

  const HomeSettingItemWidget({
    super.key,
    required this.item,
    this.showDivider = true,
    this.dividerColor = AppColors.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    // 下边框左边距 80px（从卡片左边缘开始计算）
    // 外层已有 16px padding，所以内容区域需要额外 64px 左边距
    const dividerIndent = 64.0;

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
                // 图标（无背景容器）
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  child: SvgPicture.asset(
                    item.currentIcon,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconColor,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (context) => const Icon(
                      Icons.circle_outlined,
                      size: 24,
                      color: AppColors.iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 0),
                // 文字区域
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧胶囊按钮
                _buildCapsuleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建胶囊形按钮
  ///
  /// 按钮尺寸: 80x30
  /// 圆角: 100（胶囊形）
  /// 背景: rgba(57,107,223,0.08)
  /// 文字: 蓝色 12px
  /// 加载中: 显示圆环加载条
  Widget _buildCapsuleButton() {
    // 加载中状态：显示圆环加载条
    if (item.isLoading) {
      return const SizedBox(
        width: 80,
        height: 30,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonLabelText),
            ),
          ),
        ),
      );
    }

    final buttonEnabled = item.onButtonTap != null;
    // 禁用状态颜色：背景 4% 透明度，文字 50% 透明度
    const disabledBgColor = Color.fromRGBO(57, 107, 223, 0.04);
    const disabledTextColor = Color.fromRGBO(57, 107, 223, 0.5);

    return SizedBox(
      width: 80,
      height: 30,
      child: InkWell(
        onTap: buttonEnabled ? item.onButtonTap : null,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonEnabled
                ? AppColors.buttonLightBackground
                : disabledBgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            item.buttonLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  buttonEnabled ? AppColors.buttonLabelText : disabledTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
