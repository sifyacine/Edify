import 'package:edify/features/main/controller/homepage/home/home_controller.dart';
import 'package:edify/features/main/models/course/courseDetails.dart';
import 'package:edify/features/main/screens/courses/course_details/course_card.dart';
import 'package:edify/features/main/screens/courses/course_details/course_details.dart';
import 'package:edify/features/main/screens/posts/post_comment.dart';
import 'package:edify/features/main/screens/posts/post_widget.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/features/main/screens/shorts/shorts.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeControllerImp controller =
        Get.put(HomeControllerImp(), permanent: true, tag: "home");
    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                Image.asset(
                  "assets/logos/edify.png",
                  width: 50,
                  height: 50,
                ),
                const Text(
                  "Edify",
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 129, 42),
                      fontFamily: "NotoSansArabic",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text("Search",
                        style: TextStyle(
                            color: Color.fromARGB(255, 126, 126, 126))),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.search_normal_1,
                          color: Colors.black,
                        )),
                    Stack(
                      children: [
                        const Positioned(
                            bottom: 5,
                            right: 5,
                            child: Text(
                              "1",
                              style: TextStyle(color: Colors.red),
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.notification,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
            floating: true,
            snap: true,
            backgroundColor: Color.fromARGB(255, 243, 243, 243),
            foregroundColor: Colors.black,
            elevation: 0,
          ),

          /// ✅ المحتوى المتغير (Posts & Courses)
          controller.mixedObjects.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var item = controller.mixedObjects[index];
                      var type = item['type'];
                      var data = item['data'];

                      if (type == 'post') {
                        DateTime postTime = DateTime.parse(data['post_time']);
                        String postTimeAgo = timeago.format(postTime);

                        return Column(
                          children: [
                            PostView(
                              postReport: () async {
                                Get.to(() => const SendReport(), arguments: {
                                  'member': data['id'],
                                  "userID": controller.userID,
                                  "type": "post",
                                });
                              },
                              memberPic:
                                  "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg",
                              memberFullName: data['member']['full_name'],
                              postTime: postTimeAgo,
                              postTitle: data["post_title"],
                              likesNumber:
                                  controller.formatNumber(data['post_likes']),
                              commentsNumber: controller
                                  .formatNumber(data['post_comments']),
                              likeWidget: LikeButton(
                                isLiked: data['is_liked'],
                                likeBuilder: (isLiked) {
                                  return Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked
                                        ? const Color.fromARGB(255, 241, 30, 15)
                                        : Colors.black,
                                    size: isLiked ? 30 : 25,
                                  );
                                },
                                onTap: (isLiked) async {
                                  data["is_liked"] = !isLiked;
                                  data['post_likes'] = isLiked
                                      ? data['post_likes'] - 1
                                      : data['post_likes'] + 1;
                                  controller.mixedObjects[index]['data'] = data;
                                  controller.mixedObjects.refresh();
                                  await controller.likeDislikePost(
                                      data["id"], data["is_liked"]);
                                  return !isLiked;
                                },
                              ),
                              images: data["images"],
                              viewCommentsOntap: InkWell(
                                onTap: () {
                                  Get.to(() => const PostCommentView(),
                                      arguments: {
                                        'postID': data['id'],
                                        "userID": controller.userID,
                                        "commentNumber": data['post_comments'],
                                      });
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Iconsax.message),
                                    Text(
                                      " Comment",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTapComment: () {
                                Get.to(() => const PostCommentView(),
                                    arguments: {
                                      'postID': data['id'],
                                      "userID": controller.userID,
                                      "commentNumber": data['post_comments'],
                                    });
                              },
                              onTapFollow: () {},
                              onTapRemovePost: () {},
                              onTapSave: InkWell(
                                  onTap: () async {
                                    data['is_saved'] = !data['is_saved'];
                                    controller.mixedObjects[index]['data'] =
                                        data;
                                    controller.mixedObjects.refresh();
                                    await controller.saveUnSavePost(
                                        data["id"], data["is_saved"]);
                                    controller.mixedObjects.refresh();
                                  },
                                  child: !data['is_saved']
                                      ? const Icon(Iconsax.save_2)
                                      : const Icon(Iconsax.save_21,
                                          color: TColors.primary, size: 30)),
                              onTapShare: () {},
                              onTapLikes: () {},
                            ),
                            const Divider(
                              color: const Color.fromARGB(181, 224, 224, 224),
                              height: 1,
                              thickness: 5,
                            ),
                          ],
                        );
                      } else if (type == 'course') {
                        return Container(
                          color: Colors.white,
                          padding:
                              const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                          child: Column(
                            children: [
                              CourseCard(courses: data),
                              const Divider(
                                color: Color.fromRGBO(224, 224, 224, 0.71),
                                height: 5,
                                thickness: 5,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    childCount: controller.mixedObjects.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                      child: Lottie.asset(
                          "assets/images/animations/53207-empty-file.json")),
                ),
        ],
      );
    });
  }
}
