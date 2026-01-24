import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/hdc/EcoServices.dart';

class RequestACLPage extends StatefulWidget {
  const RequestACLPage({super.key});

  @override
  State<RequestACLPage> createState() => RequestACLPageState();
}

class RequestACLPageState extends State<RequestACLPage> {
  late TextEditingController cmdControrller;
  late ScrollController listControrller;
  List<String> cmdResult = eco.aclList;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    cmdControrller = TextEditingController(text: "");
    listControrller = ScrollController();
    cmdResult = eco.aclList;
  }

  void sendCmd() async {
    try {
      if(cmdControrller.text.isNotEmpty){
        setState(() {
          cmdResult.add(cmdControrller.text);
          eco.aclList.add(cmdControrller.text);
        });
        listControrller.jumpTo(listControrller.position.maxScrollExtent);
      }
    
      // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACL权限列表'),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                eco.aclList = [...defaultAcl];
                cmdResult = [...defaultAcl];
              });
            },
            icon: const Icon(Icons.abc),
          ),
          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Colors.black,
          child: ListView.builder(
            itemCount: cmdResult.length,
            controller: listControrller,
            itemBuilder: (_, i) {
              return Text(cmdResult[i], style: const TextStyle(color: Colors.white));
            },
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cmdControrller,
                    onSubmitted: (_) {
                      sendCmd();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(onPressed: sendCmd, icon: const Icon(Icons.check_circle)),
              ],
            )),
      ),
    );
  }
}
