import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants.dart';
import '../../Strings.dart';

snackBarC(msg,context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
                    child:Icon(
                      Icons.close,
                      color: primaryColorPink,
                      size: 30,
                    )
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    msg,
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
                child:  Icon(
                  Icons.add_shopping_cart,
                  color: primaryColorPink,
                  size: 30,
                ),)
            ],
          ),

        ),
        //backgroundColor: Colors.blue,
      )
  );
}