//بسم الله الرحمن الرحيم
//@dart=2.9
import 'package:flutter/material.dart';

import '../../Constants.dart';
import '../../Strings.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderCard extends StatelessWidget {
  SliderCard({
    @required this.image,
    @required this.title,
    @required this.detail,
  });

  final String image;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      height: 360.h,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r), color: Colors.white),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(
                right: image == "images/slider2.png" ? 10.0 : 0),
            child: Image(
              image: AssetImage(image),
              width: 240.w,
              height: 160.h,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: h2.apply(color: primaryColorPink),
                ),
                Text(
                  detail,
                  style: h3Arial.apply(color: primaryColorBlue),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
