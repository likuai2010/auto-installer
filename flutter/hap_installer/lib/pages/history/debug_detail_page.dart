import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'widgets/debug_step_item_widget.dart';
import 'package:provider/provider.dart';

/// 调试详情页面
///
/// 显示调试步骤的执行状态，支持查看错误详情和重置证书
class DebugDetailPage extends StatelessWidget {
  const DebugDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('调试详情'),
        backgroundColor: AppColors.pageBarBackground,
        titleTextStyle: const TextStyle(
          color: AppColors.pageBarTitle,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Consumer<HistoryViewModel>(
        builder: (_, model, child) {
          if (model.current == null) {
            return const Center(
              child: Text(
                "暂无调试信息",
                style: TextStyle(
                  color: AppColors.hintText,
                  fontSize: 14,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: model.current!.setps.length,
              itemBuilder: (context, index) {
                final step = model.current!.setps[index];
                return DebugStepItemWidget(
                  info: step,
                  onReset: () {
                    model.resetProfile(context);
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<HistoryViewModel>(
        builder: (_, model, child) {
          final isFinished = model.current?.finished ?? true;

          return Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: isFinished
                    ? () {
                        Navigator.pop(context);
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.buttonSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  isFinished ? "返回" : "调试中",
                  style: TextStyle(
                    color: isFinished ? Colors.white : AppColors.hintText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
