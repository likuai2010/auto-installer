import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hap_installer/models/DebugAppList.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/models/DebugHistory.dart';
import 'package:intl/intl.dart';
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
        if(model.loadingAppList){
          return  Center(child: CircularProgressIndicator());
        }
        return model.appList.appList.isNotEmpty ? ListView.builder(
                  itemCount: model.appList.appList.length,
                  itemBuilder: (_, i) =>
                      DebugAppItem(info: model.appList.appList[i]),
                ) : const Center(child: Text("没有调试的APP"));
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
    return "${info.appInfo?.label ?? "未知"} \n(${info.appInfo?.version})";
  }
  time(){
    var endTime = info.certEndTime;
    if(endTime == null && info.installTime != null){
      endTime = info.installTime!.add(Duration(days: 180));
    }
    var isAfter = endTime != null ? DateTime.now().isAfter(endTime) : false;
    String formatted1 = DateFormat('yyyy-MM-dd').format(endTime!);
    String formatted2 = DateFormat('yyyy-MM-dd').format(info.installTime!);
    return "安装时间: ${formatted2 ?? "未知"} \n过期时间: ${formatted1} ${isAfter ? "已过期":""}";
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, model, _) {
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
                  TextButton(onPressed: () async{
                    if(info.isGame){
                      showAlert(context, title: Text("关闭游戏模式"), content: Text("需要重启手机才能生效"), onConfirm: () async {
                          await model.setGame(info, context);
                      });
                    }else{
                      showAlert(context, title: Text("切换游戏模式"), content: Text("目前不支持支持328以上系统版本, 切换游戏模式后, 长按底部状态条开启高性能开关"), onConfirm: () async {
                          await model.setGame(info, context);
                      });
                    }
                  }, child: model.loadingGameMode ? CircularProgressIndicator() :(info.isGame ? Text("游戏模式") :  Text("应用模式"))) ,
                  Row(
                    children: [
                      if(info.appInfo != null && info.canReInstall)
                          TextButton(onPressed: () => {
                            if(!model.loadingReinstall){
                              showConfirm(context, title: Text("确定续期?"), content: Text("目前支持500m以下的应用. \n创建新证书将自动删除当前证书. 已安装的其他应用不受影响"), 
                                confirmLabel: "创建新证书",
                                cancelLabel: "使用当前证书",
                                onConfirm: (){
                                    model.reInstall(context, info.appInfo!, true);
                                },
                                onCancel: (){
                                  model.reInstall(context, info.appInfo!, false);
                                }
                              )
                            }
                          }, child: model.loadingReinstall ? CircularProgressIndicator() : Text("续期")),
                        
                        TextButton(onPressed: ()=>{
                          showAlert(context, title: Text("确定卸载?"), onConfirm: (){
                              model.unInstall(info.packageName);
                          })
                        }, child: Text("卸载")),
                    ]),
                    if(info.appInfo != null && info.canReInstall)
                    TextButton(onPressed: () => {
                      showAlert(context, title: Text("确定添加日程提醒?"), 
                          onConfirm: (){
                              model.addCalendar(context, info);
                          },
                        )
                    }, child: Text("日程提醒")),
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
                if(path.contains("svg")){
                  return SvgPicture.file(
                    File(iconPath(model, info.packageName, path)),
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDynamic(context),
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  );
                }
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