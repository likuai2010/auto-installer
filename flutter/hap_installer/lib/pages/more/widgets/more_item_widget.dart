import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import 'more_item.dart';

/// 更多页面列表项 UI 组件
///
/// 根据 Pixso 设计稿 (item-id: 5:19773) 实现
/// 列表项高度: 64px
/// 左侧图标: 24x24，padding 16px
/// 右侧元素: 箭头 / Switch 开关 / 文本 / 按钮
/// 下边框: 1px，颜色 rgba(0, 0, 0, 0.1)
class MoreItemWidget extends StatelessWidget {
  /// 列表项数据
  final MoreItem item;

  /// 是否显示下边框
  final bool showDivider;

  const MoreItemWidget({
    super.key,
    required this.item,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: InkWell(
        onTap: item.itemType == MoreItemType.arrow ? item.onTap : null,
        child: DecoratedBox(
          decoration: showDivider
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.compDividerDynamic(context),
                      width: 1,
                    ),
                  ),
                )
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 左侧图标
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildIcon(context),
                ),
                // 标题
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.fontPrimaryDynamic(context),
                    ),
                  ),
                ),
                // 右侧元素
                _buildTrailing(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建左侧图标
  ///
  /// 优先使用 IconData，其次使用 SVG 路径
  Widget _buildIcon(BuildContext context) {
    // 优先使用 Material Icon
    if (item.iconData != null) {
      return Icon(
        item.iconData,
        size: 24,
        color: AppColors.iconPrimaryDynamic(context),
      );
    }

    // 使用 SVG 图标
    return SvgPicture.asset(
      item.icon!,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        AppColors.iconPrimaryDynamic(context),
        BlendMode.srcIn,
      ),
      placeholderBuilder: (context) => Icon(
        Icons.circle_outlined,
        size: 24,
        color: AppColors.iconPrimaryDynamic(context),
      ),
    );
  }

  /// 根据类型构建右侧元素
  Widget _buildTrailing(BuildContext context) {
    switch (item.itemType) {
      case MoreItemType.arrow:
        return Icon(
          Icons.chevron_right,
          size: 24,
          color: AppColors.fontTertiaryDynamic(context),
        );
      case MoreItemType.switch_:
        return Switch(
          value: item.switchValue,
          onChanged: item.onSwitchChanged,
          // 选中状态
          activeColor: AppColors.switchActiveThumbDynamic(context),
          activeTrackColor: AppColors.switchActiveTrackDynamic(context),
          // 未选中状态
          inactiveThumbColor: AppColors.switchInactiveThumbDynamic(context),
          inactiveTrackColor: AppColors.switchInactiveTrackDynamic(context),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return AppColors.switchTrackOutlineDynamic(context);
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return 0;
            }
            return 2;
          }),
        );
      case MoreItemType.text:
        return Text(
          item.trailingText ?? '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.fontSecondaryDynamic(context),
          ),
        );
      case MoreItemType.button:
        return _buildCapsuleButton(context);
    }
  }

  /// 构建胶囊形按钮
  ///
  /// 按钮尺寸: 80x30
  /// 圆角: 100（胶囊形）
  /// 背景: rgba(57,107,223,0.08)
  /// 文字: 蓝色 12px
  /// 加载中: 显示圆环加载条
  Widget _buildCapsuleButton(BuildContext context) {
    // 加载中状态：显示圆环加载条
    if (item.isLoading) {
      return SizedBox(
        width: 80,
        height: 30,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.brandDynamic(context)),
            ),
          ),
        ),
      );
    }

    final buttonEnabled = item.onButtonTap != null;
    // 禁用状态颜色
    final disabledBgColor = AppColors.brandDynamic(context).withValues(alpha: 0.04);
    final disabledTextColor = AppColors.brandDynamic(context).withValues(alpha: 0.5);

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
            item.buttonLabel ?? '',
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
