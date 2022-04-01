import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shnuljoe/Views/styles/colors.dart';

import '../../../styles/textStyles.dart';

class CustomTile extends StatelessWidget {
  final title;
  const CustomTile({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      margin: EdgeInsets.only(
        bottom: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmallStyle,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.kPrimaryColor,
            size: 13,
          )
        ],
      ),
    );
  }
}
