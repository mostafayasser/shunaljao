//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Controller/LocationController.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';
import 'package:shnuljoe/Controller/StepsController.dart';
import 'package:shnuljoe/Model/DayDataModel.dart';
import 'package:shnuljoe/Model/MealModel.dart';
import 'package:shnuljoe/Services/FirebaseAPI.dart';
import 'package:shnuljoe/Views/Screens/HomeScreen.dart';
import 'package:shnuljoe/Views/Screens/HowTo.dart';
import 'package:translator/translator.dart';

import '../../Constants.dart';
import '../../Strings.dart';
import 'package:http/http.dart' as http;

class MainPageCard extends StatefulWidget {
  MainPageCard({
    @required this.pageData,
    @required this.mController,
    @required this.pageNumber,
    @required this.showTooltip,
    @required this.tooltipMenu,
    @required this.tooltipTwo,
    @required this.lat,
    @required this.lng,
  });

  final DayDataModel pageData;
  final PageController mController; //
  final int pageNumber; //
  final bool showTooltip; //
  final dynamic tooltipMenu; //
  final dynamic tooltipTwo; //
  double lat;
  double lng;

  @override
  _MainPageCardState createState() => _MainPageCardState();
}

DateTime now = DateTime.now();

//AssetsAudioPlayer audioPlayerOne;
AssetsAudioPlayer audioPlayerTwo;
//final player = AudioPlayer();
var random = new Random();

class _MainPageCardState extends State<MainPageCard> {
  MealModel mainMeal;
  MealModel rightSideMeal;
  MealModel leftSideMeal;

  StreamController<double> _events;
  bool called;
  GlobalKey _mainMeal;
  GlobalKey _breakfastKey;
  GlobalKey _toolTipKey;
  GlobalKey _dinnerKey;
  GlobalKey _mainMealTwo;
  MealModel queueMeal;
  dynamic tooltip;
  String imgUrl;
  bool v;
  List codes = [];
  List bg1 = [];
  List lunchesBG = [];
  List dinnerBG = [];
  List audios = [
    "images/pop1.mp3",
    "images/pop2.mp3",
    "images/pop3.mp3",
  ];
  bool getBool;
  savedSF() async {
    var pref = await SharedPreferences.getInstance();
    getBool = pref.getBool('vCheck');
  }

  // AudioPlayer audioPlugin = AudioPlayer();
  checkSF() async {
    var pref = await SharedPreferences.getInstance();
    v = pref.getBool('isShowingTooltip');
    if (v == null) v = true;
    if (v) {
      if (widget.pageNumber == 0) {
        Future.delayed(Duration(seconds: 0), () {
          // 5s over, navigate to a new page
          tooltip = _mainMeal.currentState;
          if (tooltip != null) {
            tooltip.ensureTooltipVisible();
          }
          final dynamic tooltipTwo = _mainMealTwo.currentState;
          if (tooltipTwo != null) {
            tooltipTwo.ensureTooltipVisible();
          }
          final dynamic tooltipBreakfast = _breakfastKey.currentState;
          if (tooltipBreakfast != null) {
            tooltipBreakfast.ensureTooltipVisible();
          }
          final dynamic tooltipDinner = _dinnerKey.currentState;
          if (tooltipDinner != null) {
            tooltipDinner.ensureTooltipVisible();
          }
          final dynamic tooltipKey = _toolTipKey.currentState;
          if (tooltipKey != null) {
            tooltipKey.ensureTooltipVisible();
          }
        });
      }
      pref.setBool('isShowingTooltip', !v);
    }
  }

