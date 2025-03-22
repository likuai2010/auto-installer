import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalWebView extends StatefulWidget {
  const LocalWebView({super.key, required this.url, this.isFile = true});

  final String url;
  final bool isFile;
  @override
  _LocalWebViewState createState() => _LocalWebViewState();
}

class _LocalWebViewState extends State<LocalWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          );
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    if (!widget.isFile) {
      _controller.loadRequest(Uri.parse(widget.url));
    } else {
      _controller.loadFlutterAsset('assets/html/disclaimer.html');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
