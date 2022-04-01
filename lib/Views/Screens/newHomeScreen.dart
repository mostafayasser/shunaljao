import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnuljoe/Views/Component/DetailsShadowContainer.dart';
import 'package:shnuljoe/Views/styles/colors.dart';
import 'package:shnuljoe/Views/styles/textStyles.dart';

import '../../Strings.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/slider1.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22.r,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage("images/profilePlaceholder.png"),
                              ),
                              Text(
                                " مرحبا بعودتك",
                                style: AppTextStyles.mediumTextStyle,
                              ),
                              Text(
                                "، سناء",
                                style: AppTextStyles.mediumTextStyle
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 3,
                                      offset: Offset(0, 0))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "الأيام السبعة القادمة",
                                  style: AppTextStyles.smallTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 11.w,
                                ),
                                SvgPicture.asset(
                                  "icons/calendar_icon.svg",
                                  width: 11.w,
                                  height: 11.h,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("icons/location_icon.svg"),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "تونس",
                            style: AppTextStyles.smallTextStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " ، تونس",
                            style: AppTextStyles.smallTextStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                            "2022 ,02 يرفيف",
                            style: AppTextStyles.smallTextStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      Text(
                        "24C",
                        style: AppTextStyles.tempLargeStyle,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("icons/rainy_weather_icon.svg"),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "ممطر",
                            style: AppTextStyles.titleLargeStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 58.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.kPrimaryColor,
                            size: 13.w,
                          ),
                          Text(
                            "اليوم جو",
                            style: AppTextStyles.headlineMediumStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.kPrimaryColor,
                            size: 13.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  height: 400.h,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        height: 300.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(0, 0))
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "شوربة الدجاج بالخضار",
                              style: AppTextStyles.titleLargeStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "icons/duration_icon.svg",
                                      width: 13.w,
                                      height: 13.h,
                                      fit: BoxFit.cover,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "20",
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
                                  width: 10.w,
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
                                      width: 1.w,
                                    ),
                                    Text(
                                      "5",
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
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DetailsShadowContainer(
                                  title: "فطور",
                                  svgIcon: "icons/breakfast_icon.svg",
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                DetailsShadowContainer(
                                  title: "غداء",
                                  svgIcon: "icons/lunch_icon.svg",
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                DetailsShadowContainer(
                                  title: "عشاء",
                                  svgIcon: "icons/dinner_icon.svg",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "images/profilePlaceholder.png",
                          height: 146.h,
                          width: 178.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
