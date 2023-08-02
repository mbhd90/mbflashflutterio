import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({
    required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    /*final uri = Uri.directory(this.selectedUrl);
    final uriString = uri.toString().substring(0, uri.toString().length - 1);
    print("uriString === " + uriString);*/
    return Scaffold(
        body: WebView(
      initialUrl: this.selectedUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    ));
  }
}
