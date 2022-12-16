import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage(String appUrl, {Key? key}) : super(key: key);
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: WebView(
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("mailto:") ||
                request.url.startsWith("tel:") ||
                request.url.startsWith("whatsapp:")) {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) => _controller = value);
            _controllerCompleter.complete(webViewController);
          },
          initialUrl: "https://development.pearl-developer.com/oleobd/public/",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Are You Sure! You Want To Quit",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffFF392F)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xffFF392F))),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
      return Future.value(true);
    }
  }

  // Future<bool> _onWillPopCallback() {}
}

void _launchURL(String _url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
