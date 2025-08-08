import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/screens/videos/widgets/show_homework_img.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class SelectedLesson extends StatelessWidget {
  final BetterPlayerController betterPlayerController;
  final List homeworks;
  final String title;
  final String desc;
  const SelectedLesson(
      {super.key,
      required this.betterPlayerController,
      required this.homeworks,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BetterPlayer(controller: betterPlayerController),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const Icon(Icons.radio_button_checked),
              Expanded(
                child: ReadMoreText(
                  title,
                  trimLines: 1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Read More',
                  trimExpandedText: '...Read Less',

                  moreStyle: const TextStyle(color: TColors.primary),
                  lessStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 172, 172)),
                  style: const TextStyle(
                      fontFamily: 'NotoSansArabic',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: ReadMoreText(
                  " $desc ",
                  trimLines: 1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Read More',
                  trimExpandedText: '...Read Less',

                  moreStyle: const TextStyle(color: TColors.primary),
                  lessStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 172, 172)),
                  style: const TextStyle(
                      fontFamily: 'NotoSansArabic',
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: homeworks.length,
              itemBuilder: (context, index) {
                return homeworks.isEmpty
                    ? const Text(
                        '',
                      )
                    : SizedBox(
                        height: 200,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () async {
                                    Get.to(() =>
                                        ShowHomework(url: homeworks[index]));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: "${homeworks[index]}",
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                    placeholder: (context, url) =>
                                        LottieBuilder.asset(
                                            "assets/images/animations/141397-loading-juggle.json"),
                                    errorWidget: (context, url, error) =>
                                        Lottie.asset(
                                            "assets/images/animations/53207-empty-file.json"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              }),
        ),
      ],
    );
  }
}
