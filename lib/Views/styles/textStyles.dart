import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shnuljoe/Views/styles/colors.dart';

class AppTextStyles {
  static final titleLargeStyle = TextStyle(
    color: AppColors.kAccentColor,
    fontWeight: FontWeight.w500,
    fontSize: 22.sp,
    fontFamily: 'BalooBhaijaan2',
  );
  static final titleMediumStyle = TextStyle(
    color: AppColors.kAccentColor,
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    fontFamily: 'BalooBhaijaan2',
  );
  static final headlineMediumStyle = TextStyle(
    color: AppColors.kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    fontFamily: 'BalooBhaijaan2',
  );
  static final headlineSmallStyle = TextStyle(
    color: AppColors.kPrimaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    fontFamily: 'BalooBhaijaan2',
  );
  static final tempSmallStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
  );
  static final tempMediumStyle = TextStyle(
    color: Color(0xFF6C72B0),
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
  );
  static final tempLargeStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 50.sp,
  );
  static final smallTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 9.sp,
  );
  static final mediumTextStyle = TextStyle(
    color: AppColors.kPrimaryColor,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
  );
}
