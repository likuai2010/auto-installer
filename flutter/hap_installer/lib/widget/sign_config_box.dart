import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:provider/provider.dart';

/// 签名配置半模态框组件
///
/// 根据 Pixso 设计稿 (item-id: 5:17485) 实现
/// 包含标题区域和四个配置项列表
class SignConfigBox extends StatelessWidget {
  const SignConfigBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (_, model, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题区域
            _buildHeader(context),
            // 配置项列表
            _buildConfigList(context, model),
          ],
        );
      },
    );
  }

  /// 构建顶部标题区域
  ///
  /// 根据 Pixso 设计稿 (item-id: 5:17485)
  /// 高度 64px，padding: 8px 16px
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 标题
          const Expanded(
            child: Text(
              '签名配置',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(29, 27, 32, 1),
                height: 32 / 24,
              ),
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
    );
  }

  /// 构建配置项列表
  ///
  /// 包含 p12、csr、keyAlias、keyPwd 四个配置项
  Widget _buildConfigList(BuildContext context, EcoViewModel model) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
        children: [
          // p12 - 证书密钥
          _ConfigListItem(
            title: 'p12',
            subtitle: '(自己创建的私钥)',
            supportingText:
                '命令: openssl pkcs12 -in xiaobai.p12 -nocerts -out key.pem -nodes',
            value: model.signConfig?.keystoreFile ?? '',
            name: 'p12',
            showFilePicker: true,
            model: model,
          ),
          const SizedBox(height: 8),
          // csr - 通过p12创建
          _ConfigListItem(
            title: 'csr',
            subtitle: '(用于申请华为证书)',
            supportingText:
                '命令: openssl req -new -key xiaobai.key -out xiaobai.csr',
            value: model.signConfig?.csrPath ?? '',
            name: 'csr',
            showFilePicker: true,
            model: model,
          ),

          // const SizedBox(height: 8),
          // keyAlias - 密钥别名
          /* _ConfigListItem(
            title: 'keyAlias',
            subtitle: '密钥别名',
            supportingText: '',
            value: model.signConfig?.keyAlias ?? '',
            name: 'keyAlias',
            showFilePicker: false,
            model: model,
          ), */

          // const SizedBox(height: 8),
          // keyPwd - 密钥密码
          /* _ConfigListItem(
            title: 'keyPwd',
            subtitle: '密钥密码',
            supportingText: '',
            value: model.signConfig?.keystorePwd ?? '',
            name: 'keystorePwd',
            showFilePicker: false,
            model: model,
          ),
         */
        ],
      ),
    );
  }
}

/// 配置项组件
///
/// 根据 Pixso 设计稿 (item-id: 5:17490) 实现
/// 高度 96px，包含标题、副标题、支持文字和更换按钮
class _ConfigListItem extends StatelessWidget {
  const _ConfigListItem({
    required this.title,
    required this.subtitle,
    required this.supportingText,
    required this.value,
    required this.name,
    required this.showFilePicker,
    required this.model,
  });

  final String title;
  final String subtitle;
  final String supportingText;
  final String value;
  final String name;
  final bool showFilePicker;
  final EcoViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (supportingText.isNotEmpty) {
            // 过滤 "命令: " 前缀，只复制实际命令
            final command = supportingText.replaceFirst('命令: ', '');
            Clipboard.setData(ClipboardData(text: command));
            _showToast(context, '命令已复制到剪贴板');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 左侧内容区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 标题
                    Text(
                      '$title${subtitle.isNotEmpty ? ' $subtitle' : ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(29, 27, 32, 1),
                        height: 24 / 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // 支持文字（命令提示）
                    if (supportingText.isNotEmpty)
                      Text(
                        supportingText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(73, 69, 79, 1),
                          height: 16 / 12,
                          letterSpacing: 0.25,
                        ),
                      ),
                  ],
                ),
              ),
              // 右侧更换按钮
              _ChangeButton(
                onPressed: () => _showEditDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示编辑对话框
  ///
  /// 对于 p12 和 csr 显示文件选择按钮
  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('编辑 $name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(controller: controller),
            const SizedBox(height: 10),
            if (showFilePicker)
              TextButton(
                onPressed: () async {
                  final filePath = await selectStoreFile();
                  if (filePath != null) {
                    controller.text = filePath;
                  }
                },
                child: const Text('选择文件'),
              ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              _updateConfig(controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// 当前 Toast 的 OverlayEntry（防止叠加）
  static OverlayEntry? _currentToastEntry;

  /// 显示轻提示 Toast
  ///
  /// 使用 Overlay 显示 toast，避免被半模态遮挡
  /// 包含淡入淡出动画，多次调用会替换之前的 toast
  void _showToast(BuildContext context, String message) {
    // 移除之前的 toast
    _currentToastEntry?.remove();
    _currentToastEntry = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onDismiss: () {
          if (_currentToastEntry == entry) {
            entry.remove();
            _currentToastEntry = null;
          }
        },
      ),
    );
    _currentToastEntry = entry;
    overlay.insert(entry);
  }

  /// 更新配置项
  ///
  /// 根据配置名称更新对应的值并保存
  void _updateConfig(String newValue) {
    final config = model.signConfig;
    if (config == null) return;

    switch (name) {
      case 'p12':
        config.keystoreFile = newValue;
        break;
      case 'csr':
        config.csrPath = newValue;
        break;
      case 'keyAlias':
        config.keyAlias = newValue;
        break;
      case 'keystorePwd':
        config.keystorePwd = newValue;
        break;
    }
    model.saveSignConfig();
  }
}

/// 更换按钮组件
///
/// 根据 Pixso 设计稿 (item-id: 5:17502) 实现
/// 淡蓝色背景、蓝色文字、圆角 100px
class _ChangeButton extends StatelessWidget {
  const _ChangeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(57, 107, 223, 0.08),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Center(
          child: Text(
            '更换',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(57, 107, 223, 1),
              height: 14 / 12,
            ),
          ),
        ),
      ),
    );
  }
}

/// Toast 轻提示组件
///
/// 使用 Overlay 显示，避免被半模态遮挡
/// 包含淡入淡出动画
class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 延迟一帧后开始淡入，避免抖动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // 2秒后淡出并移除
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _opacity = 0.0);
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            widget.onDismiss();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
