import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/hdc/loginhuawei.dart';
import 'package:hap_installer/pages/Home.dart';

final server = LoginHuawei();
void main() {
  server.startListening();
  runApp(const App());
  viewmodel.init();
}

void showMaterialToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // 显示时间
      behavior: SnackBarBehavior.fixed, // 悬浮显示
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  
  bool get _useLightMode => switch (_themeMode) {
    ThemeMode.system =>
      View.of(context).platformDispatcher.platformBrightness == Brightness.light,
    ThemeMode.light => true,
    ThemeMode.dark => false,
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '调试助手',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        brightness: Brightness.light,
      ),
      home: Home(
        title: 'Flutter Demo Home Page',
        useLightMode: _useLightMode
      ),
    );
  }
}

