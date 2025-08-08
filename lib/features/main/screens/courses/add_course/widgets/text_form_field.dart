import 'package:edify/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TextFormFieldCourse extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final int maxLength;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final int? maxLines;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool autofocus;

  const TextFormFieldCourse(
      {super.key,
      required this.textController,
      required this.hintText,
      required this.maxLength,
      this.prefixIcon,
      this.sufixIcon,
      this.maxLines,
      this.labelText,
      this.validator,
      required this.autofocus});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      validator: validator,
      maxLength: maxLength,
      cursorColor: Colors.purple,
      controller: textController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(r'''[!@#\$%^&*()+\=\[\]{}|\\:;"\'<>/?]'''),
        ),
      ],
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: sufixIcon,
        hintText: hintText,
        prefixIcon: prefixIcon,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 53, 53, 53),
            fontFamily: 'NotoSansArabic'),
        labelStyle: const TextStyle(
            fontFamily: 'NotoSansArabic',
            fontSize: 16,
            fontWeight: FontWeight.w700),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
