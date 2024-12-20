import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ShowHashtags extends StatelessWidget {
  final List<dynamic>? hashtags;
  final controller;
  const ShowHashtags({super.key, required this.hashtags, this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الأعمدة
        crossAxisSpacing: 5, // المسافة بين الأعمدة
        mainAxisSpacing: 5, // المسافة بين الصفوف
        childAspectRatio: 5,
      ),
      itemCount: hashtags!.length, // عدد العناصر في الشبكة
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            controller.removeHashtag(index);
          },
          child: Card(
            color: TColors.primary,
            child: Text(
              textAlign: TextAlign.center,
              " # ${hashtags![index]}",
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
