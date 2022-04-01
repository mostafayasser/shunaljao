//@dart=2.9
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Constants.dart';
import '../../Strings.dart';

class StepCard extends StatefulWidget {
  const StepCard({
    @required this.myIndex,
    @required this.myText,
  });

  final String myText;
  final int myIndex;

  @override
  _StepCardState createState() => _StepCardState(myIndex);
}

class _StepCardState extends State<StepCard> {
  var someBooleanValue = false;
  int index;
  _StepCardState(int myIndex) {
    index = myIndex;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.only(left: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.myText,
                          style: h4Arial.apply(color: primaryColorBlue),
                          textAlign: TextAlign.end,
                        ),
                      ),

                      Transform.scale(
                        scale: 1.5,
                        child: Padding(
                          padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                          child: Card(
                            elevation: 3,
                            color: tabColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Container(
                                    child: Center(
                                  child: Text("${widget.myIndex}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 9.sp)),
                                ))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future tickRecipeDirections(BuildContext context) async {
  FirebaseAnalytics analytics =
      Provider.of<FirebaseAnalytics>(context, listen: false);
  await analytics.logEvent(
    name: 'Tick_Recipe_Directions',
    parameters: <String, dynamic>{
      'Tick_Recipe_Directions': "Success",
    },
  );
}
