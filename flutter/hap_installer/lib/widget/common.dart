import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.home_outlined),
    label: '首页',
    selectedIcon: Icon(Icons.home),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.key_outlined),
    label: '证书',
    selectedIcon: Icon(Icons.key),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.history_outlined),
    label: '历史',
    selectedIcon: Icon(Icons.history),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.widgets_outlined),
    label: '更多',
    selectedIcon: Icon(Icons.widgets),
  ),
];

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    this.leading,
    required this.title,
    this.subTitle,
    this.tailling,
    this.onClick,
    this.onLongPress,
  });
  final Widget? leading;
  final String title;
  final String? subTitle;
  final Widget? tailling;
  final Function()? onClick;
  final Function()? onLongPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: leading ?? Container(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  subTitle != null
                      ? Text(
                          subTitle!,
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      : Container(),
                ],
              ),
            ),
            tailling ?? const Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ),
      ),
    );
  }
}

class GroupDecoration extends StatelessWidget {
  const GroupDecoration({super.key, this.label, required this.children});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
      elevation: 1,
      shadowColor: Colors.black,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      child: Text(
                        label ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  : Container(),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// 无线调试连接设备半模态框组件
///
/// 根据 Pixso 设计稿 (item-id: 7:907) 实现
/// 包含标题区域和 IP/端口输入区域
class ConnectDeviceBox extends StatefulWidget {
  const ConnectDeviceBox({super.key, required this.ip, required this.port});

  /// IP 地址
  final String ip;

  /// 端口号
  final String port;

  @override
  State<StatefulWidget> createState() {
    return _ConnectDeviceBoxState();
  }
}

class _ConnectDeviceBoxState extends State<ConnectDeviceBox> {
  late TextEditingController ipController;
  late TextEditingController portController;
  bool connecting = false;

  /// 输入框背景色（淡蓝色）
  static const Color inputBgColor = Color.fromRGBO(57, 107, 223, 0.2);

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController(text: widget.ip);
    portController = TextEditingController(text: widget.port);
  }

  /// 执行 HDC 无线连接
  ///
  /// 只有连接成功时才关闭半模态框
  void connectHdc(BuildContext context) async {
    if (connecting) return;
    setState(() {
      connecting = true;
    });
    final result = await viewmodel.connectDevice(
      context,
      ipController.text,
      portController.text,
    );
    if (!mounted) return;
    setState(() {
      connecting = false;
    });
    // 只有连接成功才关闭半模态框
    if (result && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 顶部标题区域
        _buildHeader(context),
        // 底部输入区域
        _buildInputArea(context),
      ],
    );
  }

  /// 构建顶部标题区域
  ///
  /// 包含标题、提示文字和操作按钮
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 左侧标题区域
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 标题
                Text(
                  '无线调试',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    height: 32 / 24,
                  ),
                ),
                SizedBox(height: 2),
                // 提示文字
                Text(
                  '初次使用请阅读首页顶部的《使用教程》',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 右侧操作按钮
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 确认按钮
              IconButton(
                onPressed: connecting ? null : () => connectHdc(context),
                icon: connecting
                    ? const SizedBox(
                        width: 26.67,
                        height: 26.67,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color.fromRGBO(0, 0, 0, 0.9),
                        ),
                      )
                    : const Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(0, 0, 0, 0.9),
                        size: 32,
                      ),
              ),
              // 关闭按钮
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建底部输入区域
  ///
  /// 包含 IP 输入框、冒号分隔符、端口输入框
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 16,
      ),
      child: Row(
        children: [
          // IP 输入框
          Expanded(
            child: _buildInputField(
              controller: ipController,
              placeholder: '输入IP地址...',
              maxLength: 15,
              onSubmitted: (_) => connectHdc(context),
            ),
          ),
          // 冒号分隔符
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF49454F),
              ),
            ),
          ),
          // 端口输入框
          SizedBox(
            width: 111,
            child: _buildInputField(
              controller: portController,
              placeholder: '输入端口...',
              maxLength: 5,
              onSubmitted: (_) => connectHdc(context),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建单个输入框
  ///
  /// 圆角 28px，淡蓝色背景，无边框
  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    required int maxLength,
    required ValueChanged<String> onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        onSubmitted: onSubmitted,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(0, 0, 0, 0.9),
        ),
        decoration: InputDecoration(
          counterText: '', // 隐藏字符计数
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ),
      ),
    );
  }
}

void toPage(BuildContext context, Widget Function(BuildContext) builder) {
  Navigator.push(context, MaterialPageRoute(builder: builder));
}

void showAlert(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Function()? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
          ),
          FilledButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
