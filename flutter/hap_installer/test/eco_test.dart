import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hap_installer/hdc/EcoServices.dart';

import 'package:hap_installer/main.dart';
import 'package:hap_installer/models/AuthInfo.dart';

final TestToken = "tempToken=d162478c1c9f808fe22b2a57ad9e76b530781b45cc700afd8114eb8618eca403b297998272061f69428232cd5ac57b7af58306bd67fe102fd334ddb5241c2ff60b45bebb4375a18bf981c3e27ca004f9bddc24530a0b6c05b3af93607cb05b174c0c5d6011ae3a7457765e18ff5d6fab687fb870941d61eaa1ec9eb4cf3953db9fbfcc32f3921f04b255b25aceb2ce82d7993657852201a14b05ad1306d02d3120f9f9f4439968bfd1f0e7ca75cfb5cd504741e3d4e08506e36d44cdb2467a434f4c1cacdacc599fdc533e0c5224ec93ce9f83f752762dde385b2b840cde6c562f603f0f47d0e5b3dd84c04094fc4a56cd65f64e770cf63eb4776df9e82ee95f8b8aae07ba896f3a45d8176f6ae1d2012fe553c1ba5e5309f01549460ee18e6faaa9952a6a46bac5452b6022d7f5533392e48502030ec1eb43796960c8577d4e0990c3ad0dbecfc06caef81fe9da21a9cb3b78b9c05f995feb99c984f5348ac1ea7953d7ffc04ef7854dc00491425883459b405fdd40178ea316a4394ca91d4957a99b6606c3c4d1dacd841fbd9384d25ada35c875af4ef805881be7066baceaaa8509fab294ffcb631817459d6570d193d4bb878dd5ae83fa2e4272103775d3ffb67148df74737738eb18a5ffbe73155991bc44f8a52982c6f3bb7a0a56213cffe372a8ef65eed3e9bdc878ed60f2d669ef92b604e40802802a2e9c3b5cff01&siteId=1&code=20698961dd4f420c8b44f49010c6f0cc";void main() {
  
final TestAuthInfo = AuthInfo(accessToken: "DQEAAHw5MieiKsmeZSKSX8VZo/jIQuiGhSBX2oDAcVY8okKe0eOgS1ITi5ElDsdjmyqgGZ1Iu9I83wvvI80+CN1QW9zCwyqo/P40e3Qqly3/yEs33mm6svoM2sD+mFvRuQ==", userId: "2850086000506643987");
group("test eco services", (){
    final service = EcoService();
    test("test base",() async {
        service.initUserInfo(TestAuthInfo);
        var result = await service.deviceList();
        expect(result, "xxxx");
    });

  });
}