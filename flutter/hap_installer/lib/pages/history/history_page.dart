import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'debug_detail_page.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

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
  time(){
    var endTime = info.certEndTime;
    if(endTime == null && info.installTime != null){
      endTime = info.installTime!.add(Duration(days: 180));
    }
    var isAfter = endTime != null ? DateTime.now().isAfter(endTime) : false;
    return "安装时间: ${info.installTime ?? "未知"} \n过期时间: ${endTime ?? "未知"} ${isAfter ? "已过期":""}";
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
              info.appInfo == null ? const Icon(Icons.check_circle) : AppIconItem(info: info.appInfo!),
              title: title(),
              subTitle:time(),
              tailling: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: ()=>{
                    showAlert(context, title: Text("敬请期待"), onConfirm: (){
                          
                    })
                  }, child: Text("游戏模式")),
                  Row(
                    children: [
                      if(info.appInfo != null && info.canReInstall)
                          TextButton(onPressed: () => {
                            if(!model.loadingReinstall){
                              showAlert(context, title: Text("确定续期?"), content: Text("目前支持500m以下的应用. 续期将重新创建证书. 已安装的其他应用不受影响"), onConfirm: (){
                                  model.reInstall(context, info.appInfo!);
                              })
                            }
                          }, child: model.loadingReinstall ? CircularProgressIndicator() : Text("续期")),
                        TextButton(onPressed: ()=>{
                          showAlert(context, title: Text("确定卸载?"), onConfirm: (){
                              model.unInstall(info.appInfo!);
                          })
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

class AppIconItem extends StatelessWidget {
  const AppIconItem({super.key, required this.info});
  final HapInfo info;

  iconPath(EcoViewModel model,String packageName, String icon){
    return path.join(model.debugPath, packageName.replaceAll(".", "_"),  icon);
  }
  Widget build(BuildContext context) {
     return Consumer<EcoViewModel>(
      builder: (context, model, _) {
        return Stack(
            children: info.icon.map((path) {
              if(File(iconPath(model,info.packageName, path)).existsSync()){
                return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.file(
                  File(iconPath(model, info.packageName, path)),
                  width: 24,
                  height: 24,
                ),
                );
              }else{
                return Container();
              }
              
            }).toList(),
          );
      }
     );
   }
}