  var radius = 0.0;
  var _size = 10.0;
  bool soundCheck;
  bool _visible = true;
  @override
  void initState() {
    print('init state ###################3');
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
    Provider.of<LocationController>(context, listen: false)
        .setStatusWithoutNotify = true;
    Provider.of<PagesDataController>(context, listen: false).index =
        widget.pageNumber;
    mainMeal = widget.pageData.lunch;
    print("Main Meal" + mainMeal?.name);
    rightSideMeal = widget.pageData.breakfast;
    leftSideMeal = widget.pageData.dinner;
    //audioPlayerOne = AssetsAudioPlayer();
    audioPlayerTwo = AssetsAudioPlayer();
    //audioPlayerThree = AssetsAudioPlayer();
    _mainMeal = GlobalObjectKey("main_meal" + widget.pageNumber.toString());
    _breakfastKey =
        GlobalObjectKey("breakfast_meal" + widget.pageNumber.toString());
    _toolTipKey = GlobalObjectKey("top_meal" + widget.pageNumber.toString());
    _dinnerKey = GlobalObjectKey("dinner_meal" + widget.pageNumber.toString());
    _mainMealTwo = GlobalObjectKey("_meal" + widget.pageNumber.toString());
    _events = new StreamController<double>();
    widget.mController.addListener(() {
      _listener();
    });
    codes = Provider.of<PagesDataController>(context, listen: false).bgsCode;
    bg1 = Provider.of<FirebaseRequests>(context, listen: false).bg1;
    lunchesBG =
        Provider.of<PagesDataController>(context, listen: false).lunchBg;
    dinnerBG =
        Provider.of<PagesDataController>(context, listen: false).dinnerBg;

    imgUrl = Provider.of<PagesDataController>(context, listen: false)
        .bgs[widget.pageNumber];

    //startPlayer(Audio(audioLink(codes[widget.pageNumber].toString())));
    savingSound(codes[widget.pageNumber].toString());
    // startKitchenPlayer();

    print('index ${widget.pageNumber} url $imgUrl');
/*    stopPlayers();
    print('#####Sound: ' + codes[widget.pageNumber]);
    audioPlayerThree.open(
        Audio(audioLink(codes[widget.pageNumber])), //Audio("images/pop.mp3"),
        autoStart: true,
        showNotification: false);*/

    Future.delayed(Duration(seconds: 1), () async {
      //audioPlayerThree.stop();
      SharedPreferences pref = await SharedPreferences.getInstance();
      soundCheck = pref.getBool("vsCheck");
      if (soundCheck)
        audioPlayerTwo.open(
            Audio(audios[random.nextInt(2)]), //Audio("images/pop1.mp3"),
            autoStart: true,
            showNotification: false,
            respectSilentMode: pref.getBool("vsCheck") ?? true);
      print(soundCheck.toString() + "SKNSSH");
      // audioPlayerTwo.play();
      //stopPlayer();
      // startPlayer(Audio("images/pop.mp3"));
    });

    // checkSF().then((value) => null);

//    startAudio();

    super.initState();
  }

  void savingSound(value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("selectedPageSound", value);
  }

  checkForNewSharedLists() {
    if (mounted) {
      setState(() {
        if (animated == false) {
          animated = true;
        } else {
          animated = false;
        }
      });
    }
  }

  _listener() {
    _events.add(widget.mController.page);
  }

  bool animated = false;
  Timer timer;
/*
  Future<void> startAudio() async {
    await player.setAsset(audioLink(codes[widget.pageNumber]));
  }*/

  @override
  void dispose() {
    // stopPlayers();
    // stopPlayer();
    print("Main page Dispose");
    super.dispose();

/*    audioPlayerOne.stop();
    audioPlayerTwo.stop();*/
  }

