import 'package:flutter/material.dart';
import 'package:hap_installer/CertViewModel.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CertPage extends StatelessWidget {
  const CertPage({super.key});

  Widget _certList(context, CertViewModel model) {
    List<Widget> list =
        model.certInfoList
            .map(
              (CertInfo d) => CertItem(
                info: d,
                currentId: model.currentId,
                onclick: () {
                  showAlert(
                    context,
                    title: Text("是否下载证书并应用?"),
                    content: Text("注意: 需要使用对应的p12文件, 不一致将导致签名失败(p12是自己创建的密钥)"),
                    onConfirm: () {
                      model.useCert(context, d);
                    },
                  );
                },
                onDelete: () {
                  showAlert(
                    context,
                    title: Text("是否删除当前证书?"),
                    content: Text("注意: 删除后此证书签名的Profile将失效"),
                    onConfirm: () {
                      model.deleteCert(context, d);
                    },
                  );
                },
              ),
            )
            .toList();
    return model.isLogin
        ? ListView(children: list)
        : Center(child: Text("未登录账号"));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return CertViewModel();
      },
      child: Consumer<CertViewModel>(
        builder: (context, model, child) {
          final texttheme = Theme.of(context).textTheme;
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "提示: 未实名开发者账号证书有效14天，实名后六个月。",
                    style: texttheme.labelSmall,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: _certList(context, model)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CertItem extends StatelessWidget {
  const CertItem({
    super.key,
    required this.info,
    required this.currentId,
    this.onclick,
    this.onDelete,
  });
  final String? currentId;
  final CertInfo info;
  final Function()? onclick;
  final Function()? onDelete;

  Widget? _actions(TextTheme textTheme) {
    if (info.certType == 2) {
      return Container();
    }
    Widget useText = Container();
    Widget deleteText = Container();
    if (isExpire(info.expireTime)) {
      deleteText = TextButton(
        onPressed: onDelete,
        child: Text("删除", style: textTheme.labelSmall),
      );
    } else {
      if (currentId == info.id) {
        useText = Text("正在使用", style: textTheme.labelSmall);
      } else {
        useText = TextButton(
          onPressed: onclick,
          child: Text("使用", style: textTheme.labelSmall),
        );
      }
    }
    return Row(children: [useText, deleteText, SizedBox(width: 6)]);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return GroupDecoration(
      children: [
        ListItem(
          leading: Icon(Icons.key_outlined),
          title: "${info.certType == 2 ? '发布' : '调试'}: ${info.certName}",
          subTitle: "于${formatTime(info.expireTime)}过期",
          tailling: _actions(textTheme),
          onLongPress: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 0), // 菜单位置
              items: [PopupMenuItem(child: Text('删除'), onTap: onDelete)],
            );
          },
        ),
      ],
    );
  }
}

String formatTime(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

bool isExpire(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateTime.now().isAfter(dateTime);
}
