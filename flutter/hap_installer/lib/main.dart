import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/pages/splash_screen.dart';
import 'package:provider/provider.dart';

main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const platform = MethodChannel("com.xiaobai.hap_instaler/openFile");
  final ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
     platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "openFile") {
        var url = call.arguments['url'];
        viewmodel.openFile(context, url);
      }
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ChangeNotifierProxyProvider<HistoryViewModel, EcoViewModel>(
          create: (context) => viewmodel,
          update: (_, history, __) {
            viewmodel.historyViewModel = history;
            return viewmodel;
          },
        ),
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
        home: const SplashScreen(),
      ),
    );
  }
}
