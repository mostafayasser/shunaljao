//بسم الله الرحمن الرحيم
//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/LocalDataController.dart';



import '../../Constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySwitch extends StatelessWidget {
  const MySwitch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 28.h,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r)
      ),
      child: Row(
        mainAxisAlignment: Provider.of<LocalDataController>(context).languageBool ? MainAxisAlignment.end :  MainAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColorPink,
            ),
          ),
        ],
      ),
    );
  }
}
