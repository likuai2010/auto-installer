import 'package:flutter/material.dart';
import 'package:hap_installer/CertViewModel.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CertPage extends StatelessWidget {
  const CertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_){
        return CertViewModel();
    }, child: Consumer<CertViewModel>( builder: (context, model, child) {
      return Expanded(
        child: model.isLogin ? 
        ListView(children: model.certInfoList.map((CertInfo d) => CertItem(info: d, currentId: model.currentId, onclick: (){
          showAlert(context, title: Text("是否下载证书并应用?"), content: Text("注意: p12文件不一致会签名失败(p12是颁发证书的密钥可自行生成)"), onConfirm: (){
              model.useCert(context, d);
          });
        },)).toList()):
        Center(child: Text("未登录账号"))
      );
    }));
  }
  
}

class CertItem extends StatelessWidget {
  const CertItem({super.key, required this.info, required this.currentId, this.onclick});
  final String? currentId;
  final CertInfo info;
  final Function()? onclick;

  Widget? _actions(TextTheme textTheme){
    if (info.certType ==2){
        return Container();
    }
    if (currentId == info.id){
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text("正在使用", style: textTheme.labelSmall));
    }else{
      return TextButton(onPressed: onclick, child: Text("使用",  style: textTheme.labelSmall));
    }
  }
   @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return GroupDecoration(children: [
      ListItem(
        leading: Icon(Icons.key_outlined), 
        title: "${info.certType == 2 ? '发布': '调试'}: ${info.certName}", 
        subTitle: "${info.id}: 与${formatTime(info.expireTime)}过期",
        tailling: _actions(textTheme)
      )
    ]);
  }
  
}

String formatTime(int timestamp){
 DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
 String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); 
 return formattedDate;
}