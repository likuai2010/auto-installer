import 'package:flutter/foundation.dart';
import 'package:hap_installer/models/HapInfo.dart';

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

  final HapInfo? hapInfo;

  /// 按钮文本
  final String buttonLabel;

  /// 是否处于激活状态
  final bool isActive;

  /// 是否可见
  final bool isVisible;

  /// 是否正在加载
  final bool isLoading;

  /// 按钮点击回调
  final VoidCallback? onButtonTap;

  /// 整体点击回调
  final VoidCallback? onTap;

  const HomeSettingItem({
    required this.title,
    required this.description,
    required this.icon,
    this.activeIcon,
    this.hapInfo,
    required this.buttonLabel,
    this.isActive = false,
    this.isVisible = true,
    this.isLoading = false,
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
    bool? isLoading,
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
      isLoading: isLoading ?? this.isLoading,
      onButtonTap: onButtonTap ?? this.onButtonTap,
      onTap: onTap ?? this.onTap,
    );
  }
}
