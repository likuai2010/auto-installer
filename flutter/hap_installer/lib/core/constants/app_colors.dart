import 'package:flutter/material.dart';

/// 应用颜色常量定义
///
/// 颜色系统基于 Pixso 设计稿 (594:10496) 颜色对照表
/// 支持浅色模式和深色模式，通过 [isDarkMode] 方法判断当前主题
/// 使用动态颜色方法获取适配深色模式的颜色
class AppColors {
  AppColors._();

  // ==================== 浅色模式颜色 ====================
  // 来源: Pixso 设计稿 594:10496

  // 背景色系
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF1F3F5);
  static const Color backgroundTertiary = Color(0xFFE5E5EA);
  static const Color backgroundFourth = Color(0xFFD1D1D6);
  static const Color backgroundEmphasize = Color(0xFF0A59F7);

  // 品牌色
  static const Color brand = Color(0xFF0A59F7);

  // 文本色系
  static const Color fontPrimary = Color(0xE6000000); // #000000 90%
  static const Color fontSecondary = Color(0x99000000); // #000000 60%
  static const Color fontTertiary = Color(0x66000000); // #000000 40%
  static const Color fontEmphasize = Color(0xFF0A59F7);

  // 图标色系
  static const Color iconPrimary = Color(0xE6000000); // #000000 90%
  static const Color iconSecondary = Color(0x99000000); // #000000 60%

  // 组件背景
  static const Color compBackgroundPrimary = Color(0xFFFFFFFF);
  static const Color compBackgroundGray = Color(0xFFF1F3F5);

  // 分隔线
  static const Color compDivider = Color(0x33000000); // #000000 20%

  // 状态色
  static const Color confirm = Color(0xFF64BB5C);
  static const Color warning = Color(0xFFE84026);
  static const Color alert = Color(0xFFED6F21);

  // ==================== 深色模式颜色 ====================
  // 来源: Pixso 设计稿 594:10496

  // 深色背景色系
  static const Color darkBackgroundPrimary = Color(0xFF000000);
  static const Color darkBackgroundSecondary = Color(0xFF000000);
  static const Color darkBackgroundTertiary = Color(0xFF202224);
  static const Color darkBackgroundFourth = Color(0xFF2E3033);
  static const Color darkBackgroundEmphasize = Color(0xFF317AF7);

  // 深色品牌色
  static const Color darkBrand = Color(0xFF317AF7);

  // 深色文本色系
  static const Color darkFontPrimary = Color(0xE6FFFFFF); // #FFFFFF 90%
  static const Color darkFontSecondary = Color(0x99FFFFFF); // #FFFFFF 60%
  static const Color darkFontTertiary = Color(0x66FFFFFF); // #FFFFFF 40%
  static const Color darkFontEmphasize = Color(0xFF317AF7);

  // 深色图标色系
  static const Color darkIconPrimary = Color(0xE6FFFFFF); // #FFFFFF 90%
  static const Color darkIconSecondary = Color(0x99FFFFFF); // #FFFFFF 60%

  // 深色组件背景
  static const Color darkCompBackgroundPrimary = Color(0xFF202224);
  static const Color darkCompBackgroundGray = Color(0xFF000000);

  // 深色分隔线
  static const Color darkCompDivider = Color(0x33FFFFFF); // #FFFFFF 20%

  // 深色状态色
  static const Color darkConfirm = Color(0xFF5BA854);
  static const Color darkWarning = Color(0xFFD94838);
  static const Color darkAlert = Color(0xFFDB6B42);

  // ==================== 深色模式扩展颜色 ====================

  // 深色图标背景色 (基于设计稿扩展)
  static const Color darkIconBgBlue = Color(0xFF1A2A4F);
  static const Color darkIconBgGreen = Color(0xFF1A3A2A);
  static const Color darkIconBgOrange = Color(0xFF3A2A1A);
  static const Color darkIconBgPurple = Color(0xFF2A1A3A);
  static const Color darkIconBgGray = Color(0xFF2A2A2A);

  // 深色按钮
  static const Color darkButtonSecondary = Color(0xFF2A2A2A);
  static const Color darkButtonTextSecondary = Color(0x99FFFFFF);

  // 深色页面标题栏
  static const Color darkPageBarBackground = Color(0xCC202224);
  static const Color darkPageBarTitle = Color(0xE6FFFFFF);

  // 深色 NavigationBar
  static const Color darkNavBarBackground = Color(0x1A317AF7);
  static const Color darkNavBarIndicator = Color(0x4D317AF7);

  // ==================== 扩展浅色模式颜色 ====================

  // 图标背景色 (基于设计稿扩展)
  static const Color iconBgBlue = Color(0xFFE8EDFF);
  static const Color iconBgGreen = Color(0xFFE8F5E9);
  static const Color iconBgOrange = Color(0xFFFFF3E0);
  static const Color iconBgPurple = Color(0xFFF3E5F5);
  static const Color iconBgGray = Color(0xFFF5F5F5);

  // 按钮色
  static const Color buttonPrimary = Color(0xFF0A59F7);
  static const Color buttonSecondary = Color(0xFFF1F3F5);
  static const Color buttonTextPrimary = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0x99000000);
  static const Color buttonLabelText = Color(0xFF0A59F7);
  static const Color buttonLightBackground = Color(0x140A59F7);
  static const Color buttonBorderLight = Color(0x990A59F7);

  // 页面标题栏
  static const Color pageBarBackground = Color(0x99F1F3F5);
  static const Color pageBarTitle = Color(0xE6000000);

  // NavigationBar 相关
  static const Color navBarBackground = Color(0x0D0A59F7);
  static const Color navBarIndicator = Color(0x330A59F7);

  // Switch 开关颜色
  static const Color switchActiveTrack = Color(0xFF0A59F7);
  static const Color switchActiveThumb = Color(0xFFFFFFFF);
  static const Color switchInactiveTrack = Color(0x330A59F7);
  static const Color switchInactiveThumb = Color(0xB3FFFFFF);
  static const Color switchTrackOutline = Color(0x990A59F7);

  // 深色 Switch 开关颜色
  static const Color darkSwitchActiveTrack = Color(0xFF317AF7);
  static const Color darkSwitchActiveThumb = Color(0xFFFFFFFF);
  static const Color darkSwitchInactiveTrack = Color(0x33317AF7);
  static const Color darkSwitchInactiveThumb = Color(0xB3FFFFFF);
  static const Color darkSwitchTrackOutline = Color(0x99317AF7);

  // 深色按钮扩展颜色
  static const Color darkButtonLightBackground = Color(0x14317AF7);
  static const Color darkButtonLabelText = Color(0xFF317AF7);

  // ==================== 动态颜色方法 ====================

  /// 判断当前是否为深色模式
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// 获取主背景色
  static Color backgroundPrimaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBackgroundPrimary : backgroundPrimary;

  /// 获取次级背景色
  static Color backgroundSecondaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBackgroundSecondary : backgroundSecondary;

  /// 获取三级背景色
  static Color backgroundTertiaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBackgroundTertiary : backgroundTertiary;

  /// 获取四级背景色
  static Color backgroundFourthDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBackgroundFourth : backgroundFourth;

  /// 获取强调背景色
  static Color backgroundEmphasizeDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBackgroundEmphasize : backgroundEmphasize;

  /// 获取品牌色
  static Color brandDynamic(BuildContext context) =>
      isDarkMode(context) ? darkBrand : brand;

  /// 获取主文本颜色
  static Color fontPrimaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkFontPrimary : fontPrimary;

  /// 获取次级文本颜色
  static Color fontSecondaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkFontSecondary : fontSecondary;

  /// 获取三级文本颜色
  static Color fontTertiaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkFontTertiary : fontTertiary;

  /// 获取强调文本颜色
  static Color fontEmphasizeDynamic(BuildContext context) =>
      isDarkMode(context) ? darkFontEmphasize : fontEmphasize;

  /// 获取主图标颜色
  static Color iconPrimaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconPrimary : iconPrimary;

  /// 获取次级图标颜色
  static Color iconSecondaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconSecondary : iconSecondary;

  /// 获取组件主背景色
  static Color compBackgroundPrimaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkCompBackgroundPrimary : compBackgroundPrimary;

  /// 获取组件灰色背景色
  static Color compBackgroundGrayDynamic(BuildContext context) =>
      isDarkMode(context) ? darkCompBackgroundGray : compBackgroundGray;

  /// 获取分隔线颜色
  static Color compDividerDynamic(BuildContext context) =>
      isDarkMode(context) ? darkCompDivider : compDivider;

  /// 获取确认/成功颜色
  static Color confirmDynamic(BuildContext context) =>
      isDarkMode(context) ? darkConfirm : confirm;

  /// 获取警告颜色
  static Color warningDynamic(BuildContext context) =>
      isDarkMode(context) ? darkWarning : warning;

  /// 获取提示颜色
  static Color alertDynamic(BuildContext context) =>
      isDarkMode(context) ? darkAlert : alert;

  /// 获取蓝色图标背景
  static Color iconBgBlueDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconBgBlue : iconBgBlue;

  /// 获取绿色图标背景
  static Color iconBgGreenDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconBgGreen : iconBgGreen;

  /// 获取橙色图标背景
  static Color iconBgOrangeDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconBgOrange : iconBgOrange;

  /// 获取紫色图标背景
  static Color iconBgPurpleDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconBgPurple : iconBgPurple;

  /// 获取灰色图标背景
  static Color iconBgGrayDynamic(BuildContext context) =>
      isDarkMode(context) ? darkIconBgGray : iconBgGray;

  /// 获取次级按钮背景色
  static Color buttonSecondaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkButtonSecondary : buttonSecondary;

  /// 获取次级按钮文本色
  static Color buttonTextSecondaryDynamic(BuildContext context) =>
      isDarkMode(context) ? darkButtonTextSecondary : buttonTextSecondary;

  /// 获取页面标题栏背景色
  static Color pageBarBackgroundDynamic(BuildContext context) =>
      isDarkMode(context) ? darkPageBarBackground : pageBarBackground;

  /// 获取页面标题栏标题色
  static Color pageBarTitleDynamic(BuildContext context) =>
      isDarkMode(context) ? darkPageBarTitle : pageBarTitle;

  /// 获取导航栏背景色
  static Color navBarBackgroundDynamic(BuildContext context) =>
      isDarkMode(context) ? darkNavBarBackground : navBarBackground;

  /// 获取导航栏指示器颜色
  static Color navBarIndicatorDynamic(BuildContext context) =>
      isDarkMode(context) ? darkNavBarIndicator : navBarIndicator;

  /// 获取 Switch 选中轨道颜色
  static Color switchActiveTrackDynamic(BuildContext context) =>
      isDarkMode(context) ? darkSwitchActiveTrack : switchActiveTrack;

  /// 获取 Switch 选中滑块颜色
  static Color switchActiveThumbDynamic(BuildContext context) =>
      isDarkMode(context) ? darkSwitchActiveThumb : switchActiveThumb;

  /// 获取 Switch 未选中轨道颜色
  static Color switchInactiveTrackDynamic(BuildContext context) =>
      isDarkMode(context) ? darkSwitchInactiveTrack : switchInactiveTrack;

  /// 获取 Switch 未选中滑块颜色
  static Color switchInactiveThumbDynamic(BuildContext context) =>
      isDarkMode(context) ? darkSwitchInactiveThumb : switchInactiveThumb;

  /// 获取 Switch 未选中边框颜色
  static Color switchTrackOutlineDynamic(BuildContext context) =>
      isDarkMode(context) ? darkSwitchTrackOutline : switchTrackOutline;

  /// 获取浅色按钮背景色
  static Color buttonLightBackgroundDynamic(BuildContext context) =>
      isDarkMode(context) ? darkButtonLightBackground : buttonLightBackground;

  /// 获取按钮标签文本颜色
  static Color buttonLabelTextDynamic(BuildContext context) =>
      isDarkMode(context) ? darkButtonLabelText : buttonLabelText;

  // ==================== 兼容旧 API 的别名 ====================

  /// 兼容旧 API: 背景色
  static const Color background = backgroundSecondary;
  static const Color cardBackground = compBackgroundPrimary;
  static const Color scaffoldBackground = backgroundSecondary;
  static const Color pageBackground = backgroundSecondary;

  /// 兼容旧 API: 深色背景
  static const Color darkBackground = darkBackgroundSecondary;
  static const Color darkCardBackground = darkCompBackgroundPrimary;
  static const Color darkScaffoldBackground = darkBackgroundSecondary;
  static const Color darkPageBackground = darkBackgroundSecondary;

  /// 兼容旧 API: 文本色
  static const Color primaryText = fontPrimary;
  static const Color secondaryText = fontSecondary;
  static const Color tertiaryText = fontTertiary;
  static const Color hintText = fontTertiary;
  static const Color titleTextDark = fontPrimary;
  static const Color descriptionTextLight = fontSecondary;

  /// 兼容旧 API: 深色文本
  static const Color darkPrimaryText = darkFontPrimary;
  static const Color darkSecondaryText = darkFontSecondary;
  static const Color darkTertiaryText = darkFontTertiary;
  static const Color darkHintText = darkFontTertiary;

  /// 兼容旧 API: 分隔线和边框
  static const Color divider = compDivider;
  static const Color border = backgroundFourth;
  static const Color dividerColor = compDivider;

  /// 兼容旧 API: 深色分隔线和边框
  static const Color darkDivider = darkCompDivider;
  static const Color darkBorder = darkBackgroundFourth;

  /// 兼容旧 API: 主色调
  static const Color primary = brand;
  static const Color primaryLight = iconBgBlue;
  static const Color primaryButton = brand;

  /// 兼容旧 API: 状态色
  static const Color success = confirm;
  static const Color successLight = iconBgGreen;
  static const Color error = warning;
  static const Color errorLight = iconBgOrange;

  /// 兼容旧 API: 图标颜色
  static const Color iconColor = iconPrimary;
  static const Color darkIconColor = darkIconPrimary;

  /// 兼容旧 API: 动态颜色方法
  static Color backgroundDynamic(BuildContext context) =>
      backgroundSecondaryDynamic(context);
  static Color cardBackgroundDynamic(BuildContext context) =>
      compBackgroundPrimaryDynamic(context);
  static Color scaffoldBackgroundDynamic(BuildContext context) =>
      backgroundSecondaryDynamic(context);
  static Color primaryTextDynamic(BuildContext context) =>
      fontPrimaryDynamic(context);
  static Color secondaryTextDynamic(BuildContext context) =>
      fontSecondaryDynamic(context);
  static Color tertiaryTextDynamic(BuildContext context) =>
      fontTertiaryDynamic(context);
  static Color hintTextDynamic(BuildContext context) =>
      fontTertiaryDynamic(context);
  static Color dividerDynamic(BuildContext context) =>
      compDividerDynamic(context);
  static Color borderDynamic(BuildContext context) =>
      backgroundFourthDynamic(context);
  static Color pageBackgroundDynamic(BuildContext context) =>
      backgroundSecondaryDynamic(context);
  static Color iconColorDynamic(BuildContext context) =>
      iconPrimaryDynamic(context);
}
