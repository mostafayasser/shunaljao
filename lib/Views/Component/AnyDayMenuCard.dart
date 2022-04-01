//@dart=2.9
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/LocalDataController.dart';
import 'package:shnuljoe/Model/DayDataModel.dart';

import '../../Constants.dart';
import '../../Strings.dart';
import '../styles/colors.dart';
import '../styles/textStyles.dart';

class AnyDayMenuCard extends StatelessWidget {
  AnyDayMenuCard({@required this.pageData});

  final DayDataModel pageData;

  String imageLink() {
    String link;
    switch (pageData.description) {
      case "ماطر":
        link = "icons/rainy_weather_icon.svg";
        break;
      case "عاصفة رعدية":
        link = "icons/rainy_weather_icon.svg";
        break;
      case "غائم":
        link = "icons/cloudy_weather_icon.svg";
        break;
      case "ثلج":
        link = "icons/cloudy_weather_icon.svg";
        break;
      case "شمس":
        link = "icons/sunny_weather_icon.svg";
        break;
      case "الحار":
        link = "icons/sunny_weather_icon.svg";
        break;
    }
    return link;
  }

  @override
  Widget build(BuildContext context) {
    log("bhdf" + pageData.day.toString());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 0.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 7.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pageData.dayDate + "-" + pageData.month,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  child: SvgPicture.asset(
                    imageLink(),
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  pageData.temp.toString() + cc1,
                  style: AppTextStyles.tempSmallStyle,
                ),
              ],
            ),
          ),
          (pageData.lunch != null)
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                    ),
                    child: Image(
                      image: NetworkImage(pageData.lunch.imageURL),
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "سهل",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                  ),
                  child: AutoSizeText(
                    "${pageData.lunch.name}",
                    style: AppTextStyles.titleMediumStyle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "icons/duration_icon.svg",
                          width: 10.w,
                          height: 10.h,
                          fit: BoxFit.cover,
                          color: AppColors.kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          pageData.lunch.time.toString(),
                          style: h6Arial.apply(
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                        Text(
                          " دقيقة".toString(),
                          style: h6Arial.apply(
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "icons/serving_icon.svg",
                          width: 13.w,
                          height: 13.h,
                          fit: BoxFit.cover,
                          color: AppColors.kPrimaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          pageData.lunch.number.toString(),
                          style: h6Arial.apply(
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                        Text(
                          " أفراد".toString(),
                          style: h6Arial.apply(
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
