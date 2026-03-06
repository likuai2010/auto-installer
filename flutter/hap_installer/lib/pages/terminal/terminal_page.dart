import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_input_bar.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_output.dart';

/// HDC 命令行终端页面
///
/// 提供类似终端的界面，用于执行 HDC 命令并查看输出
/// 参考 ACL Page 的配色风格，使用 Theme 默认背景色
class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => TerminalPageState();
}

class TerminalPageState extends State<TerminalPage> {
  /// 命令输入控制器
  late TextEditingController cmdController;

  /// 输出列表滚动控制器
  late ScrollController scrollController;

  /// 命令执行结果列表
  List<String> cmdResult = [];

  /// 是否正在执行命令
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cmdController = TextEditingController(text: 'hdc list targets');
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    cmdController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// 执行 HDC 命令
  Future<void> sendCmd() async {
    final cmdText = cmdController.text.trim();
    if (cmdText.isEmpty) return;

    setState(() {
      loading = true;
      // 在结果中显示输入的命令
      cmdResult.add('> $cmdText');
    });

    try {
      final result = await cmd.baseCmd(cmdText);
      setState(() {
        cmdResult.add(result);
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        cmdResult.add('Error: $e');
      });
    }

    setState(() {
      loading = false;
    });
  }

  /// 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 参考 ACL Page：不显式设置背景色，使用 Theme 默认值
    // 这样深色模式下外层是深灰色，与纯黑终端形成边框对比
    return Scaffold(
      appBar: AppBar(
        title: const Text('命令行工具'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final logPath = "${await getTempDir()}hdc.log";
              final log = await File(logPath).readAsString();
              setState(() {
                cmdResult = [log];
              });
            },
            tooltip: '加载日志',
            icon: const Icon(Icons.description_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                cmdResult = [];
              });
            },
            tooltip: '清空',
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TerminalOutput(
          cmdResult: cmdResult,
          scrollController: scrollController,
          loading: loading,
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: SafeArea(
          child: TerminalInputBar(
            controller: cmdController,
            onSend: sendCmd,
            loading: loading,
            onSubmitted: (_) => sendCmd(),
          ),
        ),
      ),
    );
  }
}
