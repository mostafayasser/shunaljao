//@dart=2.9
//بسم الله الرحمن الرحيم
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Controller/SettingsController.dart';
import 'package:shnuljoe/Views/Screens/GroceryItems.dart';
import 'package:shnuljoe/Views/Screens/newHomeScreen.dart';
import 'package:shnuljoe/Views/Screens/settings/Settings.dart';

import 'Controller/LocalDataController.dart';
import 'Controller/LocationController.dart';
import 'Controller/PageController.dart';
import 'Controller/PagesDataController.dart';
import 'Controller/SliderController.dart';
import 'Controller/StepsController.dart';
import 'Services/FacebookAPIs.dart';
import 'Services/FirebaseAPI.dart';
import 'Views/Screens/HomeScreen.dart';
import 'Views/Screens/SliderScreen.dart';
import 'Views/Screens/WelcomeScreen.dart';

Future<void> main() async {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(EasyLocalization(
    supportedLocales: [Locale('en', 'US'), Locale('ar')],
    path: 'assets/translations', // <-- change the path of the translation files
    fallbackLocale: Locale('ar'),
    child: MyApp(
      analytics: analytics,
      observer: observer,
    ),
  ));
}

Future<int> getIntFromLocalMemory(String key) async {
  var pref = await SharedPreferences.getInstance();
  var number = pref.getInt(key) ?? 0;
  return number;
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AssetsAudioPlayer audioPlayer;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _register() {
    _firebaseMessaging.getToken().then((token) {
      print("token:" + token);
    });
  }

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
              "images/splash.gif",
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ConnectivityResult result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        print("object");

        Navigator.pushReplacementNamed(context, '/WelcomeScreen');
        return;
      }
      print("splash init");
      savedVol();
      _register();
      // stopPlayer();
      print("OIO");
      /* Future.delayed(Duration(seconds: 7), () {
      // 5s over, navigate to a new page
      print("OIO");
      audioPlayer.stop();
      // Navigator.pushReplacementNamed(context, '/WelcomeScreen');
      navigate(context);
    });*/

      navigate(context);
    });
  }
}

AssetsAudioPlayer audioPlayer;
bool volCheck;
savedVol() async {
  var pref = await SharedPreferences.getInstance();
  volCheck = pref.getBool('vCheck');
  audioPlayer = AssetsAudioPlayer();
  final Trace myTrace = FirebasePerformance.instance.newTrace("test_trace");
  myTrace.start();
  audioPlayer.open(Audio('images/splash.mp3'),
      autoStart: true,
      showNotification: false,
      respectSilentMode: volCheck ?? false);
}

navigate(BuildContext context) async {
  var pref = await SharedPreferences.getInstance();

  pref.getString('isLogInA');
  if (pref.getString('isLogInA') == null ||
      pref.getString('isLogInA') == "null") {
    Future.delayed(Duration(seconds: 7), () {
      // 5s over, navigate to a new page
      print("OIO");
      audioPlayer.stop();
      // Navigator.pushReplacementNamed(context, '/WelcomeScreen');
      Navigator.pushReplacementNamed(context, '/WelcomeScreen');
    });
  } else {
    Navigator.pushReplacementNamed(context, '/HomeScreen');
  }
}

class MyApp extends StatelessWidget {
  final analytics, observer;

  const MyApp({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAnalytics>.value(value: analytics),
        Provider<FirebaseAnalyticsObserver>.value(value: observer),
        ChangeNotifierProvider<MyPageController>(
            create: (_) => MyPageController()),
        ChangeNotifierProvider<SliderController>(
            create: (_) => SliderController()),
        ChangeNotifierProvider<LocalDataController>(
            create: (_) => LocalDataController()),
        ChangeNotifierProvider<LocationController>(
            create: (_) => LocationController()),
        ChangeNotifierProvider<StepsPageController>(
            create: (_) => StepsPageController()),
        ChangeNotifierProvider<FirebaseRequests>(
            create: (_) => FirebaseRequests()),
        ChangeNotifierProvider<PagesDataController>(
            create: (_) => PagesDataController()),
        ChangeNotifierProvider<SettingsController>(
            create: (_) => SettingsController()),
        ChangeNotifierProvider<FacebookAPI>(create: (_) => FacebookAPI()),
      ],
      child: ScreenUtilInit(
        //TODO change to new sizes
        designSize: Size(360, 760),
        builder: () => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: Locale("ar"),
          routes: {
            '/WelcomeScreen': (context) => WelcomeScreen(),
            '/IntroSlider': (context) => IntroSlider(),
            '/HomeScreen': (context) => HomeScreen(),
            '/Grocer': (context) => GrocerList(),
            '/splash': (context) => SplashScreen(),
          },
          home: SplashScreen(),
        ),
      ),
    );
  }
}
