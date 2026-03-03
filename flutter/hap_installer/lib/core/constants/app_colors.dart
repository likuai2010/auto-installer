import 'package:flutter/material.dart';

/// 应用颜色常量定义
class AppColors {
  AppColors._();

  // 背景色
  static const Color background = Color(0xFFF1F3F5);
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF1F3F5);

  // 文本色
  static const Color primaryText = Color(0xFF1D1B20);
  static const Color secondaryText = Color(0xFF49454F);
  static const Color tertiaryText = Color(0xFF79747E);
  static const Color hintText = Color(0xFF93919D);
  static const Color titleTextDark = Color.fromRGBO(0, 0, 0, 0.9);
  static const Color descriptionTextLight = Color.fromRGBO(0, 0, 0, 0.6);

  // 分隔线和边框
  static const Color divider = Color(0x1A000000);
  static const Color border = Color(0xFFCAC4D0);
  static const Color dividerColor = Color.fromRGBO(0, 0, 0, 0.1);

  // 主色调
  static const Color primary = Color(0xFF396BDF);
  static const Color primaryLight = Color(0xFFE8EDFF);
  static const Color primaryButton = Color(0xFF396BDF);

  // 状态色
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);

  // 图标颜色
  static const Color iconColor = Color.fromARGB(255, 0, 0, 0);

  // 图标背景色
  static const Color iconBgBlue = Color(0xFFE8EDFF);
  static const Color iconBgGreen = Color(0xFFE8F5E9);
  static const Color iconBgOrange = Color(0xFFFFF3E0);
  static const Color iconBgPurple = Color(0xFFF3E5F5);
  static const Color iconBgGray = Color(0xFFF5F5F5);

  // 按钮色
  static const Color buttonPrimary = Color(0xFF396BDF);
  static const Color buttonSecondary = Color(0xFFF5F5F5);
  static const Color buttonTextPrimary = Colors.white;
  static const Color buttonTextSecondary = Color(0xFF49454F);
  static const Color buttonLabelText = Color.fromARGB(255, 57, 107, 223);
  static const Color buttonLightBackground = Color.fromRGBO(57, 107, 223, 0.08);
  static const Color buttonBorderLight = Color.fromRGBO(57, 107, 223, 0.6);

  // 页面标题栏
  static const Color pageBarBackground = Color.fromRGBO(241, 243, 245, 0.6);
  static const Color pageBarTitle = Color.fromARGB(255, 29, 27, 32);

  // NavigationBar 相关
  static const Color navBarBackground = Color.fromRGBO(57, 107, 223, 0.05);
  static const Color navBarIndicator = Color.fromRGBO(57, 107, 223, 0.2);

  // 页面背景（白色）
  static const Color pageBackground = Color.fromRGBO(242, 243, 245, 1);
}
