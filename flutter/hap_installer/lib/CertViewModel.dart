import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/hdc/EcoServices.dart';
import 'package:hap_installer/models/EcoResult.dart';

class CertViewModel extends ChangeNotifier {
  List<CertInfo>  certInfoList = [];
  CertViewModel(){
    fetchCertList();
  }
  bool get isLogin => viewmodel.isLogin;
  fetchCertList() async {
    certInfoList =  await eco.getCertList();
    notifyListeners();
  }
}