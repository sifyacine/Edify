import 'package:edify/features/main/screens/courses/add_course/add_a_lesson.dart';
import 'package:edify/features/main/screens/videos/video_view.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class ShowListVideos extends StatelessWidget {
  final List videos;
  final int courseID;
  final int userID;
  const ShowListVideos(
      {super.key,
      required this.videos,
      required this.userID,
      required this.courseID});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: videos.isEmpty
          ? Column(
              children: [
                Center(
                  child: Lottie.asset(
                      "assets/images/animations/53207-empty-file.json"),
                ),
                InkWell(
                    onTap: () async {
                      Get.to(() => AddALesson(
                            courseID: courseID,
                            userID: userID,
                          ));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Lessons, "),
                        Text(
                          "Add from Here",
                          style: TextStyle(
                              decorationStyle: TextDecorationStyle.dotted,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              fontFamily: "NotoSansArabic",
                              fontWeight: FontWeight.bold,
                              color: TColors.primary),
                        ),
                      ],
                    ))
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int i) {
                DateTime videoTime = DateTime.parse(videos[i]['create_at']);
                String videoTimeFormate =
                    DateFormat('yyyy-MM-dd').format(videoTime);
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.to(() => VideoView(
                              videos: videos[i],
                              lessonNumber: i + 1,
                              courseID: courseID,
                              userID: userID,
                            ));
                      },
                      child: Container(
                        color: Colors.grey[200],
                        child: ListTile(
                          leading: const Icon(
                            Icons.video_collection_outlined,
                          ),
                          title: Text(
                            "Lesson ${i + 1}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Rowdies"),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ReadMoreText(
                                      videos[i]["video_title"],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: "NotoSansArabic"),
                                      textAlign: TextAlign.start,

                                      trimLines:
                                          1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '.',
                                      trimExpandedText: '.',

                                      moreStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 61, 13, 173)),
                                      lessStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 173, 172, 172)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    videoTimeFormate,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "CairoPlay",
                                        color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_right,
                            color: TColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                );
              }),
    );
  }
}
