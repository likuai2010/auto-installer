import 'package:flutter/foundation.dart';

/// 首页设置项数据模型
class HomeSettingItem {
  /// 标题
  final String title;

  /// 描述文本
  final String description;

  /// 图标路径（未激活状态）
  final String icon;

  /// 图标路径（激活状态）
  final String? activeIcon;

  /// 按钮文本
  final String buttonLabel;

  /// 是否处于激活状态
  final bool isActive;

  /// 是否可见
  final bool isVisible;

  /// 按钮点击回调
  final VoidCallback? onButtonTap;

  /// 整体点击回调
  final VoidCallback? onTap;

  const HomeSettingItem({
    required this.title,
    required this.description,
    required this.icon,
    this.activeIcon,
    required this.buttonLabel,
    this.isActive = false,
    this.isVisible = true,
    this.onButtonTap,
    this.onTap,
  });

  /// 获取当前应显示的图标路径
  String get currentIcon => isActive && activeIcon != null ? activeIcon! : icon;

  /// 复制并修改部分属性
  HomeSettingItem copyWith({
    String? title,
    String? description,
    String? icon,
    String? activeIcon,
    String? buttonLabel,
    bool? isActive,
    bool? isVisible,
    VoidCallback? onButtonTap,
    VoidCallback? onTap,
  }) {
    return HomeSettingItem(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      isActive: isActive ?? this.isActive,
      isVisible: isVisible ?? this.isVisible,
      onButtonTap: onButtonTap ?? this.onButtonTap,
      onTap: onTap ?? this.onTap,
    );
  }
}
