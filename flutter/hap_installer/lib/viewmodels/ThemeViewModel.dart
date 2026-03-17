import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题状态管理 ViewModel
///
/// 管理深色模式和跟随系统主题的状态，并通过 SharedPreferences 持久化用户偏好
class ThemeViewModel extends ChangeNotifier {
  /// 是否跟随系统深色模式
  bool _followSystemDarkMode = true;

  /// 是否启用深色模式（仅当不跟随系统时生效）
  bool _darkMode = false;

  bool _autoPort = true;
  /// SharedPreferences 实例
  SharedPreferences? _prefs;

  /// 持久化存储的 Key
  static const String _keyFollowSystem = 'theme_follow_system';
  static const String _keyDarkMode = 'theme_dark_mode';
    static const String _keyAutoPort = 'hdc_autoPort';

  /// 获取当前是否跟随系统深色模式
  bool get followSystemDarkMode => _followSystemDarkMode;

  /// 获取当前是否启用深色模式
  bool get darkMode => _darkMode;
  bool get autoPort => _autoPort;

  /// 从 SharedPreferences 加载主题设置
  ///
  /// 应在应用启动时调用
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _followSystemDarkMode = _prefs?.getBool(_keyFollowSystem) ?? true;
    _darkMode = _prefs?.getBool(_keyDarkMode) ?? false;
    notifyListeners();
  }

  /// 设置是否跟随系统深色模式
  ///
  /// [value] true 表示跟随系统，false 表示手动控制
  /// 开启时会自动关闭手动深色模式（互斥逻辑）
  Future<void> setFollowSystemDarkMode(bool value) async {
    if (_followSystemDarkMode == value) return;
    _followSystemDarkMode = value;
    if (value) {
      // 开启跟随系统时，关闭手动深色模式
      _darkMode = false;
      await _prefs?.setBool(_keyDarkMode, false);
    }
    await _prefs?.setBool(_keyFollowSystem, value);
    notifyListeners();
  }

  /// 设置深色模式开关
  ///
  /// [value] true 表示深色模式，false 表示浅色模式
  /// 开启时会自动关闭跟随系统模式（互斥逻辑）
  Future<void> setDarkMode(bool value) async {
    if (_darkMode == value) return;
    _darkMode = value;
    if (value) {
      // 开启深色模式时，关闭跟随系统
      _followSystemDarkMode = false;
      await _prefs?.setBool(_keyFollowSystem, false);
    }
    await _prefs?.setBool(_keyDarkMode, value);
    notifyListeners();
  }

   Future<void> setAutoPort(bool value) async {
    if (_autoPort == value) return;
    _autoPort = value;
    await _prefs?.setBool(_keyAutoPort, value);
    notifyListeners();
  }

  /// 获取当前 ThemeMode
  ///
  /// 根据 [followSystemDarkMode] 和 [darkMode] 计算得出
  ThemeMode get themeMode {
    if (_followSystemDarkMode) {
      return ThemeMode.system;
    }
    return _darkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
