import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'debug_detail_page.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, model, child) {
        return Container(
          color: AppColors.backgroundSecondaryDynamic(context),
          child: Expanded(
            child: model.historyList.isNotEmpty
                ? ListView.builder(
                    itemCount: model.historyList.length,
                    itemBuilder: (_, i) =>
                        HistoryItem(info: model.historyList[i]),
                  )
                : const Center(child: Text("没有调试记录")),
          ),
        );
      },
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.info});
  final DebugHistory info;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HistoryViewModel>(context);
    return GroupDecoration(
      children: [
        ListItem(
          leading: const Icon(Icons.check_circle),
          title: info.hapInfo.packageName,
          subTitle: info.hapInfo.version ?? "0.0.0",
          tailling: Container(),
          onClick: () {
            model.selectDebugHistory(info);
            toPage(context, (_) => const DebugDetailPage());
          },
        ),
      ],
    );
  }
}
