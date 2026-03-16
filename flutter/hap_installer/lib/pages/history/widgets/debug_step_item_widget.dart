import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';

/// 调试步骤项组件
///
/// 根据设计稿显示调试步骤的状态、标题、描述和错误信息
/// 支持完成、进行中、出现错误、待进行、已取消五种状态
class DebugStepItemWidget extends StatelessWidget {
  const DebugStepItemWidget({
    super.key,
    required this.info,
    this.onReset,
  });

  /// 步骤信息
  final SetpInfo info;

  /// 重置按钮点击回调
  final VoidCallback? onReset;

  /// 获取步骤状态图标
  Widget _buildStatusIcon(BuildContext context) {
    // loading == null: 待进行
    // loading == true: 进行中
    // loading == false && error == null: 完成
    // loading == false && error != null: 出现错误
    if (info.loading == null) {
      // 待进行 - 灰色圆环图标 (70% 进度)
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: 0.7,
          strokeWidth: 2,
          color: AppColors.fontTertiaryDynamic(context),
        ),
      );
    } else if (info.loading == true) {
      // 进行中 - 加载动画
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.brandDynamic(context),
        ),
      );
    }

    // 完成 - 勾选图标
    if (info.error == null) {
      return Icon(
        Icons.check_circle,
        size: 24,
        color: AppColors.confirmDynamic(context),
      );
    }

    // 出现错误 - 警告图标
    return Icon(
      Icons.warning_rounded,
      size: 24,
      color: AppColors.warningDynamic(context),
    );
  }

  /// 获取步骤状态标题
  String _getStatusTitle() {
    if (info.loading == null) {
      return "待进行";
    } else if (info.loading == true) {
      return "进行中";
    }
    if (info.error == null) {
      return "完成";
    }
    return "出现错误";
  }

  Widget BuildReset(BuildContext context){
      if(info.error != null && info.error!.contains("请等待安装")){
          return Container();
      } else {
        return GestureDetector(
            onTap: onReset,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.buttonLightBackground,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "重置证书和Proflie",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.brandDynamic(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
      }
  }

  /// 构建错误详情区域
  Widget _buildErrorSection(BuildContext context) {
    if (info.error == null || info.loading != false) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // 错误详情文本
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            info.error!,
            style: TextStyle(
              fontSize: 13.6,
              color: AppColors.fontSecondaryDynamic(context),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 重置按钮
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: BuildReset(context)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.compBackgroundPrimaryDynamic(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 状态图标 + 标题 + 描述
          Row(
            children: [
              _buildStatusIcon(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusTitle(),
                      style: TextStyle(
                        fontSize: 15.6,
                        fontWeight: FontWeight.w500,
                        color: AppColors.fontPrimaryDynamic(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.name,
                      style: TextStyle(
                        fontSize: 13.6,
                        color: AppColors.fontSecondaryDynamic(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 错误详情区域
          _buildErrorSection(context),
        ],
      ),
    );
  }
}
