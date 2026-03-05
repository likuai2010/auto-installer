import 'package:flutter/material.dart';

/// 更多页面列表项右侧内容类型枚举
enum MoreItemType {
  /// 箭头（跳转页面）
  arrow,

  /// 开关（设置项）
  switch_,

  /// 文本（如版本号）
  text,

  /// 按钮（如检查更新）
  button,
}

/// 更多页面列表项数据模型
///
/// 用于配置更多页面的列表项，支持多种右侧元素类型
class MoreItem {
  /// 标题
  final String title;

  /// 左侧图标路径（SVG），与 [iconData] 二选一
  final String? icon;

  /// 左侧图标数据（Material Icon），与 [icon] 二选一
  final IconData? iconData;

  /// 是否显示（用于平台条件显示）
  final bool isVisible;

  /// 右侧内容类型
  final MoreItemType itemType;

  /// 右侧文本（如版本号，仅 text 类型）
  final String? trailingText;

  /// 点击回调（arrow 类型）
  final VoidCallback? onTap;

  /// 开关值变更回调（仅 switch 类型）
  final ValueChanged<bool>? onSwitchChanged;

  /// 开关当前值（仅 switch 类型）
  final bool switchValue;

  /// 按钮文本（仅 button 类型）
  final String? buttonLabel;

  /// 按钮点击回调（仅 button 类型）
  final VoidCallback? onButtonTap;

  /// 是否正在加载（用于按钮加载状态）
  final bool isLoading;

  /// 使用 SVG 图标创建列表项
  const MoreItem({
    required this.title,
    this.icon,
    this.iconData,
    this.isVisible = true,
    this.itemType = MoreItemType.arrow,
    this.trailingText,
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    this.buttonLabel,
    this.onButtonTap,
    this.isLoading = false,
  }) : assert(icon != null || iconData != null, 'icon 或 iconData 必须提供一个');

  /// 使用 Material Icon 创建列表项
  const MoreItem.withIcon({
    required this.title,
    required this.iconData,
    this.isVisible = true,
    this.itemType = MoreItemType.arrow,
    this.trailingText,
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    this.buttonLabel,
    this.onButtonTap,
    this.isLoading = false,
  }) : icon = null;

  /// 复制并修改部分属性
  MoreItem copyWith({
    String? title,
    String? icon,
    IconData? iconData,
    bool? isVisible,
    MoreItemType? itemType,
    String? trailingText,
    VoidCallback? onTap,
    ValueChanged<bool>? onSwitchChanged,
    bool? switchValue,
    String? buttonLabel,
    VoidCallback? onButtonTap,
    bool? isLoading,
  }) {
    return MoreItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      iconData: iconData ?? this.iconData,
      isVisible: isVisible ?? this.isVisible,
      itemType: itemType ?? this.itemType,
      trailingText: trailingText ?? this.trailingText,
      onTap: onTap ?? this.onTap,
      onSwitchChanged: onSwitchChanged ?? this.onSwitchChanged,
      switchValue: switchValue ?? this.switchValue,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      onButtonTap: onButtonTap ?? this.onButtonTap,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
