
import 'package:flutter/material.dart';

class SignConfigPage extends StatelessWidget {
  const SignConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: Text("签名配置", style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(title: Text("1212"), selected: true, onTap:(){},),
        ListTile(title: Text("12")),
    ],);
  }


}