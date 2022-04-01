import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnuljoe/Views/styles/colors.dart';
import 'package:shnuljoe/Views/styles/textStyles.dart';

class DetailsShadowContainer extends StatelessWidget {
  final svgIcon, title, quantity, isColored, onPressed;
  const DetailsShadowContainer({
    Key? key,
    this.svgIcon,
    this.title,
    this.quantity = "",
    this.isColored = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 55.w,
        height: 55.h,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
            color: isColored ? AppColors.kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 3, offset: Offset(0, 0))
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            svgIcon,
            width: 12.w,
            height: 12.h,
            color: isColored ? Colors.white : AppColors.kPrimaryColor,
          ),
          SizedBox(
            height: 7.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quantity,
                style: TextStyle(
                  color: isColored ? Colors.white : AppColors.kPrimaryColor,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Text(
                title,
                style: AppTextStyles.smallTextStyle.copyWith(
                  color: isColored ? Colors.white : AppColors.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
