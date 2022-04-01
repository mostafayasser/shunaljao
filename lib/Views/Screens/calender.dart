//بسم الله الرحمن الرحيم
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Constants.dart';
import 'package:shnuljoe/Controller/LocalDataController.dart';
import 'package:shnuljoe/Controller/LocationController.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';
import 'package:shnuljoe/Views/Component/AnyDayMenuCard.dart';
import 'package:shnuljoe/Views/Component/CustomTextField.dart';
import 'package:shnuljoe/Views/Component/TodayMenuCard.dart';
import 'package:shnuljoe/Views/styles/colors.dart';

import '../../Strings.dart';

class SevenDaysMenu extends StatefulWidget {
  @override
  _SevenDaysMenuState createState() => _SevenDaysMenuState();
}

class _SevenDaysMenuState extends State<SevenDaysMenu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocationController>(context, listen: false).setStatus = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<LocationController>(context, listen: false).setStatus = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('will pop scope 7 days');
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: CustomTextFormField(
              icon: Icon(
                Icons.search,
                color: AppColors.kPrimaryColor,
              ),
              controller: TextEditingController(),
              hint: "إبحث عن وصفة"),
          actions: [
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                "icons/filters_icon.svg",
                height: 30.h,
                width: 30.w,
              ),
            ),
          ],
          /* actions: [
            Opacity(
              opacity: 0.001,
              child: Tooltip(
                //    key: _toolTipKey,
                decoration: BoxDecoration(
                  color: primaryColorPink,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
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
            SizedBox(width: 15.w),
          ], */
          leadingWidth: 50.w,
          leading: Container(
            margin: EdgeInsetsDirectional.only(
              start: 10.w,
            ),
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
                  size: 20.w,
                ),
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                TodayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[0]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[1]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[2]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[3]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[4]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[5]),
                AnyDayMenuCard(
                    pageData:
                        Provider.of<PagesDataController>(context).pagesList[6]),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    Provider.of<LocalDataController>(context).sevenDays,
                    style: h2,
                    textAlign: TextAlign.center,
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
