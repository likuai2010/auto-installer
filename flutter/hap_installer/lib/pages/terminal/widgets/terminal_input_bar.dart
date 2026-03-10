import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 终端输入栏组件
///
/// 底部输入框和发送按钮，符合 Pixso 设计稿规格
class TerminalInputBar extends StatelessWidget {
  /// 命令输入控制器
  final TextEditingController controller;

  /// 发送命令回调
  final VoidCallback onSend;

  /// 是否正在加载
  final bool loading;

  /// 输入提交回调（键盘回车）
  final ValueChanged<String>? onSubmitted;

  const TerminalInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.loading = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.navBarIndicatorDynamic(context),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: onSubmitted,
                enabled: !loading,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.fontPrimaryDynamic(context),
                ),
                decoration: InputDecoration(
                  hintText: '输入 HDC 命令...',
                  hintStyle: TextStyle(
                    color: AppColors.fontTertiaryDynamic(context),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: AppColors.navBarIndicatorDynamic(context),
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: loading ? null : onSend,
                borderRadius: BorderRadius.circular(28),
                child: Center(
                  child: loading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.brandDynamic(context),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          size: 24,
                          color: AppColors.brandDynamic(context),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
