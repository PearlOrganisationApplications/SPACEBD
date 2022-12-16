import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class NetworkCheck extends StatelessWidget {
  const NetworkCheck(
      {Key? key, required this.onlineScreen, required this.offlineScreen})
      : super(key: key);

  final Widget onlineScreen;
  final Widget offlineScreen;

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.online) {
      return onlineScreen;
    } else {
      return offlineScreen;
    }
  }
}
