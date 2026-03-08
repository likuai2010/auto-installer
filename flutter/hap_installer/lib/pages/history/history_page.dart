import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/models/DebugAppList.dart';
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
            child: model.appList.appList.isNotEmpty
                ? ListView.builder(
                    itemCount: model.appList.appList.length,
                    itemBuilder: (_, i) =>
                        DebugAppItem(info: model.appList.appList[i]),
                  )
                : const Center(child: Text("没有调试的APP")),
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

class DebugAppItem extends StatelessWidget {
  const DebugAppItem({super.key, required this.info});
  final DebugApp info;

  title(){
    if(info.appInfo == null){
      return  "${info.appInfo?.label ?? "未知"} (${info.packageName})";
    }
    return "${info.appInfo?.label ?? "未知"} \n(${info.appInfo?.version} ${info.appInfo?.deviceType})";
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, model, _) {
        if(model.loadingAppList){
          return CircularProgressIndicator();
        }
        return GroupDecoration(
          children: [
            ListItem(
              leading:
              info.appInfo == null ? const Icon(Icons.check_circle) : 
              Stack(
                  children: info.appInfo!.icon.map((path) {
                    if(File(path).existsSync()){
                      return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(path),
                        width: 24,
                        height: 24,
                      ),
                     );
                    }else{
                      return Container();
                    }
                   
                  }).toList(),
                ),
              title: title(),
              subTitle: "安装时间: ${info.installTime ?? "未知"} | 过期时间: ${info.certEndTime ?? "未知"}",
              tailling: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: ()=>{
                  }, child: Text("游戏模式")),
                  Row(
                    children: [
                      TextButton(onPressed: ()=>{
                      }, child: Text("续期")),
                      TextButton(onPressed: ()=>{
                      }, child: Text("卸载")),
                    ]),
                
                ],
              ),
              onClick: () {
                // toPage(context, (_) => const DebugDetailPage());
              },
            ),
          ],
        );
      },
    );
  }
}
