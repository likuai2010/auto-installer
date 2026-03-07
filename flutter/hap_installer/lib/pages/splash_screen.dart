import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/pages/Index.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/hdc/common.dart';

/// 启动页
///
/// 显示应用图标和加载状态
/// 支持深色模式适配
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// 初始化 Future
  Future<bool>? _initFuture;

  /// 自动连接开关状态
  bool _autoConnect = false;

  @override
  void initState() {
    super.initState();
    _loadSettingsAndStartInit();
  }

  /// 加载设置并开始初始化
  Future<void> _loadSettingsAndStartInit() async {
    // 加载自动连接设置
    final autoConnect = await getAutoConnect();
    setState(() {
      _autoConnect = autoConnect;
      _initFuture = viewmodel.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        // 加载完成，进入主页
        if (snapshot.hasData && snapshot.data == true) {
          return const Index();
        }

        // 显示启动页
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 应用图标
                _buildAppIcon(context),
                const SizedBox(height: 24),
                // 加载提示
                _buildLoadingHint(context),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建应用图标
  Widget _buildAppIcon(BuildContext context) {
    return Image.asset(
      'lib/assets/Icon.png',
      width: 80,
      height: 80,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.apps,
        size: 80,
        color: AppColors.brandDynamic(context),
      ),
    );
  }

  /// 构建加载提示
  ///
  /// 根据自动连接开关状态显示不同提示文字
  Widget _buildLoadingHint(BuildContext context) {
    return Text(
      _autoConnect ? "自动连接上次设备..." : "启动中请稍后...",
      style: TextStyle(
        fontSize: 16,
        color: AppColors.fontSecondaryDynamic(context),
      ),
    );
  }
}
