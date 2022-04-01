//بسم الله الرحمن الرحيم
import 'dart:ui';

import 'package:flutter/material.dart';

class SomethingIsWrongScreen extends StatefulWidget {
  @override
  _SomethingIsWrongScreenState createState() => _SomethingIsWrongScreenState();
}

class _SomethingIsWrongScreenState extends State<SomethingIsWrongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.indigo,
        child: Center(
          child: Container(
            width: 350,
            child: Text(
              "Error. Your device need location permission manually.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState(); //
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, 'WelcomeScreen');
    });
  }

/*  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Location'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    'For your device you need to add location permission manually.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                print('Confirmed');
                Navigator.pushReplacementNamed(context, "/WelcomeScreen");
                // bool isOpened = await LocationPermissions().openAppSettings();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/WelcomeScreen");
              },
            ),
          ],
        );
      },
    );
  }*/
}
