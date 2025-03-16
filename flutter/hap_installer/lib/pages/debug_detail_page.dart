import 'package:flutter/material.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:provider/provider.dart';

class DebugDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('调试详情')),
      body: Consumer<HistoryViewModel>(
        builder: (_, model, child) {
          if (model.current == null) {
            return Center(child: Text("暂无调试信息"));
          }
          return ListView(
            children:
                model.current!.setps
                    .map((s) => DebugStepItem(info: s))
                    .toList(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Consumer<HistoryViewModel>(
          builder: (_, model, child) {
            return FilledButton(
              onPressed:
                  model.current?.finished == false
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
              child: Text(model.current?.finished == false ? "调试中" : "返回"),
            );
          },
        ),
      ),
    );
  }
}

class DebugStepItem extends StatelessWidget {
  DebugStepItem({required this.info});
  SetpInfo info;

  Widget getIcon() {
    if (info.loading == null) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(value: 0.7),
      );
    } else if (info.loading == true) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(value: null),
      );
    }
    if (info.error == null) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.warning);
    }
  }

  String getTitle() {
    if (info.loading == null) {
      return "待进行";
    } else if (info.loading == true) {
      return "进行中";
    }
    if (info.error == null) {
      return "完成";
    } else {
      return "出现错误";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GroupDecoration(
      children: [
        ListItem(
          leading: getIcon(),
          title: getTitle(),
          subTitle: info.name,
          tailling: Container(),
        ),
        info.error != null
            ? Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "${info.error}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
            : Container(),
      ],
    );
  }
}
