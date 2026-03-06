import 'package:flutter/material.dart';

/// 终端命令输出组件
///
/// 黑色背景的命令行输出区域，显示执行的命令结果
class TerminalOutput extends StatelessWidget {
  /// 命令结果列表
  final List<String> cmdResult;

  /// 滚动控制器
  final ScrollController scrollController;

  /// 是否正在加载
  final bool loading;

  const TerminalOutput({
    super.key,
    required this.cmdResult,
    required this.scrollController,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cmdResult.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SelectableText(
                  cmdResult[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              );
            },
          ),
          if (loading)
            const Positioned(
              left: 12,
              bottom: 12,
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
