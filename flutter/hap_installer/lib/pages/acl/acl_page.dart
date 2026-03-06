import 'package:flutter/material.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_output.dart';
import 'package:hap_installer/pages/terminal/widgets/terminal_input_bar.dart';

/// ACL 权限页面
///
/// 使用 terminal 风格显示和管理 ACL 权限列表
/// 复用 TerminalOutput 和 TerminalInputBar 组件
class AclPage extends StatefulWidget {
  const AclPage({super.key});

  @override
  State<AclPage> createState() => _AclPageState();
}

class _AclPageState extends State<AclPage> {
  /// 命令输入控制器
  late TextEditingController _inputController;

  /// 滚动控制器
  late ScrollController _scrollController;

  /// ACL 列表（本地副本）
  List<String> _aclList = [];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController();
    _aclList = List.from(eco.aclList);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 添加 ACL 权限
  void _addAcl() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _aclList.add(input);
      eco.aclList.add(input);
      _inputController.clear();
    });

    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// 重置为默认 ACL 列表
  void _resetToDefault() {
    setState(() {
      eco.aclList = List.from(defaultAcl);
      _aclList = List.from(defaultAcl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACL 权限列表'),
        actions: [
          IconButton(
            onPressed: _resetToDefault,
            tooltip: '重置为默认',
            icon: const Icon(Icons.restore),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TerminalOutput(
          cmdResult: _aclList,
          scrollController: _scrollController,
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: TerminalInputBar(
          controller: _inputController,
          onSend: _addAcl,
          onSubmitted: (_) => _addAcl,
        ),
      ),
    );
  }
}
