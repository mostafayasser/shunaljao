//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shnuljoe/Services/FacebookAPIs.dart';
import 'package:the_apple_sign_in/scope.dart';

import '../../Constants.dart';
import '../../Strings.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  bool enable = false;
  @override
  Widget build(BuildContext context) {
    /* if (enable) {
      askPermission();
    }*/

    return Scaffold(body: Consumer<FacebookAPI>(
      builder: (context, model, child) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/backgroundclear.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/logo.svg',
                width: 200.w,
                height: 180.h,
              ),
              SizedBox(height: 75.h),
              Text(
                welcomeTextAr,
                style: welcomeTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 230.h),
              InkWell(
                onTap: () async {
                  // await Provider.of<FacebookAPI>(context, listen: false)
                  //       .handleLogin(context);
                  model.handleLogin(context);
                  fbSignInEvent(context);
                  saveIntInLocalMemory.call("login", 1);
                  await FirebaseAnalytics().logEvent(
                    name: 'Facebook_Login',
                    parameters: <String, dynamic>{
                      'Facebook_Login': "Success",
                    },
                  );

                  /* if (Provider.of<FacebookAPI>(context, listen: false).isSignIn) {
                  var pref = await SharedPreferences.getInstance();
                  bool v = pref.getBool('isFirstTime');
                  if (v == null) v = true;
                  if (v) {
                    Navigator.pushReplacementNamed(context, "/IntroSlider");
                    pref.setBool('isFirstTime', !v);
                    pref.setBool('isLogIn', true);
                    print('First Time &&&&&&' + v.toString());
                  } else {
                    Navigator.pushReplacementNamed(context, "/HomeScreen");
                    print('First Time &&&&&& ELSE' + v.toString());
                  }
                }*/
                },
                child: Container(
                    //width: 275.w,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: fbButtonColor, //primaryColorBlue,
                        borderRadius: BorderRadius.circular(13.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 8,
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                signInAr,
                                style: h3Arial,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            )),
                        SizedBox(
                          width: 15.w,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FaIcon(
                              FontAwesomeIcons.facebookSquare,
                              size: 25.h,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(height: 10.h),
              Platform.isIOS
                  ? InkWell(
                      onTap: () async {
                        // await Provider.of<FacebookAPI>(context, listen: false)
                        //       .handleLogin(context);

                        model.signInWithApple(
                            scopes: [Scope.email, Scope.fullName],
                            context: context);
                        saveIntInLocalMemory.call("login", 1);
                        await FirebaseAnalytics().logEvent(
                          name: 'Apple_Login',
                          parameters: <String, dynamic>{
                            'Apple_Login': "Success",
                          },
                        );

                        /* if (Provider.of<FacebookAPI>(context, listen: false).isSignIn) {
                  var pref = await SharedPreferences.getInstance();
                  bool v = pref.getBool('isFirstTime');
                  if (v == null) v = true;
                  if (v) {
                    Navigator.pushReplacementNamed(context, "/IntroSlider");
                    pref.setBool('isFirstTime', !v);
                    pref.setBool('isLogIn', true);
                    print('First Time &&&&&&' + v.toString());
                  } else {
                    Navigator.pushReplacementNamed(context, "/HomeScreen");
                    print('First Time &&&&&& ELSE' + v.toString());
                  }
                }*/
                      },
                      child: Container(
                          //width: 275.w,
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          alignment: Alignment.center,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: appleColor, //primaryColorBlue,
                              borderRadius: BorderRadius.circular(13.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 8,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        signInApple,
                                        style: h3Arial,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ))),
                              SizedBox(
                                width: 15.w,
                              ),
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FaIcon(
                                      FontAwesomeIcons.apple,
                                      size: 25.h,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          )),
                    )
                  : SizedBox()
            ],
          ),
        );
      },
    ));

/*
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/backgroundclear.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/logo.svg',
              width: 200.w,
              height: 180.h,
            ),
            SizedBox(height: 75.h),
            Text(
              welcomeTextAr,
              style: welcomeTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 230.h),
            InkWell(
              onTap: () async {
                await Provider.of<FacebookAPI>(context, listen: false)
                    .handleLogin(context);
                fbSignInEvent(context);
                saveIntInLocalMemory.call("login", 1);
                await FirebaseAnalytics().logEvent(
                  name: 'Facebook_Login',
                  parameters: <String, dynamic>{
                    'Facebook_Login': "Success",
                  },
                );

                */ /* if (Provider.of<FacebookAPI>(context, listen: false).isSignIn) {
                  var pref = await SharedPreferences.getInstance();
                  bool v = pref.getBool('isFirstTime');
                  if (v == null) v = true;
                  if (v) {
                    Navigator.pushReplacementNamed(context, "/IntroSlider");
                    pref.setBool('isFirstTime', !v);
                    pref.setBool('isLogIn', true);
                    print('First Time &&&&&&' + v.toString());
                  } else {
                    Navigator.pushReplacementNamed(context, "/HomeScreen");
                    print('First Time &&&&&& ELSE' + v.toString());
                  }
                }*/ /*
              },
              child: Container(
                width: 240.w,
                height: 40.h,
                decoration: BoxDecoration(
                    color: primaryColorBlue,
                    borderRadius: BorderRadius.circular(36.r)),
                child: Center(
                  child: Text(
                    signInAr,
                    style: h3Arial,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  Future<void> saveIntInLocalMemory(String key, int value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ConnectivityResult result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(
                    "لا يوجد اتصال بالانترنت",
                    textAlign: TextAlign.center,
                  ),
                ));
      }
      Future.delayed(Duration(seconds: 1), () {
        // 5s over, navigate to a new page
        askPermission().then((value) => null);
      });
    });
  }

  Future askPermission() async {
    //  print("umer again " + enable.toString());
    await FirebaseAnalytics().logEvent(
      name: 'Location_Request',
      parameters: <String, dynamic>{
        'Location_Request': "success",
      },
    );
    /* bool result = await location.enableBackgroundMode(enable: false);
    print("umer again result" + result.toString());
    if (result) {
      setState(() {
        enable = true;
      });
    }*/
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      gpsDenyEvent(context);
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      } else {
        gpsAcceptEvent(context);
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      return;
    }
  }

/*  Future<bool> checkLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    return _serviceEnabled;
  }*/

  Future fbSignInEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Sign_In',
      parameters: <String, dynamic>{
        'Sign_In': "Success",
      },
    );
  }

  Future gpsAcceptEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Accept_GPS',
      parameters: <String, dynamic>{
        'Accept_GPS': "Success",
      },
    );
  }

  Future gpsDenyEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Deny_GPS',
      parameters: <String, dynamic>{
        'Deny_GPS': "Success",
      },
    );
  }
}
