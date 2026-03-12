import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/widget/page_transitions.dart';

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

/// 列表项组件
///
/// 通用的列表项组件，支持前导图标、标题、副标题和尾部组件
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
                  Text(
                    title,
                    style:
                        TextStyle(color: AppColors.fontPrimaryDynamic(context)),
                  ),
                  subTitle != null
                      ? Text(
                          subTitle!,
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      : Container(),
                ],
              ),
            ),
            tailling ?? Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ),
      ),
    );
  }
}

/// 分组装饰组件
///
/// 带标签的卡片容器，用于包装一组相关的列表项
class GroupDecoration extends StatelessWidget {
  const GroupDecoration({super.key, this.label, required this.children});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
      elevation: 1,
      shadowColor: Colors.transparent,
      color: AppColors.compBackgroundPrimaryDynamic(context),
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
          Expanded(
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
                    color: AppColors.fontPrimaryDynamic(context),
                    height: 32 / 24,
                  ),
                ),
                const SizedBox(height: 2),
                // 提示文字
                Text(
                  '初次使用请阅读首页顶部的《使用教程》',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fontSecondaryDynamic(context),
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
                    ? SizedBox(
                        width: 26.67,
                        height: 26.67,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.fontPrimaryDynamic(context),
                        ),
                      )
                    : Icon(
                        Icons.check_circle,
                        color: AppColors.brandDynamic(context),
                        size: 32,
                      ),
              ),
              // 关闭按钮
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: AppColors.fontSecondaryDynamic(context),
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
  /// 包含 IP 输入框、冒号分隔符、端口输入框和自动连接开关
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 16,
      ),
      child: Column(
        children: [
          // IP/端口输入行
          Row(
            children: [
              // IP 输入框
              Expanded(
                child: _buildInputField(
                  context: context,
                  controller: ipController,
                  placeholder: '输入IP地址...',
                  maxLength: 15,
                  onSubmitted: (_) => connectHdc(context),
                ),
              ),
              // 冒号分隔符
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.fontPrimaryDynamic(context),
                  ),
                ),
              ),
              // 端口输入框
              SizedBox(
                width: 111,
                child: _buildInputField(
                  context: context,
                  controller: portController,
                  placeholder: '输入端口...',
                  maxLength: 5,
                  onSubmitted: (_) => connectHdc(context),
                ),
              ),
            ],
          ),
          // 自动连接开关
          const SizedBox(height: 12),
          _buildAutoConnectSwitch(context),
        ],
      ),
    );
  }

  /// 构建自动连接开关
  ///
  /// 允许用户设置是否在启动时自动连接上次设备
  Widget _buildAutoConnectSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '自动连接上次设备',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.fontSecondaryDynamic(context),
          ),
        ),
        FutureBuilder<bool>(
          future: getAutoConnect(),
          builder: (context, snapshot) {
            final value = snapshot.data ?? true;
            return Switch(
              value: value,
              onChanged: (newValue) async {
                await setAutoConnect(newValue);
                setState(() {});
              },
              activeColor: AppColors.switchActiveThumbDynamic(context),
              activeTrackColor: AppColors.switchActiveTrackDynamic(context),
            );
          },
        ),
      ],
    );
  }

  /// 构建单个输入框
  ///
  /// 圆角 28px，淡蓝色背景，无边框
  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String placeholder,
    required int maxLength,
    required ValueChanged<String> onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonLightBackgroundDynamic(context),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        onSubmitted: onSubmitted,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.fontPrimaryDynamic(context),
        ),
        decoration: InputDecoration(
          counterText: '', // 隐藏字符计数
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.fontTertiaryDynamic(context),
          ),
        ),
      ),
    );
  }
}

/// 导航到新页面
///
/// 使用统一的淡入滑动过渡动画
void toPage(BuildContext context, Widget Function(BuildContext) builder) {
  Navigator.push(context, FadeSlidePageRoute(builder: builder));
}

/// 显示确认对话框
void showAlert(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Function()? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.compBackgroundPrimaryDynamic(context),
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text(
              '确认',
              style: TextStyle(color: AppColors.fontSecondaryDynamic(context)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandDynamic(context),
              foregroundColor: AppColors.buttonTextPrimary,
            ),
            child: const Text('取消'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      );
    },
  );
}

void showConfirm(
  BuildContext context, {
  Widget? title,
  Widget? content,
  String? confirmLabel,
  String? cancelLabel,
  Function()? onConfirm,
  Function()? onCancel,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.compBackgroundPrimaryDynamic(context),
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text(
              confirmLabel ?? '确认',
              style: TextStyle(color: AppColors.fontSecondaryDynamic(context)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandDynamic(context),
              foregroundColor: AppColors.buttonTextPrimary,
            ),
            child: Text(cancelLabel ?? '取消'),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onCancel != null) {
                onCancel();
              }
            },
          ),
        ],
      );
    },
  );
}
