import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HistoryViewModel.dart';
import 'package:hap_installer/viewmodels/ThemeViewModel.dart';
import 'package:hap_installer/pages/splash_screen.dart';
import 'package:provider/provider.dart';

/// 全局主题 ViewModel 实例
final themeViewModel = ThemeViewModel();
const String globalFontFamily = 'HarmonyOSSansSC';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 加载主题设置
  await themeViewModel.load();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const platform = MethodChannel("com.xiaobai.hap_instaler/openFile");

  @override
  Widget build(BuildContext context) {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "openFile") {
        var url = call.arguments['url'];
        viewmodel.openFile(context, url);
      }
    });
    viewmodel.historyViewModel = historyViewmodel;
    viewmodel.themeHistoryViewModel = themeViewModel;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeViewModel),
        ChangeNotifierProvider(create: (_) => historyViewmodel),
        ChangeNotifierProxyProvider<HistoryViewModel, EcoViewModel>(
          create: (context) => viewmodel,
          update: (_, history, __) {
            viewmodel.historyViewModel = historyViewmodel;
            return viewmodel;
          },
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, theme, _) => MaterialApp(
          title: '小白调试助手',
          themeMode: theme.themeMode,
          theme: ThemeData(
            fontFamily: globalFontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            fontFamily: globalFontFamily,
            colorSchemeSeed: Colors.black,
            brightness: Brightness.dark,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
