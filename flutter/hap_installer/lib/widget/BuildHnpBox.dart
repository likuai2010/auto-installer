


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
              title: Text("构建hnp包"),
              actions: [const CloseButton()],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "请输入输入包名和版本",
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
                TextButton(onPressed: (){
                    model.BuildHnp(context);
                }, 
                  child: !model.buildHnping ? const Text("构建hnp") : const CircularProgressIndicator(value: null)
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hnp安装类型: "),
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
               
                TextButton(onPressed: (){
                    model.buildHap(context);
                }, 
                  child: !model.buildHaping ? const Text("构建hap") : const CircularProgressIndicator(value: null)
                )
              ],
              
            ),
          ],
        );
      });
  }
 
}