  @override
  Widget build(BuildContext context) {
    widget.mController.addListener(() {
      _listener();
    });

    tooltip = _mainMeal.currentState;
    return (mainMeal != null)
        ? Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Container(),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x22ffffff),
                      Color(0x99000000),
                    ],
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2508,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Tooltip(
                                  key: _toolTipKey,
                                  decoration: BoxDecoration(
                                    color: primaryColorPink,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  verticalOffset: 20,
                                  padding: EdgeInsets.all(10),
                                  message: "اضغط للحصول على توقعات 7 ايام",
                                  // "Click to get 7 days forecast",
                                  child: Container(
                                    height: 5,
                                    width: 5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Center(
                              child: Text(widget.pageData.day,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                      color: primaryColorPink,
                                      fontFamily: 'DG-Bebo')),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 12.w, right: 12.w),
                                          child: Center(
                                            child: Text(
                                              "جو" + " " + mainMeal.name,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: h2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.64,
                        child: Column(
                          children: [
                            SizedBox(height: 35.h),
                            GestureDetector(
                              onTap: () {
                                //  stopPlayers();
                                /*  stopPlayer();
                                stopKitchenPlayer(); */
                                clickOnFoodEvent(context, mainMeal.name)
                                    .then((value) async {
                                  Provider.of<StepsPageController>(context,
                                          listen: false)
                                      .setMeal(mainMeal);
                                  print('MainPage Card ');
                                  /*
                          Provider.of<MyPageController>(context, listen: false)
                              .changeHowTo();*/
                                  Provider.of<StepsPageController>(context,
                                          listen: false)
                                      .assignText();
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HowTo(
                                              pageData: Provider.of<
                                                          PagesDataController>(
                                                      context)
                                                  .pagesList[widget.pageNumber],
                                            )),
                                  );
                                  if (result == true) {
                                    /*  startPlayer(Audio(audioLink(
                                        codes[widget.pageNumber].toString())));
                                    startKitchenPlayer(); */
                                  }
                                });
                              },
                              child: StreamBuilder(
                                stream: _events.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var scale;
                                    if (widget.pageNumber != 0) {
                                      scale = snapshot.data / widget.pageNumber;
                                      if (scale < 1) {
                                        scale = scale - 0.3;
                                      } else {
                                        scale = 0.8;
                                      }
                                    } else {
                                      scale = 0.8;
                                    }

                                    return widget.showTooltip
                                        ? Tooltip(
                                            key: _mainMeal,
                                            decoration: BoxDecoration(
                                              color: primaryColorPink,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                            ),
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                            verticalOffset: 20,
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                bottom: 50),
                                            message:
                                                "اضغط على الوجبة للحصول على المقادير والوصفة",
                                            // bottom text
                                            child: Transform.scale(
                                              scale: scale,
                                              child: PhysicalModel(
                                                shape: BoxShape.circle,
                                                elevation: 30,
                                                color: Colors.transparent,
                                                child: CachedNetworkImage(
                                                    imageUrl: mainMeal.imageURL,
                                                    fit: BoxFit.contain,
                                                    width: 220.w,
                                                    height: 120.h),
                                              ),
                                            ),
                                          )
                                        : Transform.scale(
                                            scale: scale,
                                            child: PhysicalModel(
                                              shape: BoxShape.circle,
                                              elevation: 30,
                                              color: Colors.transparent,
                                              child: CachedNetworkImage(
                                                  imageUrl: mainMeal.imageURL,
                                                  fit: BoxFit.contain,
                                                  width: 220.w,
                                                  height: 120.h),
                                            ),
                                          );
                                  }
                                  return widget.showTooltip
                                      ? Tooltip(
                                          key: _mainMealTwo,
                                          decoration: BoxDecoration(
                                            color: primaryColorPink,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                          ),
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          verticalOffset: 20,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              bottom: 50),
                                          message:
                                              "اضغط على الوجبة للحصول على المقادير والوصفة",
                                          // middle text
                                          child: Transform.scale(
                                            scale: 1,
                                            child: PhysicalModel(
                                              elevation: 30,
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                              child: CachedNetworkImage(
                                                  imageUrl: mainMeal.imageURL,
                                                  fit: BoxFit.contain,
                                                  width: 220.w,
                                                  height: 120.h),
                                            ),
                                          ),
                                        )
                                      : Transform.scale(
                                          scale: 1,
                                          child: PhysicalModel(
                                            elevation: 30,
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            child: CachedNetworkImage(
                                                imageUrl: mainMeal.imageURL,
                                                fit: BoxFit.contain,
                                                width: 220.w,
                                                height: 120.h),
                                          ),
                                        );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                              width: double.infinity,
                              child: AnimatedDefaultTextStyle(
                                child: InkWell(
                                    onTap: () {
                                      //  stopPlayers();
                                      /* stopPlayer();
                                      stopKitchenPlayer(); */

                                      clickOnFoodEvent(context, mainMeal.name)
                                          .then((value) async {
                                        Provider.of<StepsPageController>(
                                                context,
                                                listen: false)
                                            .setMeal(mainMeal);
                                        print('MainPage Card ');
                                        /*
                          Provider.of<MyPageController>(context, listen: false)
                              .changeHowTo();*/
                                        Provider.of<StepsPageController>(
                                                context,
                                                listen: false)
                                            .assignText();
                                        var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HowTo(
                                                    pageData:
                                                        Provider.of<PagesDataController>(
                                                                    context)
                                                                .pagesList[
                                                            widget.pageNumber],
                                                  )),
                                        );
                                        if (result == true) {
                                          /*  startPlayer(Audio(audioLink(
                                              codes[widget.pageNumber]
                                                  .toString())));
                                          startKitchenPlayer(); */
                                        }
                                      });
                                    },
                                    child: Text(
                                      'اضغط هنا',
                                      textAlign: TextAlign.center,
                                    )),
                                style: animated
                                    ? TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.sp,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.white70.withOpacity(1.0),
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: radius,
                                          ),
                                        ],
                                      )
                                    : TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 29.sp,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.white70.withOpacity(1.0),
                                            offset: Offset(0.0, 0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              mainMeal.type,
                              style: h2Arial,
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              width: 360.w,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: getCity("city"),
                                    builder: (context, snapshot) {
                                      /*  print("City Name1 " +
                                          snapshot.data.toString()); */
                                      if (!snapshot.hasData) {
                                        return FutureBuilder(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data}',
                                                style: h3,
                                              );
                                            } else {
                                              return SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            }
                                          },
                                          future: getLocation(
                                              widget.lat, widget.lng),
                                        );
                                      }
                                      /*  print("City Name 2 " +
                                          snapshot.data.toString()); */
                                      if (snapshot.data.toString().isEmpty) {
                                        return FutureBuilder(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data ?? ''}',
                                                style: h3,
                                                maxLines: 1,
                                              );
                                            } else {
                                              return SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            }
                                          },
                                          future: getLocation(
                                              widget.lat, widget.lng),
                                        );
                                      } else {
                                        return Text(
                                          '${snapshot.data}',
                                          style: h3,
                                          maxLines: 1,
                                        );
                                      }
                                    },
                                  ),
                                  Tooltip(
                                    decoration: BoxDecoration(
                                      color: primaryColorPink,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    verticalOffset: 20,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      top: 50,
                                      right: 20,
                                      left:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                    key: _breakfastKey,
                                    message:
                                        "اضغط على الوجبة عشان تعرف شن ادير للفطور والعشاء",
                                    //"Click on the dish to see whats for Breakfast , lunch & dinner",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 150.w,
                                          child: Stack(
                                            children: [
                                              Text(
                                                widget.pageData.temp,
                                                style: TextStyle(
                                                  color: primaryColorPink,
                                                  fontSize: 100.sp,
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 5.w,
                                                child: Text(
                                                  cc,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30.sp,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: -5.h,
                                                left: 0,
                                                child: Text(
                                                  widget.pageData.description,
                                                  style: h3Arial.apply(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // stopPlayers();
                                            /*  stopPlayer();
                                            stopKitchenPlayer(); */
                                            /*await Provider.of<FirebaseRequests>(context,
                                                listen: false)
                                            .requestBG(context);*/
                                            //audioPlayerOne.stop();

                                            /*  startPlayer(Audio(audioLink(
                                                codes[widget.pageNumber]
                                                    .toString())));
                                            startKitchenPlayer(); */
                                            audioPlayerTwo.stop();
                                            audioPlayerTwo.open(
                                                Audio(
                                                    audios[random.nextInt(2)]),
                                                autoStart: true,
                                                showNotification: false,
                                                respectSilentMode:
                                                    soundCheck ?? true); //

                                            /*Future.delayed(Duration(seconds: 1), () {
                                          stopPlayer();
                                          startPlayer(Audio("images/pop.mp3"));
                                        });*/

                                            /* Provider.of<PagesDataController>(context,
                                                listen: false)
                                            .bgs[widget.pageNumber] = bg1[0]
                                                [codes[widget.pageNumber]]
                                            [random.nextInt(5)];*/

                                            /*audioPlayer.open(
                                            Audio(Provider.of<PagesDataController>(
                                                    context,
                                                    listen: false)
                                                .weatherAudio[0]),//##
                                            autoStart: true,
                                            showNotification: false); */
                                            imgUrl =
                                                lunchesBG[widget.pageNumber];
                                            lunchesBG[
                                                widget.pageNumber] = Provider
                                                    .of<PagesDataController>(
                                                        context,
                                                        listen: false)
                                                .bgs[widget.pageNumber];
                                            Provider.of<PagesDataController>(
                                                        context,
                                                        listen: false)
                                                    .bgs[widget.pageNumber] =
                                                imgUrl;
                                            setState(() {
                                              /*print("Music Name " +
                                              Provider.of<PagesDataController>(
                                                      context,
                                                      listen: false)
                                                  .weatherAudio
                                                  .toString());*/
                                              MealModel queueMeal = mainMeal;
                                              mainMeal = leftSideMeal;
                                              leftSideMeal = queueMeal;
                                            });
                                          },
                                          child: Container(
                                            width: 80.w,
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5.h),
                                                leftSideMeal != null
                                                    ? (tooltip == null
                                                        ? Text(
                                                            leftSideMeal.type,
                                                            style: h4Arial)
                                                        : Text(
                                                            leftSideMeal.type,
                                                            style: h4Arial))
                                                    : Container(),
                                                Spacer(),
                                                leftSideMeal != null
                                                    ? CachedNetworkImage(
                                                        imageUrl: leftSideMeal
                                                            .imageURL,
                                                        width: 50.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            /*await Provider.of<FirebaseRequests>(context,
                                                listen: false)
                                            .requestBG(context);*/
                                            // stopPlayers();
                                            /*  stopPlayer();
                                            stopKitchenPlayer(); */
                                            //audioPlayerOne.stop();
                                            // audioPlayer.open(
                                            //     Audio(Provider.of<PagesDataController>(
                                            //             context,
                                            //             listen: false)
                                            //         .weatherAudio[1]),
                                            //     autoStart: true,
                                            //     showNotification: false);
                                            //if(audioLink(codes[widget.pageNumber].trim.toString())!=null)
                                            /* startPlayer(Audio(audioLink(
                                                codes[widget.pageNumber]
                                                    .toString())));
                                            startKitchenPlayer(); */
                                            audioPlayerTwo.stop();

                                            audioPlayerTwo.open(
                                                Audio(
                                                    audios[random.nextInt(2)]),
                                                autoStart: true,
                                                showNotification: false,
                                                respectSilentMode:
                                                    soundCheck ?? true); //

                                            /*   Future.delayed(Duration(seconds: 1), () {
                                          stopPlayer();
                                          startPlayer(Audio("images/pop.mp3"));
                                        });*/
                                            /* Provider.of<PagesDataController>(context,
                                                listen: false)
                                            .bgs[widget.pageNumber] = bg1[0]
                                                [codes[widget.pageNumber]]
                                            [random.nextInt(5)];*/
                                            imgUrl =
                                                dinnerBG[widget.pageNumber];
                                            dinnerBG[
                                                widget.pageNumber] = Provider
                                                    .of<PagesDataController>(
                                                        context,
                                                        listen: false)
                                                .bgs[widget.pageNumber];
                                            Provider.of<PagesDataController>(
                                                        context,
                                                        listen: false)
                                                    .bgs[widget.pageNumber] =
                                                imgUrl;
                                            setState(() {
                                              queueMeal = mainMeal;
                                              mainMeal = rightSideMeal;
                                              rightSideMeal = queueMeal;
                                            });
                                          },
                                          child: Container(
                                            width: 80.w,
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5.h),
                                                rightSideMeal != null
                                                    ? (tooltip == null
                                                        ? Text(
                                                            rightSideMeal.type,
                                                            style: h4Arial)
                                                        : Text(
                                                            rightSideMeal.type,
                                                            style: h4Arial))
                                                    : Container(),
                                                Spacer(),
                                                rightSideMeal != null
                                                    ? CachedNetworkImage(
                                                        imageUrl: rightSideMeal
                                                            .imageURL,
                                                        width: 50.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Future clickOnFoodEvent(BuildContext context, meal) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Click_Food_Idea',
      parameters: <String, dynamic>{
        ''
            'Food_Name': meal,
        'Click_Time': DateFormat.jm().format(DateTime.now()).toString()
      },
    );
  }

  void tutorialThingsOfDO() {
    print("Ignore Touch" + "cc");
    if (true) {
      called = false;
      CoachMark coachMarkFAB = CoachMark();
      RenderBox target = _mainMeal.currentContext.findRenderObject();
      // you can change the shape of the mark
      Rect markRect = target.localToGlobal(Offset.zero) & target.size;
      markRect = Rect.fromCircle(
          center: markRect.center, radius: markRect.longestSide * 0);
      coachMarkFAB.show(
        targetContext: _mainMeal.currentContext,
        markRect: markRect,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Click on this to see the details",
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 128.0),
                  child: Container(
                    height: 80,
                    width: 200,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Next",
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        duration: null,
        // we don't want to dismiss this mark automatically so we are passing null
        // when this mark is closed, after 1s we show mark on RaisedButton
        onClose: () => null,
      );
    }
  }

  Future<String> getLocation(double lat, double lng) async {
    var responseBody;

    final response = await http.get(
      Uri.parse(
          "https://us1.locationiq.com/v1/reverse.php?key=pk.78f5d2220ef901d6141426cd38bfe0bc&lat=${lat}&lon=${lng}&format=json"),
    );
    responseBody = json.decode(response.body);
    print("responseBody" + responseBody.toString());
/*    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print("${first.countryName} : ${first.locality}");*/
    //var city = first.locality + " , " + first.countryName;
    var city = ((responseBody['address']["county"] ??
                    responseBody['address']["city"] ??
                    "") +
                " " +
                "," +
                " " +
                responseBody['address']["country"] ??
            "") ??
        "";
    if (city.contains("Banghazi")) {
      city = "  ليبيا ,  بنغازي";
    }
    if (city.contains("Tripoli")) {
      city = "ليبيا ,  طرابلس ";
    }
    if (city.contains("Zuwara")) {
      city = "ليبيا ,  زوارة";
    }
    if (city.contains("Khoms")) {
      city = "ليبيا ,  الخمس";
    }
    if (city.contains("Misrata")) {
      city = "ليبيا ,  مصراتة";
    }
    if (city.contains("Gadamis")) {
      city = " ليبيا , غدامس";
    }
    if (city.contains("Sabha")) {
      city = " ليبيا , سبها";
    }
    if (city.contains("Sirte")) {
      city = "ليبيا ,  سرت";
    }
    if (city.contains("Ajdabiya")) {
      city = "ليبيا ,  اجدابيا";
    }
    if (city.contains("Al bayda") || city.contains("Albayda")) {
      city = "ليبيا ,  البيضة";
    }
    if (city.contains("Tobruk")) {
      city = "ليبيا ,  طبرق";
    }
    if (city.contains("Derna")) {
      city = "ليبيا ,  درنة";
    }
    final translator = GoogleTranslator();
    var translCity = await translator.translate(city, from: 'en', to: 'ar');

    saveCity(translCity.toString()).then((value) => null);
    return city.toString();
  }

  /* Future<String> getLocation(double lat, double lng) async {
//    Position position = await Geolocator.getCurrentPosition(
    //      desiredAccuracy: LocationAccuracy.high);
    //   print(position);
    const Locale locale = Locale('ar', 'AE');
    List<Placemark> addressList = await placemarkFromCoordinates(
      */ /* 29.391904, 47.384493, 29.391904, 47.384493,// */ /*
      lat,
      lng, */ /*  localeIdentifier: locale.toString()*/ /*
    );
    print('Address:' + addressList.toString());

    ///    final coordinates = new Coordinates(position.latitude, position.longitude);
    //   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);

    if (addressList.length > 0) {
      var first = addressList.first;
      print("${first.country} : ${first.locality}");
      var city = first.locality.isNotEmpty
          ? first.locality
          : first.administrativeArea + " , " + first.country;
      if (city.contains("Banghazi")) {
        city = "  ليبيا ,  بنغازي";
      }
      if (city.contains("Tripoli")) {
        city = "ليبيا ,  طرابلس ";
      }
      if (city.contains("Zuwara")) {
        city = "ليبيا ,  زوارة";
      }
      if (city.contains("Khoms")) {
        city = "ليبيا ,  الخمس";
      }
      if (city.contains("Misrata")) {
        city = "ليبيا ,  مصراتة";
      }
      if (city.contains("Gadamis")) {
        city = " ليبيا , غدامس";
      }
      if (city.contains("Sabha")) {
        city = " ليبيا , سبها";
      }
      if (city.contains("Sirte")) {
        city = "ليبيا ,  سرت";
      }
      if (city.contains("Ajdabiya")) {
        city = "ليبيا ,  اجدابيا";
      }
      if (city.contains("Al bayda") || city.contains("Albayda")) {
        city = "ليبيا ,  البيضة";
      }
      if (city.contains("Tobruk")) {
        city = "ليبيا ,  طبرق";
      }
      if (city.contains("Derna")) {
        city = "ليبيا ,  درنة";
      }
      saveCity(city).then((value) => null);
      return city.toString();
    }
  }*/

  Future<void> saveCity(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('city', cityName.toString());
  }

  Future<String> getCity(String key) async {
    var pref = await SharedPreferences.getInstance();
    var city = pref.getString(key);

    return city;
  }
}

stopPlayers() {
  print('##########Inserted');
  //audioPlayerOne.stop();
  audioPlayerTwo.stop();
  //audioPlayerThree.stop();
}

/*Future<void> stopAudio() async {
  await player.stop();
  await player.dispose();
}*/

String audioLink(i) {
  print("audioLink $i ");
  switch (i) {
/*    case "cold":
      return "images/cold_weather.mp3";
      break;*/
    case "hot":
      return "images/hot_weather.mp3";
      break;
    case "rain":
      return "images/rainy_weather.mp3";
      break;
    case "sunny":
      return "images/sunny_weather.mp3";
      break;
    case "thunder":
      return "images/thunderstorm_weather.mp3";
      break;
    case "cloudy":
      return "images/cloudy_weather.mp3";
      break;
    case "snow":
      return "images/snow_weather.mp3";
      break;
    /*default:
      return "images/hot_weather.mp3";*/
  }
}
/*
*
* */
