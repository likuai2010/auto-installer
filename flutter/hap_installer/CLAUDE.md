# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

小白调试助手 (HAP Installer) - A Flutter desktop/mobile application for HarmonyOS development, providing HAP file installation, signing, and device debugging capabilities.

## Project Rules

项目规则定义在 `.claude/rules/` 目录：

- **flutter.md** - Flutter 开发规范、ViewModel 规范、代码分析命令
- **git-workflow.md** - Git 提交规范、分支管理策略

## Common Commands

### Flutter Development
```bash
# Install dependencies
flutter pub get

# Generate FFI bindings (after modifying cpp/hdctools/hdc.h)
dart run ffigen --config ffigen.yaml

# Generate freezed/json_serializable code (after modifying models)
dart run build_runner build

# Run the application
flutter run -d macos    # or -d windows, -d linux, -d chrome

# Build release
flutter build macos     # or windows, linux

# Static analysis (run before commit)
flutter analyze lib/
```

### Native C++ Build
```bash
# Build native libraries (from cpp/ directory)
cd cpp
./start_build.sh macos    # or linux, windows, android
```

## Architecture

### Flutter Layer (`lib/`)
- **main.dart** - App entry point with Provider state management
- **viewmodels/** - State management with ChangeNotifier pattern
  - `EcoViewModel.dart` - Main business logic: device management, HAP operations, signing
  - `HistoryViewModel.dart` - Debug history records
  - `CertViewModel.dart` - Certificate management
  - `HomeViewModel.dart` - Home page logic (URL opening, etc.)
- **hdc/CmdService.dart** - Native command service wrapper (FFI calls)
- **hdc/EcoServices.dart** - Eco system integration services
- **pages/** - UI pages (Home, sign_config_page, hdc_cmd_page, etc.)
- **models/** - Data models using freezed + json_serializable

### Native Layer (`cpp/`)
- **hdctools/** - HDC (HarmonyOS Device Connector) implementation
- **hapsigner/** - HAP signing tools with OpenSSL
- **unhap/** - HAP unpacking library
- **packing_tool/** - HAP packing tools
- **third_party/** - Dependencies (OpenSSL, cJSON, bounds_checking_function)

### Plugin Layer (`plugins/`)
- **native_core** - FFI plugin exposing native functions to Dart:
  - `hdcCmd()` - Execute HDC commands
  - `signCmd()` - Sign HAP files
  - `unHap()/unApp()` - Unpack HAP/App files
- **ohos_adapter** - Platform interface for HarmonyOS-specific functionality

### Platform Support
- macOS, Windows, Linux (desktop)
- Android, iOS (mobile)
- HarmonyOS (via `ohos/` directory)

## Key Patterns

### State Management
Uses Provider with ChangeNotifier pattern:
- `EcoViewModel` - Primary state (devices, files, signing config)
- `HistoryViewModel` - Debug history records
- All ViewModels must be in `lib/viewmodels/` directory

### Cross-Platform URL Opening
Use `openByUrl()` instead of `url_launcher` directly for HarmonyOS compatibility:
```dart
import 'package:hap_installer/hdc/loginhuawei.dart';
await openByUrl('https://example.com');
```

### Native FFI Integration
1. Define C functions in `cpp/hdctools/hdc.h`
2. Run `dart run ffigen --config ffigen.yaml` to generate bindings
3. Bindings output to `lib/native/hdc_ffi_generated.dart`
4. Wrapper functions in `plugins/native_core/lib/native_core.dart`

### Data Models
Models in `lib/models/` use code generation:
- Annotate with `@freezed` and `@JsonSerializable`
- Run `dart run build_runner build` after changes
- Generated files in `lib/models/generated/`

## File References

| Purpose | File |
|---------|------|
| App entry | `lib/main.dart` |
| Main state | `lib/viewmodels/EcoViewModel.dart` |
| Home state | `lib/viewmodels/HomeViewModel.dart` |
| Native commands | `lib/hdc/CmdService.dart` |
| FFI bindings | `plugins/native_core/lib/native_core.dart` |
| Native header | `cpp/hdctools/hdc.h` |
| CMake config | `cpp/CMakeLists.txt` |
| FFI config | `ffigen.yaml` |
| Flutter rules | `.claude/rules/flutter.md` |
| Git rules | `.claude/rules/git-workflow.md` |
