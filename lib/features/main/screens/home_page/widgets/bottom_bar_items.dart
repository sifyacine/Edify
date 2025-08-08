import 'package:flutter/material.dart';

class BottomBarItems extends StatelessWidget {
  final String text;
  final IconData iconData;

  const BottomBarItems({super.key, required this.text, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(iconData), Text(text)],
    );
  }
}
