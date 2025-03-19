
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:provider/provider.dart';

class SignConfigPage extends StatelessWidget {
  const SignConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(builder: (_, model, child){
        return ListView(children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text("签名配置", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(title: Text("p12"), subtitle: Text("证书密钥，用于创建csr,cer,p7b等文件"), onTap: (){
              toask(context, "已复制到剪贴板");
              Clipboard.setData(ClipboardData(text: model.signConfig?.keystoreFile??""));
          }, trailing: TextButton(onPressed: (){
          }, child: Text("更换")),),
          ListTile(title: Text("csr"), subtitle: Text("通过p12创建, 用于申请cer证书"), onTap: (){
              toask(context, "已复制到剪贴板");
              Clipboard.setData(ClipboardData(text: model.signConfig?.csrPath??""));
          }, trailing: TextButton(onPressed: (){
          }, child: Text("更换")),),
          ListTile(title: Text("keyAlias"), subtitle: Text("密钥别名"),onTap: (){
              toask(context, "已复制到剪贴板");
              Clipboard.setData(ClipboardData(text: "${model.signConfig?.keyAlias }"));
          }, trailing: TextButton(onPressed: (){}, child: Text("更换")),),
          ListTile(title: Text("keyPwd"), subtitle: Text("密钥密码"), onTap: (){
              toask(context, "已复制到剪贴板");
              Clipboard.setData(ClipboardData(text: "${model.signConfig?.keystorePwd  }"));
          }, trailing: TextButton(onPressed: (){}, child: Text("更换")),),
        ],);
    });
  }


}