import 'dart:io';

import 'package:flutter_share_me/flutter_share_me.dart';

class Share{

  String? launchURL()  {
    var url;
    if (Platform.isAndroid)
      return url = 'https://play.google.com/store/apps/details?id=com.shoeljoe_app';
    else if (Platform.isIOS)
      return url = 'https://apps.apple.com/us/app/appname/id148563';
  }
  Future<void> onButtonTap(shareMedium) async {
    String msg =
        'ShnulJoe';
    String? url = launchURL();

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (shareMedium) {
      case "Facebook":
        response = await flutterShareMe.shareToFacebook(url: url!, msg: msg);
        break;
    }


  }}