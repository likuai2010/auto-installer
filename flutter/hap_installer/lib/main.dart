import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/HistoryViewModel.dart';
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
  ThemeMode _themeMode = ThemeMode.light;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> HistoryViewModel() ),
        ChangeNotifierProxyProvider<HistoryViewModel, EcoViewModel>(
          create: (context) => viewmodel,
          update: (_, history, __) {
              viewmodel.historyViewModel = history;
            return viewmodel;
        }),
      ],
      child: MaterialApp(
        title: '小白调试助手',
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.black,
          brightness: Brightness.dark,
        ),
        home: Home(title: '小白调试助手'),
      ),
    );
  }
}
