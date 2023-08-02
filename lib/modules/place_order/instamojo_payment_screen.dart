import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/remote_urls.dart';
import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '/utils/language_string.dart';

class InstamojoPaymentScreen extends StatefulWidget {
  const InstamojoPaymentScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<InstamojoPaymentScreen> createState() => _InstamojoPaymentState();
}

class _InstamojoPaymentState extends State<InstamojoPaymentScreen> {
  double value = 0.0;

  bool _canRedirect = true;

  bool _isLoading = true;

  late WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(Language.payments),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => _exitApp(context),
          ),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            if (_isLoading)
              Center(
                child: LinearProgressIndicator(
                  value: value,
                ),
              ),
            Expanded(
              child: Container(
                color: redColor,
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.url,
                  gestureNavigationEnabled: true,
                  userAgent:
                      'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    controllerGlobal = webViewController;

                    //_controller.future.catchError(onError)
                  },
                  onProgress: (int progress) {
                    setState(() {
                      value = progress / 100;
                    });
                    log("WebView is loading (progress : $progress%)");
                  },
                  onPageStarted: (String url) {
                    log('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });
                    log("printing urls " + url.toString());
                    _redirect(url);
                  },
                  onPageFinished: (String url) {
                    log('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                    _redirect(url);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _redirect(String url) {
    if (_canRedirect) {
      bool _isSuccess = url.contains('/order-success-url-for-mobile-app') &&
          url.contains(RemoteUrls.rootUrl);
      bool _isFailed = url.contains('fail') && url.contains(RemoteUrls.rootUrl);
      bool _isCancel = url.contains('/instamojo-payment-cancled') &&
          url.contains(RemoteUrls.rootUrl);
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
        getData();
      } else if (_isFailed || _isCancel) {
        Utils.errorSnackBar(context, 'Payment Failed');
        Navigator.pop(context);
        return;
      } else {
        log("Encountered problem");
      }
    }
  }

  void getData() {
    controllerGlobal
        .runJavascriptReturningResult("document.body.innerText")
        .then(
      (data) {
        var decodedJSON = jsonDecode(data);
        var responseJSON = jsonDecode(decodedJSON);
        log(decodedJSON, name: 'InstamojoPaymentScreen');
        if (responseJSON["result"] == false) {
          Utils.errorSnackBar(context, responseJSON["message"]);
        } else if (responseJSON["result"] == true) {
          Utils.showSnackBar(context, responseJSON["message"]);
        }
        // Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.orderScreen, (route) {
          if (route.settings.name == RouteNames.mainPage) {
            return true;
          }
          return false;
        });
      },
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      return true;
    }
  }
}
