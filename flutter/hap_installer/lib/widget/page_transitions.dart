import 'package:flutter/material.dart';

/// 淡入淡出 + 滑动页面过渡动画
///
/// 提供统一的页面跳转动画效果:
/// - 进入: 从右侧淡入滑出 (250ms + ease-out)`
/// - 退出: 向右淡出滑走 (200ms + ease-in)
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  /// 创建淡入滑动过渡路由
  ///
  /// [builder] 页面构建器
  /// [settings] 路由设置（包含名称、参数等）
  FadeSlidePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: _buildTransitions,
        );

  /// 构建过渡动画
  ///
  /// 新页面从右侧淡入滑出，返回时向右淡出滑走
  static Widget _buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 进入动画: 淡入 + 从右向左滑动
    final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
    );

    final slideIn = Tween<Offset>(
      begin: const Offset(0.1, 0.0), // 从右侧 10% 位置开始
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
    );

    // 退出动画 (当有新页面覆盖时): 向左淡出
    final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeIn,
      ),
    );

    return FadeTransition(
      opacity: fadeOut,
      child: SlideTransition(
        position: slideIn,
        child: FadeTransition(
          opacity: fadeIn,
          child: child,
        ),
      ),
    );
  }
}

/// 便捷方法: 使用淡入滑动动画导航到新页面
///
/// [context] 构建上下文
/// [builder] 页面构建器
void navigateWithFadeSlide(BuildContext context, WidgetBuilder builder) {
  Navigator.push(context, FadeSlidePageRoute(builder: builder));
}
