import 'package:edify/utils/constants/text_strings.dart';
import 'package:edify/utils/validators/validation.dart';
import 'package:flutter/material.dart';

class TTextFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  const TTextFormField(
      {super.key,
      this.validator,
      required this.controller,
      this.labelText,
      this.hintText,
      this.hintStyle,
      this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          hintStyle: hintStyle),
    );
  }
}
