# Git Workflow Rules

> 本文件定义了 Git 提交规范和分支管理策略。

## Commit Message 格式

```
<type>: <description>
```

### Type 类型说明

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: 添加 HomeViewModel 支持 URL 打开` |
| `fix` | Bug 修复 | `fix: 修复 HarmonyOS 平台 URL 打开异常` |
| `refactor` | 重构（不改变功能） | `refactor: 迁移 ViewModel 到 viewmodels 目录` |
| `docs` | 文档更新 | `docs: 更新项目架构说明` |
| `test` | 测试相关 | `test: 添加 EcoViewModel 单元测试` |
| `chore` | 构建/工具相关 | `chore: 更新 Flutter SDK 版本` |
| `perf` | 性能优化 | `perf: 优化设备列表加载速度` |
| `style` | 代码格式（不影响逻辑） | `style: 格式化 home_page.dart` |

### Description 规范

- 使用中文描述
- 简洁明了，不超过 50 字符
- 使用祈使句（如"添加"而非"添加了"）
- 不以句号结尾

### 示例

```bash
# 好的提交 ✅
feat: 添加 HomeViewModel 支持 URL 打开
fix: 修复 HarmonyOS 平台 MissingPluginException 异常
refactor: 统一 ViewModel 到 viewmodels 目录

# 不好的提交 ❌
update code
修复bug
添加了一些功能
```

## 提交前检查清单

- [ ] `flutter analyze lib/` 无 error
- [ ] 代码格式化完成
- [ ] 无硬编码的敏感信息
- [ ] 新增 ViewModel 已放入 `viewmodels/` 目录
- [ ] 导入路径使用 `package:hap_installer/viewmodels/xxx`

## 分支规范

| 分支 | 用途 |
|------|------|
| `main` | 生产分支，稳定版本 |
| `feature/*` | 功能开发分支 |
| `fix/*` | Bug 修复分支 |
| `refactor/*` | 重构分支 |

## PR 规范

标题格式：
```
<type>: <简短描述>
```

Body 包含：
1. **变更说明** - 做了什么改动
2. **测试方案** - 如何验证
3. **截图**（如涉及 UI 变更）
