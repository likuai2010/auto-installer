import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserGuidePage extends StatelessWidget {
  UserGuidePage({super.key});

  // final pdfPinchController = PdfControllerPinch(
  //   document: PdfDocument.openAsset('assets/html/guide.pdf'),
  // );
  // final pdfController = PdfController(
  //   document: PdfDocument.openAsset('assets/html/guide.pdf'),
  // );
  Widget? buildPage() {
    // if (!Platform.isWindows) {
    //   return PdfViewPinch(controller: pdfPinchController);
    // } else {
    //   PdfView(controller: pdfController);
    // }
    return SfPdfViewer.asset('assets/html/guide.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('使用教程')),
      body: buildPage(),
    );
  }
}
