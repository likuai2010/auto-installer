import 'package:flutter/material.dart';

//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});
  Widget? buildPage() {
    // return SfPdfViewer.asset('assets/html/guide.pdf');
    return PdfViewer.openAsset('assets/html/guide.pdf');
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
