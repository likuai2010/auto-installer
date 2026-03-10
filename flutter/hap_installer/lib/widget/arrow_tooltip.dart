import 'package:flutter/material.dart';

/// 带箭头的气泡 Tooltip 组件
///
/// 点击时显示带指向角的气泡提示
/// Tooltip 出现在子组件下方，水平居中于子组件
class ArrowTooltip extends StatefulWidget {
  /// 提示内容
  final String message;

  /// 子组件
  final Widget child;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文字颜色
  final Color? textColor;

  const ArrowTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<ArrowTooltip> createState() => _ArrowTooltipState();
}

class _ArrowTooltipState extends State<ArrowTooltip> {
  OverlayEntry? _overlayEntry;
  bool _isShown = false;

  /// 显示 Tooltip
  void _showTooltip() {
    if (_isShown || widget.message.isEmpty) return;

    // 获取子组件位置
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // 计算子组件中心和底部位置
    final centerX = offset.dx + size.width / 2;
    final bottomY = offset.dy + size.height;

    final overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: widget.message,
        topPosition: bottomY, // 子组件底部
        centerX: centerX, // 子组件中心
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
      ),
    );

    overlayState.insert(_overlayEntry!);
    _isShown = true;
  }

  /// 隐藏 Tooltip
  void _hideTooltip() {
    if (!_isShown) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShown = false;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _showTooltip(),
      onTapUp: (_) => _hideTooltip(),
      onTapCancel: () => _hideTooltip(),
      child: widget.child,
    );
  }
}

/// Tooltip Overlay 层
class _TooltipOverlay extends StatelessWidget {
  final String message;
  final double topPosition; // 子组件底部的 Y 坐标
  final double centerX; // 子组件中心的 X 坐标
  final Color? backgroundColor;
  final Color? textColor;

  const _TooltipOverlay({
    required this.message,
    required this.topPosition,
    required this.centerX,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: centerX - 100, // 气泡宽度一半（基于 200px maxWidth）
      width: 200, // 固定宽度，让箭头始终在中心
      top: topPosition + 4, // 子组件下方 4px
      child: Material(
        color: Colors.transparent,
        child: _BubbleWithArrow(
          backgroundColor: backgroundColor ?? Colors.grey[800]!,
          textColor: textColor ?? Colors.white,
          message: message,
        ),
      ),
    );
  }
}

/// 带箭头的气泡组件
class _BubbleWithArrow extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String message;

  const _BubbleWithArrow({
    required this.backgroundColor,
    required this.textColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 上方箭头
        CustomPaint(
          size: const Size(16, 8),
          painter: _ArrowPainter(color: backgroundColor),
        ),
        // 气泡主体
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// 箭头绘制器
class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 绘制向上的箭头 ▲
    final path = Path()
      ..moveTo(size.width / 2 - 8, size.height) // 左下角
      ..lineTo(size.width / 2, 0) // 顶部中心（箭头尖端）
      ..lineTo(size.width / 2 + 8, size.height) // 右下角
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
