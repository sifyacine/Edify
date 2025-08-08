import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class BottomPartShortView extends StatelessWidget {
  final String title;
  final String memberFullName;
  final List hashtags;
  const BottomPartShortView({
    super.key,
    required this.title,
    required this.memberFullName,
    required this.hashtags,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Text(
            '@$memberFullName',
            style: const TextStyle(
              fontSize: 19,
              fontFamily: "NotoSansArabic",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ReadMoreText(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "NotoSansArabic"),
                  trimLines: 1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' ',
                  trimExpandedText: '..',

                  moreStyle: const TextStyle(color: TColors.primary),
                  lessStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 172, 172)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hashtags.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        hashtags[index],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 164, 231, 252),
                            fontSize: 16),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
