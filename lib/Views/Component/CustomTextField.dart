import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final int lines;
  final bool secure;
  final Color color;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? icon;
  final String? Function(String?)? validator;

  const CustomTextFormField(
      {Key? key,
      this.secure = false,
      required this.controller,
      required this.hint,
      this.lines = 1,
      this.keyboardType = TextInputType.text,
      this.icon,
      this.validator,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: const Color(0xFFEFE8E6),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: TextFormField(
        textDirection: TextDirection.rtl,
        validator: validator,
        maxLines: lines,
        keyboardType: keyboardType,
        obscureText: secure,
        controller: controller,
        style: TextStyle(
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          icon: icon,
          hintText: hint,
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Color(0xFFC9C5C6),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
