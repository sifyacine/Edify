import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/controller/videos/video_view_controller.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/features/main/screens/videos/widgets/show_homework_img.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class VideoView extends StatelessWidget {
  final Map videos;
  final int lessonNumber;
  final int userID;
  final int courseID;

  const VideoView(
      {super.key,
      required this.videos,
      required this.lessonNumber,
      required this.userID,
      required this.courseID});
  @override
  Widget build(BuildContext context) {
    VideoViewControllerImp videoViewControllerImp = Get.put(
      VideoViewControllerImp(videos, userID, courseID),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Lesson ${lessonNumber.toString()}"),
        ),
        body: videos.isEmpty
            ? const Center(
                child: Row(
                  children: [
                    Icon(Icons.videocam_off_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "No video yet",
                      style:
                          TextStyle(fontFamily: "NotoSansArabic", fontSize: 20),
                    ),
                  ],
                ),
              )
            : ListView(children: [
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: videoViewControllerImp.betterPlayerController,
                    )),
                const SizedBox(
                  height: 10,
                ),
                // Title and desc
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.panorama_wide_angle_select_sharp),
                          Expanded(
                              child: Text(
                            "${videos["video_title"]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: "NotoSansArabic",
                                fontWeight: FontWeight.bold),
                          )),
                          const Icon(Icons.panorama_wide_angle_select_sharp),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(""),
                          Expanded(
                              child: ReadMoreText(
                            "${videos["video_desc"]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "NotoSansArabic"),
                            trimLines:
                                2, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' ...Read More',
                            trimExpandedText: ' ...Read Less',

                            moreStyle: const TextStyle(color: TColors.primary),
                            lessStyle: const TextStyle(
                                color: Color.fromARGB(255, 173, 172, 172)),
                          )),
                          const Text("")
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: videos["homeworks"].length,
                      itemBuilder: (context, index) {
                        List homeworks = videos["homeworks"];
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
                                            Get.to(() => ShowHomework(
                                                url: homeworks[index]
                                                    ["homework_file"]));
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://education15845d.pythonanywhere.com${homeworks[index]["homework_file"]}",
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 200,
                                            placeholder: (context, url) =>
                                                LottieBuilder.asset(
                                                    "assets/images/animations/141397-loading-juggle.json"),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Lottie.asset(
                                                    "assets/images/animations/53207-empty-file.json"),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 5,
                                          right: 5,
                                          child: InkWell(
                                              onTap: () async {
                                                await videoViewControllerImp
                                                    .deleteHomeWork(
                                                        videos["homeworks"]
                                                            [index]["id"]);
                                              },
                                              child: const CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Color.fromARGB(
                                                    104, 158, 158, 158),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ))),
                                    ],
                                  ),
                                ),
                              );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        await videoViewControllerImp.deleteLesson(videos['id']);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontFamily: "NotoSansArabic"),
                      )),
                )
              ]));
  }
}
