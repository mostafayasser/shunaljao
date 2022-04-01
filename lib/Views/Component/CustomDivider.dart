import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color(0xFFEFE8E6),
      height: 0.5,
      thickness: 0.5,
    );
  }
}
