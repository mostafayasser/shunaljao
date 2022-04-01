//بسم الله الرحمن الرحيم
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFE31C84),
        child: Center(
          child: Container(
            child: Image.asset(
              "images/loading2.gif",
            ),
          ),
        ),
      ),
    );
  }
}
