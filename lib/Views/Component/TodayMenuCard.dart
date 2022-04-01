//@dart=2.9
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shnuljoe/Model/DayDataModel.dart';
import 'package:shnuljoe/Views/styles/colors.dart';
import 'package:shnuljoe/Views/styles/textStyles.dart';

import '../../Constants.dart';
import '../../Strings.dart';

class TodayMenuCard extends StatelessWidget {
  TodayMenuCard({@required this.pageData});

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
    return Container(
      width: 320.w,
      // height: 360.h,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 0.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            pageData.day + " جو",
            style: AppTextStyles.headlineMediumStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pageData.temp + "C",
                style: AppTextStyles.tempMediumStyle,
              ),
              SizedBox(
                width: 10.w,
              ),
              SvgPicture.asset(
                imageLink(),
                width: 20.w,
                height: 20.h,
                fit: BoxFit.cover,
                color: Color(0xFF6C72B0),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                pageData.description,
                style: h4Arial.apply(color: Color(0xFF6C72B0)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            child: PhysicalModel(
              elevation: 0,
              shape: BoxShape.circle,
              color: Colors.transparent,
              child: Image(
                image: CachedNetworkImageProvider(pageData.lunch.imageURL),
                height: 100.h,
                width: 140.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 5.h,
            ),
            child: AutoSizeText(
              "${pageData.lunch.name}",
              style: AppTextStyles.titleLargeStyle,
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
                    width: 15.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                    color: AppColors.kPrimaryColor,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    pageData.lunch.time.toString(),
                    style: h4Arial.apply(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    " دقيقة".toString(),
                    style: h4Arial.apply(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "icons/serving_icon.svg",
                    width: 15.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                    color: AppColors.kPrimaryColor,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    pageData.lunch.number.toString(),
                    style: h4Arial.apply(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    " أفراد".toString(),
                    style: h4Arial.apply(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "سهل",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
