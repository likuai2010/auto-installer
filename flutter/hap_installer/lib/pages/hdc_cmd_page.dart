import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/CmdService.dart';

class HdcCmdPage extends StatefulWidget {
  const HdcCmdPage({super.key});

  @override
  State<HdcCmdPage> createState() => HdcCmdPageState();
}

class HdcCmdPageState extends State<HdcCmdPage> {
  late TextEditingController cmdControrller;
  late ScrollController listControrller;
  List<String> cmdResult = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    cmdControrller = TextEditingController(text: "hdc list targets");
    listControrller = ScrollController();
  }

  void sendCmd() async {
    setState(() {
      loading = true;
    });
    try {
      var result = await cmd.baseCmd(cmdControrller.text);
      setState(() {
        cmdResult.add(result);
      });
      Future.delayed(const Duration(milliseconds: 100));
      listControrller.jumpTo(listControrller.position.maxScrollExtent);
      // ignore: empty_catches
    } catch (e) {
      setState(() {
        cmdResult.add("$e");
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('命令行工具'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                cmdResult = [];
              });
            },
            icon: const Icon(Icons.clear),
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
