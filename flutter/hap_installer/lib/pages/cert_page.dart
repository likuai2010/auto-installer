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
        ListView(children: model.certInfoList.map((CertInfo d) => CertItem(info: d,)).toList()):
        Center(child: Text("未登录华为账号"))
      );
    }));
  }
  
}

class CertItem extends StatelessWidget {
  const CertItem({super.key, required this.info});

  final CertInfo info;
   @override
  Widget build(BuildContext context) {
     final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return GroupDecoration(children: [
      ListItem(
        leading: Icon(Icons.key_outlined), 
        title: "${info.certType == 2? '发布': '调试'}: ${info.certName}", 
        subTitle: info.id,
        tailling: Text(
          "过期: ${formatTime(info.expireTime)}",style: Theme.of(context).textTheme.labelSmall)
        )
    ]);
  }
  
}

String formatTime(int timestamp){
 DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
 String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); 
 return formattedDate;
}