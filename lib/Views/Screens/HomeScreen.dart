//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Controller/LocalDataController.dart';
import 'package:shnuljoe/Controller/LocationController.dart';
import 'package:shnuljoe/Controller/PageController.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';
import 'package:shnuljoe/Controller/SettingsController.dart';
import 'package:shnuljoe/Model/Location.dart';
import 'package:shnuljoe/Services/FacebookAPIs.dart';
import 'package:shnuljoe/Services/FirebaseAPI.dart';
import 'package:shnuljoe/Services/WeatherAPI.dart';
import 'package:shnuljoe/Services/shareFile.dart';
import 'package:shnuljoe/Views/Component/MainPageCard.dart';
import 'package:shnuljoe/Views/Component/TooltipShapeBorderBottom.dart';
import 'package:shnuljoe/Views/Component/TooltipShapeBorderMiddle.dart';
import 'package:shnuljoe/Views/Component/TooltipShapeBorderTop.dart';
import 'package:shnuljoe/Views/Screens/SevenDaysMenu.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants.dart';
import '../../Strings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AssetsAudioPlayer audioPlayer;

  var mControl;
  bool isSwitchedA = false;
  bool isSwitchedS = false;
  var textValue = 'Switch is OFF';
  // GlobalKey menu = GlobalObjectKey("menu");
  GlobalKey sevenDays = GlobalObjectKey("seven_days");
  GlobalKey<ScaffoldState> _key = GlobalKey();
  double _latitude; //= 10.750492; // = 12.916983;
  double _longitude; // = 76.374335; //= 77.634873;
  dynamic tooltip; //
  dynamic tooltipTwo; //
  var issue;
  Timer timer;
  bool isVisible = true;
  var random = new Random();
  var getLocationAndData;
  int pageNumber = 0;
  var settingsProvider;

  // HowTo howto;
  bool v;
  List codes = [];
  int swipeIndex = 0;

  List menuAudios = [
    "images/mebu_button_click.mp3",
    "images/mebu_button_click_2.mp3",
    "images/mebu_button_click_3.mp3",
    "images/mebu_button_click_4.mp3"
  ];

  List textLinks = [
    "images/text_link.mp3",
    "images/text_link_2.mp3",
  ];

  checkSF() async {
    var pref = await SharedPreferences.getInstance();
    isVisible = pref.getBool('isShowingTooltip');
    if (isVisible == null) {
      isVisible = true;
    } else {
      isVisible = false;
    }
  }

  savedSF() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('isShowingTooltip', false);
  }

  savedVol() async {
    var pref = await SharedPreferences.getInstance();
    isSwitchedA = pref.getBool('vCheck') ?? true;
    isSwitchedS = pref.getBool('vsCheck') ?? true;
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkLocationPermission());
    settingsProvider = Provider.of<SettingsController>(context, listen: false);

    Provider.of<LocationController>(context, listen: false)
        .setStatusWithoutNotify = true;
    WidgetsBinding.instance.addObserver(this);
    checkSF();
    print('initState');
    mControl = PreloadPageController();
    savedVol();
    codes = Provider.of<PagesDataController>(context, listen: false).bgsCode;

    homeScreenEvent(context).then((value) => print("Home Screen Event Done"));
    // howto = HowTo();
    //FirebaseCrashlytics.instance.crash();

    const fiveSeconds = const Duration(seconds: 1);
    Timer.periodic(fiveSeconds, (Timer t) {
      if (_key.currentState != null) {
        if (_key.currentState.isDrawerOpen) clickOnMenu(context);
      }
    });
    getLocationAndData = getCurrentLocation();
    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      final dynamic tooltip = _toolTipKey.currentState;
      if (tooltip != null) {
        tooltip.ensureTooltipVisible();
      } else {
        print('tooltip null');
      }
    });*/
  }

  checkLocationPermission() {}
  void showMyDialog(
      BuildContext context, String title, String message, bool isOnlyOk) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            message,
            style: TextStyle(fontSize: 17.sp),
          ),
          actions: <Widget>[
            TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  /*  if (!isOnlyOk) {


                    setState(() {});
                  }*/
                  // if (Platform.isAndroid) {
                  await Provider.of<PagesDataController>(context, listen: false)
                      .goToSettings(context);
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      Navigator.pushReplacementNamed(context,
                          '/splash'); // Here you can write your code for open new view
                    });
                  });

                  //  Navigator.pop(context);
                  //  SystemNavigator.pop();
                  /*  } else if (Platform.isIOS) {
                      exit(0);

                  }*/
                }),
            isOnlyOk
                ? Container()
                : TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    }),
          ],
        );
      },
    );
  }

  Future<bool> getCurrentLocation() async {
    //print("getLocationStart");
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    //  return true;
    print("_serviceEnabled $_serviceEnabled");
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print("_serviceEnabled $_serviceEnabled");
      if (!_serviceEnabled) {
        showMyDialog(context, "Location Not Enable",
            "Please enable location to continue app", false);
        return false;
      }
    }
    print("ISS");

    _permissionGranted = await location.hasPermission();
    print("permissiIISon ${_permissionGranted}");
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      print("re permission ${_permissionGranted}");
      if (_permissionGranted == PermissionStatus.denied) {
        showMyDialog(
            context,
            "Accept Location Permission",
            "Please enable location permission from setting to continue app it help us to provide you certain features like your current location and weather.",
            false);
        return false;
      } else if (_permissionGranted == PermissionStatus.deniedForever) {
        showMyDialog(
            context,
            "Accept Location Permission",
            "Please enable location permission from setting to continue app it help us to provide you certain features like your current location and weather.",
            true);
        return false;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      showMyDialog(
          context,
          "Accept Location Permission",
          "Please enable location permission from setting to continue app it help us to provide you certain features like your current location and weather.",
          true);
      return false;
    }

    Position position;
    try {
      position = await await getLocation().getGeoLocationPosition();
      print(position.latitude.toString());
      print(position.longitude.toString());
    } catch (e) {
      print(e.toString());
    }
    print(position.longitude.toString() + "DDDDDD");
    if ((_latitude == null) ||
        (_longitude == null) && ((_locationData != null))) {
      _latitude = position.latitude;
      _longitude = position.longitude;

      ///print(_longitude.toString()+"DDDDDD"+_longitude.toString());
    }

    /*  await Provider.of<LocationController>(context, listen: false)
        .getCurrentLatitudeAndLongitude();*/

    /* double _latitude =
        Provider.of<LocationController>(context, listen: false).latitude;
    double _longitude =
        Provider.of<LocationController>(context, listen: false).longitude;*/

    await Provider.of<PagesDataController>(context, listen: false)
        .getUserData();

    await Provider.of<LocationController>(context, listen: false)
        .getLocationName(_latitude, _longitude);

    issue = "16";

    print("##########15");
    issue = "15";
    print("##########13");
    issue = "13";

    print("before mk req Lat: $_latitude, Lng: $_longitude");
    await WeatherAPI().makeRequest(_latitude, _longitude, context);
    print("##########12");
    issue = "12";

    await Provider.of<FirebaseRequests>(context, listen: false)
        .requestBG(context);
    print("##########11");
    issue = "11";

    await Provider.of<PagesDataController>(context, listen: false)
        .requestMeals(context);
    print("##########10");
    issue = "10";
    await Provider.of<PagesDataController>(context, listen: false)
        .createScreens();
    print("getLocationComplete");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getLocationAndData,
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data)
            return Stack(
              children: [
                Scaffold(
                  key: _key,
                  appBar: AppBar(
                    backgroundColor: primaryColorPink,
                    leading: new IconButton(
                        icon: new Icon(Icons.menu),
                        onPressed: () {
                          _key.currentState.openDrawer();

                          //stopPlayer1();
                        }),
                    title: Center(
                      child: Text(
                        'شن الجو',
                        style: TextStyle(fontFamily: 'DG-Bebo'),
                      ),
                    ),
                    actions: [
                      Tooltip(
                        //    key: _toolTipKey,
                        decoration: BoxDecoration(
                          color: primaryColorPink,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        textStyle: TextStyle(color: Colors.white, fontSize: 12),
                        verticalOffset: 20,
                        padding: EdgeInsets.all(10),
                        message: "اضغط للحصول على توقعات 7 ايام",
                        // "Click to get 7 days forecast",
                        child: GestureDetector(
                          onTap: () async {
                            //  stopPlayers();
                            settingsProvider.stopPlayer();
                            settingsProvider.stopKitchenPlayer();

                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SevenDaysMenu(),
                              ),
                            );
                            if (result == true) {
                              settingsProvider.startPlayer(
                                  path: Audio(audioLink(codes[codes.length >
                                              Provider.of<PagesDataController>(
                                                      context,
                                                      listen: false)
                                                  .index
                                          ? Provider.of<PagesDataController>(
                                                  context,
                                                  listen: false)
                                              .index
                                          : 'hot']
                                      .toString())));
                            }
                          },
                          child: SvgPicture.asset(
                            'images/menuR1.svg',
                            width: 20.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                    ],
                  ),
                  /* drawer: Drawer(
                    child: Container(
                      color: primaryColorPink,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  vertical: 40.h, horizontal: 25.w),
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // stopPlayer();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30.r,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: () {
                                    startPlayer1(
                                        Audio(textLinks[random.nextInt(1)]));
                                  },
                                  child: Text(
                                    "شن الجو",
                                    style: drawerTilesTitle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        fit: FlexFit.tight,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              Provider.of<PagesDataController>(
                                                          context)
                                                      .userName ??
                                                  "",
                                              style:
                                                  Provider.of<PagesDataController>(
                                                              context)
                                                          .userName
                                                          .toString()
                                                          .contains("@")
                                                      ? drawerTilesText
                                                      : drawerTilesText),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 60.0,
                                          child: CircleAvatar(
                                            backgroundImage: (Provider.of<
                                                                PagesDataController>(
                                                            context)
                                                        .userPic ==
                                                    "apple")
                                                ? AssetImage(
                                                    "images/profilePlaceholder.png")
                                                : NetworkImage(
                                                    Provider.of<PagesDataController>(
                                                            context)
                                                        .userPic,
                                                  ),
                                            radius: 50.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: FlutterSwitch(
                                            width: 70.0,
                                            height: 40.0,
                                            valueFontSize: 0.0,
                                            toggleSize: 45.0,
                                            toggleColor: primaryColorPink
                                                .withOpacity(0.6),
                                            activeColor: Colors.white,
                                            inactiveColor: Colors.grey[400],
                                            value: isSwitchedS,
                                            borderRadius: 40.0,
                                            padding: 0.5,
                                            showOnOff: true,
                                            onToggle: toggleSwitchSound,
                                          ),
                                        ),
                                        Text(
                                          isSwitchedS == false
                                              ? Provider.of<
                                                          LocalDataController>(
                                                      context)
                                                  .turningOn
                                              : Provider.of<
                                                          LocalDataController>(
                                                      context)
                                                  .turningOff,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'صوت',
                                          style: drawerTilesText,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.volume_up_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: FlutterSwitch(
                                            width: 70.0,
                                            height: 40.0,
                                            valueFontSize: 0.0,
                                            toggleSize: 45.0,
                                            toggleColor: primaryColorPink
                                                .withOpacity(0.6),
                                            activeColor: Colors.white,
                                            inactiveColor: Colors.grey[400],
                                            value: isSwitchedA,
                                            borderRadius: 40.0,
                                            padding: 0.5,
                                            showOnOff: true,
                                            onToggle: toggleSwitch,
                                          ),
                                        ),
                                        Text(
                                          isSwitchedA == false
                                              ? Provider.of<
                                                          LocalDataController>(
                                                      context)
                                                  .turningOn
                                              : Provider.of<
                                                          LocalDataController>(
                                                      context)
                                                  .turningOff,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' البيئة',
                                          style: drawerTilesText,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.volume_up_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/Grocer');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        child: Text(
                                          Provider.of<LocalDataController>(
                                                  context)
                                              .listGrocer,
                                          style: drawerTilesText,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Icon(
                                        Icons.file_copy_outlined,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    startPlayer1(
                                        Audio(textLinks[random.nextInt(1)]));
                                    Share().onButtonTap("Facebook");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        child: Text(
                                          Provider.of<LocalDataController>(
                                                  context)
                                              .share,
                                          style: drawerTilesText,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Icon(
                                        Icons.share_outlined,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    startPlayer1(
                                        Audio(textLinks[random.nextInt(1)]));
                                    _launchURL();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        child: Text(
                                          Provider.of<LocalDataController>(
                                                  context)
                                              .rateUs,
                                          style: drawerTilesText,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () async {
                                startPlayer1(
                                    Audio(textLinks[random.nextInt(1)]));
                                Provider.of<FacebookAPI>(context, listen: false)
                                    .fbSignOut();
                                var pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('isLogInA', "null");
                                pref.setString('isFirstTimeIn', "false");
                                signOutEvent(context);
                                Navigator.pushReplacementNamed(
                                    context, "/WelcomeScreen");
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.login_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Text(
                                      Provider.of<LocalDataController>(context)
                                          .logout,
                                      style: drawerTilesText,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: primaryColorPink,
                          )
                        ],
                      ),
                    ),
                  ), */
                  onDrawerChanged: (isOpen) {
                    if (isOpen = false) {
                      setState(() {});
                    }
                    // write your callback implementation here
                    print('drawer callback isOpen=$isOpen');
                  },
                  // endDrawer: NavDrawerEnd(),

                  body: SafeArea(
                    child: Stack(
                      children: [
                        PageView(
                          physics: ClampingScrollPhysics(),
                          controller:
                              Provider.of<MyPageController>(context).controller,
                          onPageChanged: (v) {
                            //  stopPlayers();
                            //stopPlayer();
                            setState(() {
                              pageNumber = v;
                              //  startPlayer();
                            });
                            if (swipeIndex > v) {
                              if (isSwitchedS)
                                Future.delayed(Duration(seconds: 0), () {
                                  print("########### LEFT");
                                  settingsProvider.audioPlayerSwipe.open(
                                      Audio("images/scroll1.mp3"),
                                      autoStart: true,
                                      showNotification: false,
                                      respectSilentMode: isSwitchedS);
                                });
                            }
                            if (swipeIndex < v) {
                              print("########### RIGHT");
                              if (isSwitchedS)
                                Future.delayed(Duration(seconds: 0), () {
                                  settingsProvider.audioPlayerSwipe.open(
                                      Audio("images/scroll2.mp3"),
                                      autoStart: true,
                                      showNotification: false,
                                      respectSilentMode: isSwitchedS);
                                });
                            }
                            swipeIndex = v;
                            print('#######VALUE' + v.toString());
                            if (v == 0) todayFoodEvent(context);
                            if (v == 1) tomorrowFoodEvent(context);
                            Provider.of<MyPageController>(context,
                                    listen: false)
                                .onPageChange(v);
                            Provider.of<PagesDataController>(context,
                                    listen: false)
                                .index = v;
                            // TODO: add weather sound if required here
                          },
                          children: [
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[0],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 0,
                              showTooltip: true,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[1],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 1,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[2],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 2,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[3],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 3,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[4],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 4,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[5],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 5,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                            MainPageCard(
                              pageData:
                                  Provider.of<PagesDataController>(context)
                                      .pagesList[6],
                              mController:
                                  Provider.of<MyPageController>(context)
                                      .controller,
                              pageNumber: 6,
                              showTooltip: false,
                              tooltipMenu: tooltip,
                              tooltipTwo: tooltipTwo,
                              lat: _latitude,
                              lng: _longitude,
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 15.h,
                          width: 360.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Provider.of<MyPageController>(context)
                                            .currentPage !=
                                        0
                                    ? GestureDetector(
                                        onTap: () {
                                          Provider.of<MyPageController>(context,
                                                  listen: false)
                                              .decrementPage();
                                          previousDayEvent(context);
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 30.w,
                                        ))
                                    : Container(),
                                DotsIndicator(
                                  dotsCount: 7,
                                  position:
                                      Provider.of<MyPageController>(context)
                                          .currentPage
                                          .toDouble(),
                                  decorator: DotsDecorator(
                                    size: Size.square(11.0.r),
                                    activeSize: Size.square(11.0.r),
                                    color: Colors.white,
                                    activeColor: primaryColorPink,
                                  ),
                                ),
                                Provider.of<MyPageController>(context)
                                            .currentPage !=
                                        6
                                    ? GestureDetector(
                                        onTap: () {
                                          Provider.of<MyPageController>(context,
                                                  listen: false)
                                              .incrementPage();
                                        },
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 30.w,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<LocationController>(
                    builder: (context, locationModel, child) {
                  return SafeArea(
                    child: Visibility(
                      visible: //locationModel.bool1,
                          isVisible,
                      child: SafeArea(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Color(0xB2454343),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      savedSF();
                                      isVisible = false;
                                      Provider.of<LocationController>(context,
                                              listen: false)
                                          .setBool = false;
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DefaultTextStyle(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: ShapeDecoration(
                                        color: primaryColorPink,
                                        shape:
                                            TooltipShapeBorder(arrowArc: 0.5),
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4.0,
                                              offset: Offset(2, 2))
                                        ],
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Text(
                                          "اضغط للحصول على توقعات 7 ايام",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .14,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DefaultTextStyle(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: primaryColorPink,
                                        shape: TooltipShapeBorderMiddle(
                                            arrowArc: 0.5),
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4.0,
                                              offset: Offset(2, 2))
                                        ],
                                      ),
                                      //padding: padding,
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Text(
                                          'اضغط على الوجبة للحصول على المقادير والوصفة',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .26,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DefaultTextStyle(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      /*decoration: BoxDecoration(
                                        color: primaryColorPink,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),*/
                                      decoration: ShapeDecoration(
                                        color: primaryColorPink,
                                        shape: TooltipShapeBorderBottom(
                                            arrowArc: 0.5),
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4.0,
                                              offset: Offset(2, 2))
                                        ],
                                      ),
                                      //padding: padding,
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Text(
                                          "اضغط على الوجبة عشان تعرف شن ادير للفطور والعشاء",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFE31C84),
            child: Center(
              child: Image.asset(
                "images/loading2.gif",
              ),
            ),
          );
        });
  }

  Future homeScreenEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Weather',
      parameters: <String, dynamic>{
        'View_Weather': "Success",
      },
    );
  }

  Future todayFoodEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Today\'s_Food_Idea',
      parameters: <String, dynamic>{
        'View_Today\'s_Food_Idea': "Success",
      },
    );
  }

  Future previousDayEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Previous_Day_Food_Idea',
      parameters: <String, dynamic>{
        'Previous_Day_Food_Idea': "Success",
      },
    );
  }

  Future tomorrowFoodEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Next_Day_Food_Idea',
      parameters: <String, dynamic>{
        'Next_Day_Food_Idea': "Success",
      },
    );
  }

  Future clickOnSevenWeather(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Weather_this_Week',
      parameters: <String, dynamic>{
        'View_Weather_this_Week': "Success",
      },
    );
  }

  Future clickOnMenu(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Menu',
      parameters: <String, dynamic>{
        'menu': "Success",
      },
    );
  }

  Future signOutEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'LogOut',
      parameters: <String, dynamic>{
        'Log_Out': "Success",
      },
    );
  }

  _launchURL() async {
    var url;
    if (Platform.isAndroid)
      url = 'https://play.google.com/store/apps/details?id=com.shoeljoe_app';
    else if (Platform.isIOS)
      url = 'https://apps.apple.com/us/app/appname/id148563';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  startPlayer1(path) async {
    SharedPreferences prf = await SharedPreferences.getInstance();

    prf.getBool("vCheck");
    bool vCheck = prf.getBool("vCheck");
    if (vCheck == true) {
    } else {
      settingsProvider.assetsAudioPlayer.open(
        path,
        loopMode: LoopMode.none,
        autoStart: true,
        showNotification: false,
        // respectSilentMode: vCheck ?? false,
      );
    }
  }
}
