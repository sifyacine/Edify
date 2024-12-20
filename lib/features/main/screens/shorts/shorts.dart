import 'package:better_player/better_player.dart';
import 'package:edify/features/main/controller/shorts/show_short_controller.dart';
import 'package:edify/features/main/screens/shorts/widgets/bottomPart.dart';
import 'package:edify/features/main/screens/shorts/widgets/rightPart.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class ShortVideo extends StatelessWidget {
  const ShortVideo({super.key});

  @override
  Widget build(BuildContext context) {
    ShowShortControllerImp controller = Get.put(ShowShortControllerImp());

    return Scaffold(
        body: Obx(
      () => controller.shorts.isEmpty
          ? Center(
              child: Lottie.asset(
                  "assets/images/animations/141397-loading-juggle.json"),
            )
          : PageView.builder(
              onPageChanged: (index) async {
                controller.changeVideo(index);
              },
              scrollDirection: Axis.vertical,
              itemCount: controller.videoPlayerControllers.length,
              itemBuilder: (context, i) {
                controller.currentIndex.value = i;
                final videoController = controller.videoPlayerControllers[i];
                videoController.setLooping(true);

                videoController.play();

                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          if (controller.playing.value) {
                            controller.playing.value = false;
                            videoController.pause();
                          } else {
                            controller.playing.value = true;
                            videoController.play();
                          }
                        },
                        child: VideoPlayer(videoController),
                      ),
                    ),
                    // باقي عناصر الواجهة كـ BottomPartShortView و RightPart
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: BottomPartShortView(
                        title: ' ${controller.shorts[i]['short_title']}',
                        memberFullName:
                            '${controller.shorts[i]['member']['full_name']}',
                        memerPhotoProfil: 'assets/logos/google-icon.png',
                      ),
                    ),
                    Positioned(
                        right: 20,
                        bottom: Get.width / 4,
                        child: Obx(
                          () => Rightpart(
                            soundControl: InkWell(
                              onTap: () {
                                if (controller.volume.value) {
                                  controller.volume.value = false;
                                  videoController.setVolume(0.0);
                                } else {
                                  controller.volume.value = true;
                                  videoController.setVolume(1.0);
                                }
                              },
                              child: controller.checkVolumeVideo(),
                            ),
                            memerPhotoProfil: 'assets/logos/google-icon.png',
                            shortLikes: controller
                                .increaseWithDecreaseLike(
                                    controller.shorts[i]['short_likes'], i)
                                .toString(),
                            shortComments:
                                '${controller.shorts[i]['short_comments']}',
                            comment: () async {
                              await controller.getComments(
                                  controller.shorts[i]['id'], i);
                            },
                            share: () {},
                            save: () {},
                            like: LikeButton(
                              circleColor: const CircleColor(
                                  start: TColors.primary, end: Colors.red),
                              isLiked: controller.likesVideo[i].value,
                              onTap: (val) async {
                                return await controller.likeVideo(
                                    '${controller.shorts[i]['id']}', i);
                              },
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,

                                  size: controller.isLiked.value ? 40 : 32,
                                  color: controller.likesVideo[i].value
                                      ? Colors.red
                                      : Colors
                                          .white, // هنا نغير اللون إلى الأبيض
                                );
                              },
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: Get.width,
                        child: VideoProgressIndicator(
                          videoController,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: TColors.primary,
                            backgroundColor: Color.fromARGB(144, 241, 241, 241),
                            bufferedColor: Color.fromARGB(197, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    ));
  }
}
