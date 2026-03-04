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
                '导出命令: openssl pkcs12 -in xiaobai.p12 -nocerts -out key.pem -nodes',
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
                '创建命令: openssl req -new -key xiaobai.key -out xiaobai.csr',
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
      height: 96,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已复制到剪贴板'),
              duration: Duration(seconds: 1),
            ),
          );
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
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(29, 27, 32, 1),
                        height: 24 / 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // 副标题
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(73, 69, 79, 1),
                          height: 20 / 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                    // 支持文字
                    if (supportingText.isNotEmpty)
                      Text(
                        supportingText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(73, 69, 79, 1),
                          height: 20 / 14,
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
