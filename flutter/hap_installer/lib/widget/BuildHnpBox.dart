


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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              leading: Container(),
              leadingWidth: 10,
              title: const Text("构建hnp包"),
              actions: [const CloseButton()],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "1.请选择hnp结构的目录 \n2. 选择目录有将自动打包成hap",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Text(model.hnpOutPath),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    maxLength: 15,
                    controller: name,
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
                    decoration: InputDecoration(
                      border: null,
                      counter: null,
                      labelText: "版本",
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:(){
                     model.selectHnpType("public");
                  },
                  child: Row(
                    children: [
                    Radio(value: "public", toggleable: false, groupValue: model.hnpType, onChanged: (v){
                        model.selectHnpType("public");
                    }),
                    Text("Public"),
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
                      Text("Private")
                  ]),
                ),
               
                
              ],
            ),
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