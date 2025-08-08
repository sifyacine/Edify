import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/controller/courses/course_details_controller.dart/teacher_view/course_purchase_controller.dart';
import 'package:edify/features/main/screens/courses/course_details/course_purchase/widgets/selected_lesson.dart';
import 'package:edify/features/main/screens/videos/widgets/show_homework_img.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class CoursePurchase extends StatelessWidget {
  late List course;
  CoursePurchase({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    CoursePurchaseControllerImp controller =
        Get.put(CoursePurchaseControllerImp("videoUrl"));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Course Details",
          style: TextStyle(fontFamily: "NotoSansArabic"),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SelectedLesson(
              betterPlayerController: controller.betterPlayerController,
              homeworks: controller.homeworks,
              title: " Title of the course",
              desc:
                  "Description of the course, provide readers with a brief, general description of the subject matter covered in the course"),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int i) {
                CoursePurchaseControllerImp controller = Get.put(
                    CoursePurchaseControllerImp(
                        "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4"));
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.video_file_sharp),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: TColors.primary,
                      ),
                      title: Row(
                        children: [
                          Text(
                            " Lesson ${i + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      subtitle: const Row(
                        children: [
                          Expanded(
                            child: ReadMoreText(
                              " Title of this course",
                              trimLines:
                                  1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '...Read More',
                              trimExpandedText: '...Read Less',

                              moreStyle: TextStyle(color: TColors.primary),
                              lessStyle: TextStyle(
                                  color: Color.fromARGB(255, 173, 172, 172)),
                              style: TextStyle(
                                  fontFamily: 'NotoSansArabic', fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                );
              })
        ],
      ),
    );
  }
}
