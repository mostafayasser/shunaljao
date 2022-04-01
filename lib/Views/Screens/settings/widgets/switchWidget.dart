import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shnuljoe/Views/styles/colors.dart';
import 'package:shnuljoe/Views/styles/textStyles.dart';

class SwitchWidget extends StatefulWidget {
  final String? title, switchName;
  final value, onChange;
  const SwitchWidget({
    Key? key,
    this.title,
    this.switchName,
    this.value,
    this.onChange,
  }) : super(key: key);

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
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
            widget.title!,
            style: AppTextStyles.headlineSmallStyle,
          ),
          Row(
            children: [
              Text(
                widget.switchName!,
                style: AppTextStyles.headlineSmallStyle.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              FlutterSwitch(
                padding: 2,
                switchBorder: Border.all(
                  color: AppColors.kPrimaryColor,
                  width: 2.0,
                ),
                borderRadius: 25.r,
                toggleSize: 13.r,
                inactiveColor: Colors.white,
                activeToggleColor: Colors.white,
                inactiveToggleColor: AppColors.kPrimaryColor,
                activeColor: AppColors.kPrimaryColor,
                width: 30.w,
                height: 20.h,
                value: widget.value,
                onToggle: (value) => setState(
                  () {
                    widget.onChange(value);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
