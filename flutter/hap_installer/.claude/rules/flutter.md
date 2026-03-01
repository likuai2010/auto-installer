# Flutter Development Rules

> 本文件定义了 Flutter 项目开发规范，包括代码风格、分析命令和提交规范。

## 代码分析

### 必须运行的命令

在提交代码前，必须运行以下命令确保代码质量：

```bash
# 静态分析（检查错误和警告）
flutter analyze lib/

# 仅分析 viewmodels 目录
flutter analyze lib/viewmodels/

# 仅分析 pages 目录
flutter analyze lib/pages/
```

### 分析结果处理优先级

1. **error** - 必须修复，阻塞提交
2. **warning** - 应该修复，特殊情况可忽略
3. **info** - 建议修复，不阻塞提交

### 常见问题修复

| 问题类型 | 修复方法 |
|---------|---------|
| `unused_import` | 删除未使用的导入 |
| `undefined_identifier` | 检查拼写或导入缺失 |
| `uri_does_not_exist` | 检查导入路径是否正确 |
| `use_build_context_synchronously` | 添加 `mounted` 检查或使用 `if (!context.mounted) return` |

## ViewModel 规范

### 目录结构

所有 ViewModel 必须放在 `lib/viewmodels/` 目录：

```
lib/
├── viewmodels/
│   ├── EcoViewModel.dart      # 主业务逻辑
│   ├── HistoryViewModel.dart  # 历史记录
│   ├── CertViewModel.dart     # 证书管理
│   └── HomeViewModel.dart     # 首页逻辑
├── pages/
├── models/
└── ...
```

### 导入路径规范

```dart
// 正确 ✅
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/viewmodels/HomeViewModel.dart';

// 错误 ❌
import 'package:hap_installer/EcoViewModel.dart';
```

### ViewModel 命名规范

- 文件名：`XxxViewModel.dart`（PascalCase）
- 类名：`XxxViewModel`（与文件名一致）
- 全局实例：`xxxViewModel`（camelCase）

### ViewModel 职责划分

| ViewModel | 职责 |
|-----------|------|
| `EcoViewModel` | 设备管理、HAP 操作、签名配置 |
| `HistoryViewModel` | 调试历史记录管理 |
| `CertViewModel` | 证书申请和管理 |
| `HomeViewModel` | 首页相关业务（打开链接等） |

### 添加新 ViewModel 步骤

1. 在 `lib/viewmodels/` 创建文件
2. 继承 `ChangeNotifier`
3. 创建全局实例 `final xxxViewModel = XxxViewModel();`
4. 在 `lib/main.dart` 中注册 Provider
5. 更新 CLAUDE.md 中的文件引用表

## 跨平台 URL 打开

使用 `openByUrl()` 函数而非直接使用 `url_launcher`：

```dart
// 正确 ✅ - 跨平台兼容
import 'package:hap_installer/hdc/loginhuawei.dart';
await openByUrl('https://example.com');

// 错误 ❌ - HarmonyOS 不兼容
import 'package:url_launcher/url_launcher.dart';
await launchUrl(Uri.parse('https://example.com'));
```

## 禁止事项

- 禁止在 `lib/` 根目录创建 ViewModel 文件
- 禁止直接使用 `url_launcher` 的 `launchUrl()`（使用 `openByUrl()`）
- 禁止在 ViewModel 中硬编码 URL（应作为常量或配置）
