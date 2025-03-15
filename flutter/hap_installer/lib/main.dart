import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/pages/Home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
  viewmodel.init();
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;

  bool get _useLightMode => switch (_themeMode) {
    ThemeMode.system =>
      View.of(context).platformDispatcher.platformBrightness ==
          Brightness.light,
    ThemeMode.light => true,
    ThemeMode.dark => false,
  };

  @override
  Widget build(BuildContext context) {
    viewmodel.loadUserInfo(context);
    return ChangeNotifierProvider(
      create: (_) => viewmodel,
      child: MaterialApp(
        title: '小白调试助手',
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          brightness: Brightness.light,
        ),
        home: Home(title: '小白调试助手', useLightMode: _useLightMode),
      ),
    );
  }
}
