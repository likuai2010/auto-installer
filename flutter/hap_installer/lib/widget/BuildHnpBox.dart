


import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:provider/provider.dart';

class BuildHnpBox extends StatelessWidget {
  BuildHnpBox({super.key});

  final TextEditingController name = TextEditingController(text: "base");
  final TextEditingController version = TextEditingController(text: "1.0.0");
  
  @override
  Widget build(BuildContext context) {
    
   return Consumer<EcoViewModel>(
      builder: (context, model, child) {
        name.text = model.hnpName;
        version.text = model.hnpVersion;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              leading: Container(),
              leadingWidth: 10,
              title: const Text("构建hnp包"),
              actions: const [CloseButton()],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Text(
                    "1.请选择hnp结构的目录 \n2.点击开始构建将自动打包成hap包",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    maxLength: 15,
                    controller: name,
                    onChanged: (value) => model.hnpName = value,
                    decoration: InputDecoration(
                      border: null,
                      counter: null,
                      labelText: "名称",
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    maxLength: 15,
                    controller: version,
                     onChanged: (value) => model.hnpVersion = value,
                    decoration: InputDecoration(
                      border: null,
                      counter: null,
                      labelText: "版本",
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                     model.selectHnpType("public");
                  },
                  child: Row(
                    children: [
                    Radio(value: "public", toggleable: false, groupValue: model.hnpType, onChanged: (v){
                        model.selectHnpType("public");
                    }),
                    const Text("Public"),
                  ]),
                ),
                GestureDetector(
                  onTap:(){
                     model.selectHnpType("private");
                  },
                  child:  Row(children: [
                      Radio(value: "private",  groupValue: model.hnpType, onChanged: (v){
                          model.selectHnpType("private");
                      }),
                      const Text("Private")
                  ]),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("hap基座: ${model.baseHap() ?? "默认hap"}"),
                TextButton(onPressed: () {
                    model.selectBaseHap(context);
                  }, child: const Text("更换hap")
                )
              ],
            ),
            const SizedBox(height: 20),
            TextButton(onPressed: (){
                model.buildToHap(context);
            }, 
              child: !model.buildHaping ? const Text("开始构建") : const CircularProgressIndicator(value: null)
            )
          ],
        );
      });
  }
 
}