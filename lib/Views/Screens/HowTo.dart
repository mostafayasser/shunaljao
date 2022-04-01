//@dart=2.9
import 'dart:async';
import 'dart:core';

import 'package:bubble/bubble.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/LocationController.dart';
import 'package:shnuljoe/Controller/StepsController.dart';
import 'package:shnuljoe/Model/DayDataModel.dart';
import 'package:shnuljoe/Model/MealModel.dart';
import 'package:shnuljoe/Views/Component/DetailsShadowContainer.dart';
import 'package:shnuljoe/Views/Component/IngredientCard.dart';
import 'package:shnuljoe/Views/Component/StepCard.dart';
import 'package:shnuljoe/Views/styles/colors.dart';
import 'package:shnuljoe/Views/styles/textStyles.dart';
import 'package:video_player/video_player.dart';

import '../../Constants.dart';
import '../../Strings.dart';
import 'SevenDaysMenu.dart';

class HowTo extends StatefulWidget {
  HowTo({@required this.pageData});

  final DayDataModel pageData;

  @override
  _HowToState createState() => _HowToState();
}

class _HowToState extends State<HowTo> with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController1;
  ChewieController chewieController;
  ScrollController scrollController;
  var scrollViewController;
  var text;
  MealModel myMeal;
  bool check = false;
  bool add = false;
  int currentPage = 0;

  Future initializePlayer() async {
    if (myMeal != null)
      print("##################Url Video: " + myMeal.videoURL);
    _videoPlayerController1 = VideoPlayerController.network(
      myMeal.videoURL,
    );

    await _videoPlayerController1.initialize();
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      aspectRatio: 16 / 9,
    );

    chewieController.addListener(() {
      clickOnVideo(context).then((value) => null);
    });
    setState(() {});
  }

  TabController _tabController;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    //   _tabController = new TabController(vsync: this, length: 2);
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            case 0:
              tab = 1;
              break;
            case 1:
              tab = 1;
              break;
          }
        });
      });
    //Provider.of<StepsPageController>(context, listen: false).onPageChange(0);
    Provider.of<LocationController>(context, listen: false).setStatus = false;
    myMeal =
        Provider.of<StepsPageController>(context, listen: false).mealToCook;
    initializePlayer().then((value) => print("Player initialised"));
    scrollController = ScrollController();
    // setState(() {});
    //howToEvent().then((value) => print("How to Screen"));
  }

  @override
  void dispose() {
    if (chewieController != null) {
      if (chewieController.isPlaying) chewieController.pause();
      chewieController.dispose();
    }
    Provider.of<LocationController>(context, listen: false).setStatus = true;
    backScreenEvent(context);
    super.dispose();
  }

  /* Future howToEvent() async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'How_to_Screen',
      parameters: <String, dynamic>{
        'How_to_Screen': "Success",
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    print('dfhsdhfksdhifh' + widget.pageData.temp);
    double Width = MediaQuery.of(context).size.width;
    myMeal =
        Provider.of<StepsPageController>(context, listen: false).mealToCook;
    print("########HOW TO Call");
    text = Provider.of<StepsPageController>(context, listen: false).text;
    print("%%%%%%%%Text " + text);
    return Consumer<StepsPageController>(
      builder: (context, model, child) {
        return WillPopScope(
            child: Scaffold(
              /* appBar: AppBar(
                backgroundColor: primaryColorPink,
                title: Center(
                  child: Text(
                    'شن الجو',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'DG-Bebo'),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SevenDaysMenu(),
                        ),
                      );
                    },
                    child: Tooltip(
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
                      child: SvgPicture.asset(
                        'images/menuR1.svg',
                        width: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w)
                ],
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25.h,
                  ),
                ),
              ), */
              body: NestedScrollView(

                  //  physics: NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              width: 41.w,
                              height: 41.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: 5.w,
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.kPrimaryColor,
                                    size: 17.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(
                              child: chewieController != null &&
                                      chewieController.videoPlayerController
                                          .value.isInitialized
                                  ? Chewie(
                                      controller: chewieController,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 20),
                                        Text('Loading'),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  myMeal.name,
                                  style: AppTextStyles.titleLargeStyle,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      DetailsShadowContainer(
                                        svgIcon: "icons/lunch_icon.svg",
                                        title: myMeal.type,
                                        isColored: true,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      DetailsShadowContainer(
                                        svgIcon: "icons/duration_icon.svg",
                                        title: "دقيقة",
                                        quantity: myMeal.time.toString(),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      DetailsShadowContainer(
                                        svgIcon: "icons/serving_icon.svg",
                                        quantity: myMeal.number.toString(),
                                        title: "أشخاص",
                                      ),
                                    ],
                                  ),
                                ),
                                //TODO Add meal description
                              ],
                            ),
                          ),
                        ],
                      )),
                      SliverToBoxAdapter(
                        child: Container(
                          //  margin: EdgeInsets.symmetric(
                          // horizontal:
                          //     MediaQuery.of(context).size.width * .052,
                          //   ),

                          child: TabBar(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            physics: ClampingScrollPhysics(),
                            indicatorColor: Colors.transparent,
                            controller: _tabController,
                            unselectedLabelColor: Colors.grey,
                            labelColor: primaryColorBlue,
                            //Colors.indigo[900],
                            labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                            labelStyle: h3Arial.apply(color: primaryColorBlue),
                            //indicator: primaryColorPink,
                            /*BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey[350]),*/
                            tabs: [
                              Container(
                                width: 180.w,
                                height: 30.h,
                                child: Center(
                                    child: Text(
                                  "المقادير",
                                  style: TextStyle(
                                    color: _tabController.index == 0
                                        ? Colors.white
                                        : AppColors.kPrimaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                    fontFamily: 'BalooBhaijaan2',
                                  ),
                                )),
                                decoration: BoxDecoration(
                                  color: _tabController.index == 0
                                      ? tabColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _tabController.index == 0
                                          ? Colors.transparent
                                          : Colors.black12,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                              Container(
                                width: 180.w,
                                height: 30.h,
                                child: Center(
                                    child: Text(
                                  "توجيهات",
                                  style: TextStyle(
                                    color: _tabController.index == 1
                                        ? Colors.white
                                        : AppColors.kPrimaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp,
                                    fontFamily: 'BalooBhaijaan2',
                                  ),
                                )),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _tabController.index == 1
                                          ? Colors.transparent
                                          : Colors.black12,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: _tabController.index == 1
                                      ? tabColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body:
                      /* Column(
                  mainAxisSize: MainAxisSize.min,*/
                      TabBarView(
                    controller: _tabController,
                    // physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.only(top: 10.h),
                        physics: const ClampingScrollPhysics(),
                        children: generator1(myMeal.ingredient, check, add),
                      ),
                      ListView(
                        padding: EdgeInsets.only(top: 10.h),
                        children: generator2(myMeal.steps),
                      ),
                    ],
                  )),
            ),
            onWillPop: () async {
              Navigator.pop(context, true);
              return true;
            });
      },
    );
  }

  Future clickOnIngredients(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Ingredients',
      parameters: <String, dynamic>{
        'View_Ingredients': "Success",
      },
    );
  }

  Future clickOnDirections(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Recipe',
      parameters: <String, dynamic>{
        'View_Recipe': "Success",
      },
    );
  }

  Future clickOnVideo(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'View_Recipe_Video',
      parameters: <String, dynamic>{
        'View_Recipe_Video': "Success",
      },
    );
  }

  Future backScreenEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Back_from_Recipe',
      parameters: <String, dynamic>{
        'Back_from_Recipe': "Success",
      },
    );
  }
}

List<Widget> generator1(myList, ch, add) {
  List<Widget> myListOfWidget = [];

  for (var i = 0; i < myList.length; i++) {
    myListOfWidget.add(IngredientCard(
      myText: myList[i],
      boolCheck: ch,
      boolAdd: add,
      index: i,
    ));
  }
  return myListOfWidget;
}

List<Widget> generator2(List myList1) {
  List<Widget> myListOfWidget1 = [];

  for (var i = 0; i < myList1.length; i++) {
    myListOfWidget1.add(StepCard(
      myText: myList1[i],
      myIndex: i + 1,
    ));
  }
  return myListOfWidget1;
}
