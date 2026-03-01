import 'package:hap_installer/hdc/loginhuawei.dart';

/// 首页视图模型
///
/// 负责首页相关的业务逻辑，包括打开外部链接等
class HomeViewModel {
  /// 打开 GitHub 仓库页面
  Future<void> openGitHub() async {
    await openByUrl('https://github.com/aspect-apps/aspect-apps');
  }

  /// 打开赞助页面
  Future<void> openSponsor() async {
    await openByUrl('https://afdian.com/a/xiaobaigroup');
  }
}

final homeViewModel = HomeViewModel();
