import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/hdc/common.dart';
import 'package:provider/provider.dart';

class SignConfigPage extends StatelessWidget {
  const SignConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (_, model, child) {
        return ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "签名配置",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text("p12"),
              subtitle: Text("证书密钥，用于创建csr,cer,p7b等文件"),
              onTap: () {
                toask(context, "已复制到剪贴板");
                Clipboard.setData(
                  ClipboardData(text: model.signConfig?.keystoreFile ?? ""),
                );
              },
              trailing: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => EditConfigDialog(
                          name: "p12",
                          value: model.signConfig?.keystoreFile ?? "",
                          onChange: (p0) => model.signConfig?.keystoreFile = p0,
                        ),
                  );
                },
                child: Text("更换"),
              ),
            ),
            ListTile(
              title: Text("csr"),
              subtitle: Text("通过p12创建, 用于申请cer证书"),
              onTap: () {
                toask(context, "已复制到剪贴板");
                Clipboard.setData(
                  ClipboardData(text: model.signConfig?.csrPath ?? ""),
                );
              },
              trailing: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => EditConfigDialog(
                          name: "csr",
                          value: model.signConfig?.csrPath ?? "",
                          onChange: (p0) => model.signConfig?.csrPath = p0,
                        ),
                  );
                },
                child: Text("更换"),
              ),
            ),
            ListTile(
              title: Text("keyAlias"),
              subtitle: Text("密钥别名"),
              onTap: () {
                toask(context, "已复制到剪贴板");
                Clipboard.setData(
                  ClipboardData(text: "${model.signConfig?.keyAlias}"),
                );
              },
              trailing: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => EditConfigDialog(
                          name: "keyAlias",
                          value: model.signConfig?.keyAlias ?? "",
                          onChange: (p0) => model.signConfig?.keyAlias = p0,
                        ),
                  );
                },
                child: Text("更换"),
              ),
            ),
            ListTile(
              title: Text("keyPwd"),
              subtitle: Text("密钥密码"),
              onTap: () {
                toask(context, "已复制到剪贴板");
                Clipboard.setData(
                  ClipboardData(text: "${model.signConfig?.keystorePwd}"),
                );
              },
              trailing: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => EditConfigDialog(
                          name: "keystorePwd",
                          value: model.signConfig?.keystorePwd ?? "",
                          onChange: (p0) => model.signConfig?.keyAlias = p0,
                        ),
                  );
                },
                child: Text("更换"),
              ),
            ),
          ],
        );
      },
    );
  }
}

showConfigEditAlert(EcoViewModel model, BuildContext context, String name) {
  var value = "";
  final config = model.signConfig;
  switch (name) {
    case "p12":
      value = config?.keystoreFile ?? "";
      break;
    case "csr":
      value = config?.csrPath ?? "";
      break;
    case "keyAlias":
      value = config?.keyAlias ?? "";
      break;
    case "keystorePwd":
      value = config?.keystorePwd ?? "";
      break;
  }
  showDialog(
    context: context,
    builder:
        (_) => EditConfigDialog(
          name: name,
          value: value,
          onChange: (p0) {
            switch (name) {
              case "p12":
                config?.keystoreFile = p0;
                break;
              case "csr":
                config?.csrPath = p0;
                break;
              case "keyAlias":
                config?.keyAlias = p0;
                break;
              case "keystorePwd":
                config?.keystorePwd = p0;
                break;
            }
            model.saveSignConfig();
          },
        ),
  );
}

class EditConfigDialog extends StatelessWidget {
  late TextEditingController controller;
  EditConfigDialog({
    super.key,
    required this.name,
    required value,
    this.onChange,
  }) {
    controller = TextEditingController(text: value);
  }
  final String name;
  final Function(String)? onChange;
  Widget _selectFile() {
    if (name == "p12" || name == "csr") {
      return TextButton(
        onPressed: () async {
          final filePath = await selectStoreFile();
          if (filePath != null) {
            controller.text = filePath;
          }
        },
        child: Text("选择文件"),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("编辑 $name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(controller: controller),
          const SizedBox(height: 10),
          _selectFile(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("确认"),
          onPressed: () {
            if (onChange != null) {
              onChange!(controller.text);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
