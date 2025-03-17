import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';

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
  });
  final Widget? leading;
  final String title;
  final String? subTitle;
  final Widget? tailling;
  final Function()? onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
            tailling ?? Icon(Icons.keyboard_arrow_right_outlined),
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

class ConnectDeviceBox extends StatefulWidget {
  const ConnectDeviceBox({super.key, required this.ip, required this.port});

  final String ip;
  final String port;
  @override
  State<StatefulWidget> createState() {
    return _ConnectDeviceBoxState();
  }
}

class _ConnectDeviceBoxState extends State<ConnectDeviceBox> {
  late TextEditingController ipController;
  late TextEditingController portController;
  bool connectiong = false;

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController(text: widget.ip);
    portController = TextEditingController(text: widget.port);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(
            leading: Container(),
            leadingWidth: 10,
            title: Text("连接设备"),
            actions: [const CloseButton()],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("请到开发者选择项-开启无线调试"),
                Text(
                  "Tip: 第一次可能失败，需要等待手机提示授权",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  maxLength: 15,
                  controller: ipController,
                  decoration: InputDecoration(
                    border: null,
                    labelText: "请输入IP",
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(":"),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  maxLength: 5,
                  controller: portController,
                  decoration: InputDecoration(
                    border: null,
                    enabledBorder: null,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    labelText: "请输入端口",
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (connectiong) return;
                  setState(() {
                    connectiong = true;
                  });
                  await viewmodel.connectDevice(
                    context,
                    ipController.text,
                    portController.text,
                  );
                  setState(() {
                    connectiong = false;
                  });
                  Navigator.pop(context);
                },
                icon:
                    !connectiong
                        ? Icon(Icons.check_circle)
                        : CircularProgressIndicator(value: null),
              ),
            ],
          ),
        ],
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
