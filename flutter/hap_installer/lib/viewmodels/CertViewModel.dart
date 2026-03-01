import 'package:flutter/material.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/models/EcoResult.dart';

class CertViewModel extends ChangeNotifier {
  List<CertInfo> certInfoList = [];
  String? get currentId => viewmodel.signConfig?.certId;
  CertViewModel() {
    fetchCertList();
  }
  bool get isLogin => viewmodel.isLogin;
  fetchCertList() async {
    certInfoList =
        (await eco.getCertList()).where((c) => c.certType == 1).toList();
    notifyListeners();
  }

  useCert(BuildContext context, CertInfo info) async {
    try {
      final signConfig = await viewmodel.changeCertConfig(info)!;
      final urlsInfo = await eco.downloadObj(info.certObjectId);
      await eco.downloadFile(urlsInfo.first.newUrl, signConfig.certPath);
    } catch (e) {
      toask(context, "应用证书失败: $e");
    }
    notifyListeners();
  }
  deleteCert(BuildContext context, CertInfo info) async {
    try {
      await eco.deleteCertList([info.id]);
      await fetchCertList();
    } catch (e) {
      toask(context, "应用证书失败: $e");
    }
    notifyListeners();
  }
}
