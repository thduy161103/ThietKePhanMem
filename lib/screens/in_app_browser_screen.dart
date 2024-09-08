import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowserScreen extends StatelessWidget {
  final String url;

  const InAppBrowserScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Game'),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}