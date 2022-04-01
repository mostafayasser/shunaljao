//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/SliderController.dart';
import 'package:shnuljoe/Views/Component/SliderCard.dart';
import 'package:shnuljoe/Views/Screens/HomeScreen.dart';

import '../../Constants.dart';
import '../../Strings.dart';

class IntroSlider extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  AssetsAudioPlayer audioPlayer;
  var random = new Random();

  List sliders = [
    "images/1.mp3",
    "images/2.mp3",
    "images/3.mp3",
    "images/4.mp3",
    "images/5.mp3",
    "images/6.mp3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorPink,
      body: Container(
        height: 760.h,
        width: 360.w,
        decoration: BoxDecoration(
          color: Color(0xffEC008C),
          image: DecorationImage(
              image: AssetImage(
                "images/whitepattern.png",
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(height: 170.h),
            Container(
              height: 360.h,
              child: PageView(
                controller: Provider.of<SliderController>(context).controller,
                onPageChanged: (v) {
                  Provider.of<SliderController>(context, listen: false)
                      .onPageChange(v);
                  audioPlayer.stop();
                  //  startPlayer1(Audio(sliders[random.nextInt(5)]));
                },
                physics: BouncingScrollPhysics(),
                children: [
                  SliderCard(
                      image: 'images/slider1.png',
                      title: slider1Header,
                      detail: slider1Details),
                  SliderCard(
                      image: 'images/slider2.png',
                      title: slider2Header,
                      detail: slider2Details),
                  SliderCard(
                      image: 'images/slider3.png',
                      title: slider3Header,
                      detail: slider3Details),
                ],
              ),
            ),
            SizedBox(height: 67.h),
            GestureDetector(
              onTap: () {
                if (Provider.of<SliderController>(context, listen: false)
                        .currentPage <
                    2) {
                  Provider.of<SliderController>(context, listen: false)
                      .changePage();
                } else {
                  audioPlayer.stop();
                  print('nav');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              child: Container(
                width: 90.w,
                height: 40.h,
                margin: EdgeInsets.only(left: 190.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36.r)),
                child: Center(
                  child: Text(
                    next,
                    style: h3Arial.apply(color: primaryColorPink),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 58.h),
            DotsIndicator(
              dotsCount: 3,
              position:
                  Provider.of<SliderController>(context).currentPage.toDouble(),
              decorator: DotsDecorator(
                size: Size.square(11.0.r),
                activeSize: Size.square(11.0.r),
                activeColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.stop(); //
    super.dispose();
  }

  @override
  void initState() {
    super.initState(); //
    audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(
        Audio(sliders[random.nextInt(5)]), //Audio('images/intro.mp3'),
        autoStart: true,
        showNotification: true);
  }
}
