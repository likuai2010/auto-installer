import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_input_bar.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_output.dart';
import 'package:hap_installer/core/constants/app_colors.dart';

/// HDC 命令行终端页面
///
/// 提供类似终端的界面，用于执行 HDC 命令并查看输出
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

  /// 清空命令输出结果
  void clearResult() {
    setState(() {
      cmdResult = [];
    });
  }

  /// 加载 HDC 日志文件
  Future<void> loadLog() async {
    setState(() {
      loading = true;
    });

    try {
      final logPath = '${await getTempDir()}hdc.log';
      final logFile = File(logPath);
      if (await logFile.exists()) {
        final log = await logFile.readAsString();
        setState(() {
          cmdResult = [log];
        });
      } else {
        setState(() {
          cmdResult = ['日志文件不存在: $logPath'];
        });
      }
    } catch (e) {
      setState(() {
        cmdResult = ['加载日志失败: $e'];
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('命令行工具'),
        backgroundColor: AppColors.pageBarBackground,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final logPath = "${await getTempDir()}hdc.log";
              var log = await File(logPath).readAsString();
              setState(() {
                cmdResult = [log];
              });
            },
            icon: const Icon(Icons.abc),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
