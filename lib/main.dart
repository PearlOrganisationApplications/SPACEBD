import 'dart:async';
import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'getdata.dart';
import 'home_page.dart';
import 'model/api_model.dart';
import 'webview_page.dart';

enum NetworkStatus { online, offline }

Future<void> main() async {
  var connectedornot = NetworkStatus.offline;

  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connectedornot = NetworkStatus.online;
    } else {
      connectedornot = NetworkStatus.offline;
    }
  } on SocketException catch (_) {
    connectedornot = NetworkStatus.offline;
  }
  runApp(MyApp(connectedornot: connectedornot));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.connectedornot}) : super(key: key);
  final connectedornot;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xff000000), statusBarBrightness: Brightness.dark));
    return GetMaterialApp(
      // color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: "OLEOBD",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AnimatedSplashScreen(
        backgroundColor: Colors.black,
        duration: 3000,
        splashIconSize: 180,
        splash: "assets/oleobd_logo white.png",
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: HomePage(
          connectedornot: connectedornot,
          title: "OLEOBD",
        ),
      ),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late Future<DataModel?> getDataModel;
  var iosVersion = "1";
  var androidVersion = "1";
  bool skipupdate = false;
  @override
  void initState() {
    getDataModel = GetData.getInfoData();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   /* Future.delayed(const Duration(milliseconds: 5000), () {
      _updateApp(context);
    });*/

    return  AnnotatedRegion<SystemUiOverlayStyle>( value:const SystemUiOverlayStyle(
      statusBarColor: Color(0xffffffff),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<DataModel?>(
          future: getDataModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (int.parse(snapshot.data!.message![0].iosAppVersionCode)>
                  int.parse(iosVersion)) {Future.delayed(const Duration(milliseconds:100), () {
                _updateApp(context);
              });
              }
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: WebViewPage(
                      snapshot.data!.message![0].appLink,
                    ),
                  ),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFFFFFFFF),
                      rightDotColor: const Color(0xffFF392F),
                      size: 80,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  // void _showAlert(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text("Wifi"),
  //         content: Text("Wifi not detected. Please activate it."),
  //       )
  //   );
  // }
  void _updateApp(BuildContext context) async {
   {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Update available",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffFF392F)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Skip"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xffFF392F))),
              onPressed: () {
                _launchURL("https://apps.apple.com/us/app/");
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}