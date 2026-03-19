import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:path/path.dart';
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
      backgroundColor: AppColors.backgroundSecondaryDynamic(context),
      appBar: AppBar(
        title: const Text('调试详情'),
        backgroundColor: AppColors.pageBarBackgroundDynamic(context),
        titleTextStyle: TextStyle(
          color: AppColors.pageBarTitleDynamic(context),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Consumer<HistoryViewModel>(
        builder: (_, model, child) {
          if (model.current == null) {
            return Center(
              child: Builder(
                builder: (context) => Text(
                  "暂无调试信息",
                  style: TextStyle(
                    color: AppColors.fontTertiaryDynamic(context),
                    fontSize: 14,
                  ),
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
                  onUnInstall: () async {
                    await model.unInstall(model.current!.hapInfo.packageName);
                    Navigator.pop(context);
                  },
                  onSync: () async {
                        await viewmodel.initAutoConnectConfig(context);
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
                  backgroundColor: AppColors.brandDynamic(context),
                  disabledBackgroundColor: AppColors.buttonSecondaryDynamic(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Builder(
                  builder: (context) => Text(
                    isFinished ? "返回" : "调试中",
                    style: TextStyle(
                      color: isFinished
                          ? AppColors.buttonTextPrimary
                          : AppColors.fontTertiaryDynamic(context),
                    ),
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
