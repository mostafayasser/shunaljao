//@dart=2.9
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Views/Component/CustomDivider.dart';

import '../../Constants.dart';
import '../../Controller/StepsController.dart';
import '../../Strings.dart';
import '../styles/colors.dart';

class IngredientCard extends StatefulWidget {
  IngredientCard({
    @required this.myText,
    this.boolCheck,
    this.boolAdd,
    this.index,
  });

  final String myText;

  bool boolCheck;
  bool boolAdd;
  final int index;

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  var someBooleanValue = false;
  var cartBooleanValue = false;
  SharedPreferences pref;

  String recText;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      content: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 12.w,
            ),
            Transform.scale(
              scale: 1,
              child: GestureDetector(
                  onTap: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Icon(
                    Icons.close,
                    color: primaryColorPink,
                    size: 30,
                  )),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  widget.myText,
                  style: h4Arial.apply(color: primaryColorBlue),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Transform.scale(
              scale: 1,
              child: Icon(
                Icons.add_shopping_cart,
                color: primaryColorPink,
                size: 30,
              ),
            )
          ],
        ),
      ),
      //backgroundColor: Colors.blue,
    );
    final alreadyExist = SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      content: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 12.w,
            ),
            Transform.scale(
              scale: 1,
              child: GestureDetector(
                  onTap: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Icon(
                    Icons.close,
                    color: primaryColorPink,
                    size: 30,
                  )),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "المكون موجود بالفعل ",
                  style: h4Arial.apply(color: primaryColorBlue),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ),
      //backgroundColor: Colors.blue,
    );
    return Consumer<StepsPageController>(
      builder: (ctx, controller, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 14.h,
                          width: 14.w,
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 6.h),
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Color(0xffEC008C),
                            side: BorderSide(
                              color: primaryColorPink, //your desire colour here
                              width: 1,
                            ),
                            value: controller.ingredientChecked[widget.index],
                            shape: CircleBorder(),
                            onChanged: (bool value) {
                              controller.toggleIngredientsChecked(
                                  widget.index, value);
                              if (value) {
                                tickIngredients(context);
                              }
                            },
                          )),
                      SizedBox(
                        width: 10.w,
                      ),
                      Flexible(
                        child: Text(
                          widget.myText,
                          style: TextStyle(
                            color: AppColors.kAccentColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            fontFamily: 'BalooBhaijaan2',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () async {
                    recText = widget.myText;
                    setState(() {
                      if (cartBooleanValue == false) {
                        cartBooleanValue = true;

                        if (list.userSearchItems.contains(widget.myText)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(alreadyExist);
                        } else {
                          list.userSearchItems.add(widget.myText);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        cartBooleanValue = false;
                        list.userSearchItems.remove(widget.myText);
                      }
                    });

                    pref = await SharedPreferences.getInstance();
                    pref.setStringList('ItemList', list.userSearchItems);
                    log(pref.get("ItemList").toString());
                  },
                  child: SvgPicture.asset(
                    "icons/shopping_cart_icon.svg",
                    width: 14.w,
                    height: 14.h,
                    color:
                        cartBooleanValue == false ? Colors.black : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(),
        ],
      ),
    );
  }
}

Future tickIngredients(BuildContext context) async {
  FirebaseAnalytics analytics =
      Provider.of<FirebaseAnalytics>(context, listen: false);
  await analytics.logEvent(
    name: 'Tick_Ingredients',
    parameters: <String, dynamic>{
      'Tick_Ingredients': "Success",
    },
  );
}
