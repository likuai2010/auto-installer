import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/string_utils.dart';
import '../../../widget/arrow_tooltip.dart';
import 'cert_item.dart';

/// 证书列表项组件
///
/// 用于显示带图标、证书名称、过期时间和操作按钮的证书项
/// 每一项都是独立的卡片，白色背景，16px 圆角
/// 列表项高度: 76px
/// 左侧图标: 24x24，padding 16px（无背景）
/// 右侧按钮: 80x30，圆角100（胶囊形）
/// 支持从右向左滑动显示删除按钮
class CertListItemWidget extends StatefulWidget {
  /// 证书项数据
  final CertItem item;

  const CertListItemWidget({
    super.key,
    required this.item,
  });

  @override
  State<CertListItemWidget> createState() => _CertListItemWidgetState();
}

class _CertListItemWidgetState extends State<CertListItemWidget> {
  /// 大屏幕宽度阈值（超过此宽度认为是PC端）
  static const double _kLargeScreenThreshold = 600;

  /// 判断是否为大屏幕设备
  bool _isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= _kLargeScreenThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.certName),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirm(context),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.warningDynamic(context),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.compBackgroundPrimaryDynamic(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 76,
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
                      "lib/assets/certkey.svg",
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.iconPrimaryDynamic(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  // 文字区域
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 箭头提示框 -> 在文本下方显示完整的证书名称
                        ArrowTooltip(
                          message: widget.item.certName,
                          child: Text(
                            _isLargeScreen(context)
                                ? '${widget.item.certTypeLabel}: ${widget.item.certName}'
                                : truncateMiddle(
                                    '${widget.item.certTypeLabel}: ${widget.item.certName}',
                                    20),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: widget.item.isExpired
                                  ? AppColors.fontTertiaryDynamic(context)
                                  : AppColors.fontPrimaryDynamic(context),
                            ),
                            // 大屏幕时允许文本溢出省略
                            overflow: _isLargeScreen(context)
                                ? TextOverflow.ellipsis
                                : null,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '于${widget.item.formattedExpireTime}过期',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: widget.item.isExpired
                                ? AppColors.warningDynamic(context)
                                : AppColors.fontSecondaryDynamic(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 右侧按钮
                  _buildActionButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  ///
  /// 返回 true 确认删除，false 取消
  Future<bool?> _showDeleteConfirm(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('删除后此证书签名的Profile将失效，确定要删除吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              widget.item.onDelete?.call();
            },
            child: Text(
              '删除',
              style: TextStyle(color: AppColors.warningDynamic(context)),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  ///
  /// 根据证书状态显示不同按钮：
  /// - 正在使用：显示"正在使用"文本
  /// - 未过期且非当前：显示"使用"按钮
  /// - 已过期：不显示按钮（通过滑动删除）
  Widget _buildActionButton(BuildContext context) {
    // 正在使用：显示"正在使用"文本
    if (widget.item.isCurrent) {
      return SizedBox(
        width: 80,
        height: 30,
        child: Center(
          child: Text(
            '正在使用',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.confirmDynamic(context),
            ),
          ),
        ),
      );
    }

    // 已过期：不显示按钮（统一通过滑动删除）
    if (widget.item.isExpired) {
      return const SizedBox(width: 80, height: 30);
    }

    // 未过期且非当前：显示使用按钮
    return _buildCapsuleButton(
      context: context,
      label: '使用',
      onTap: widget.item.onUse,
    );
  }

  /// 构建胶囊形按钮
  ///
  /// 按钮尺寸: 80x30
  /// 圆角: 100（胶囊形）
  Widget _buildCapsuleButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onTap,
  }) {
    final buttonEnabled = onTap != null;
    final backgroundColor = AppColors.buttonLightBackgroundDynamic(context);
    final textColor = AppColors.buttonLabelTextDynamic(context);
    // 禁用状态颜色：背景 4% 透明度，文字 50% 透明度
    final disabledBgColor = backgroundColor.withValues(alpha: 0.04);
    final disabledTextColor = textColor.withValues(alpha: 0.5);

    return SizedBox(
      width: 80,
      height: 30,
      child: InkWell(
        onTap: buttonEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonEnabled ? backgroundColor : disabledBgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: buttonEnabled ? textColor : disabledTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
