import 'package:better_player/better_player.dart';
import 'package:edify/features/main/controller/homepage/shorts/shorts_controller.dart';

import 'package:edify/features/main/screens/shorts/widgets/bottomPart.dart';
import 'package:edify/features/main/screens/shorts/widgets/comment_short.dart';

import 'package:edify/features/main/screens/shorts/widgets/rightPart.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

import 'package:video_player/video_player.dart';

class ShortVideo extends StatefulWidget {
  const ShortVideo({super.key});

  @override
  State<ShortVideo> createState() => _ShortVideoState();
}

class _ShortVideoState extends State<ShortVideo>
    with AutomaticKeepAliveClientMixin {
  ShortsControllerImp controller = Get.put(ShortsControllerImp());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => controller.isLoading.value
            ? Center(
                child: Lottie.asset(
                "assets/images/animations/loading3.json",
                width: 200,
                height: 200,
              ))
            : controller.shorts.isNotEmpty
                ? PageView.builder(
                    controller: controller.scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.shorts.length,
                    onPageChanged: (index) {
                      controller.onPageChanged(index);

                      if (index - 1 >= 0 &&
                          index + 1 <= controller.shorts.length) {
                        controller.videosController[index - 1].pause();
                        controller.videosController[index].play();
                      }
                    },
                    itemBuilder: (BuildContext context, int i) {
                      Map shorts = controller.shorts[i];
                      return InkWell(
                          onTap: () async {
                            controller.pausePlayVideo(i);
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: AspectRatio(
                                    aspectRatio: 9 / 16,
                                    child: VideoPlayer(
                                        controller.videosController[i])),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 80,
                                child: Rightpart(
                                    shortComments:
                                        shorts["short_comments"].toString(),
                                    comment: () async {
                                      Get.to(() => CommentShort(
                                            shortId: controller.shorts[i]['id'],
                                          ));
                                    },
                                    share: () {},
                                    save: InkWell(
                                      onTap: () async {
                                        controller.saveUnSaveShort(
                                            controller.shorts[i]['id'],
                                            shorts['is_saved']);
                                        shorts['is_saved'] =
                                            !shorts['is_saved'];
                                        controller.shorts.refresh();
                                      },
                                      child: !shorts['is_saved']
                                          ? const Icon(
                                              Iconsax.save_add,
                                              color: Colors.white,
                                              size: 26,
                                            )
                                          : const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(Iconsax.save_21,
                                                  color: TColors.primary,
                                                  size: 30),
                                            ),
                                    ),
                                    like: LikeButton(
                                      isLiked: controller.shortsIsLiked[i],
                                      likeBuilder: (isLike) {
                                        return Icon(
                                          isLike
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isLike
                                              ? const Color.fromARGB(
                                                  255, 241, 30, 15)
                                              : const Color.fromARGB(
                                                  255, 255, 255, 255),
                                          size: 34,
                                        );
                                      },
                                      onTap: (isLiked) =>
                                          controller.likeDislike(
                                              controller.shorts[i]['id'], i),
                                    ),
                                    shortLikes: Obx(() => Text(
                                          controller.shortsLikes[i].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                    memerPhotoProfil:
                                        "assets/images/content/user.png",
                                    soundControl: Text("")),
                              ),
                              Positioned(
                                  bottom: 20,
                                  left: 10,
                                  right: Get.width / 3.5,
                                  child: BottomPartShortView(
                                    title: shorts["short_title"],
                                    memberFullName: shorts["member"]
                                        ["full_name"],
                                    hashtags: const [
                                      "#edify",
                                      "#younes tb",
                                      "#math",
                                      "#learn"
                                    ],
                                  ))
                            ],
                          ));
                    })
                : Center(
                    child: Lottie.asset(
                    "assets/images/animations/loading3.json",
                    width: 200,
                    height: 200,
                  ))));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
