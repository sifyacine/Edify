import 'package:edify/features/main/controller/homepage/home/home_courses/home_courses_controller.dart';
import 'package:edify/features/main/controller/homepage/homepage_controller.dart';
import 'package:edify/features/main/screens/posts/post_comment.dart';
import 'package:edify/features/main/screens/posts/post_widget.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeCourses extends StatelessWidget {
  const HomeCourses({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageControllerImp controller = Get.put(HomePageControllerImp());
    return Obx(() => controller.isLoading.value && controller.posts.isEmpty
        ? Center(
            child: Lottie.asset(
                'assets/images/animations/141397-loading-juggle.json'),
          )
        : !controller.isLoading.value && controller.posts.isEmpty
            ? const Center(child: Text('No Content yet'))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: controller.posts.length,
                separatorBuilder: (context, i) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                itemBuilder: (context, i) {
                  controller.currentPostID = controller.posts[i]['id'];
                  controller.index = i;

                  RxInt currentLike = controller.currentLikePost[i].obs;
                  controller.posts[i]['is_liked'] == true
                      ? controller.likePosts[i].value = true
                      : controller.likePosts[i].value = false;
                  DateTime postTime =
                      DateTime.parse(controller.posts[i]['post_time']);
                  var posts = controller.posts[i];

                  return Obx(() => PostView(
                      onTapShare: () {
                        Share.share(
                          'https://education15845d.pythonanywhere.com/admin/login/?next=/admin/',
                          subject:
                              "https://education15845d.pythonanywhere.com/admin/login/?next=/admin/",
                        );
                      },
                      postReport: () async {
                        Get.to(() => const SendReport(), arguments: {
                          "type": "post ${posts['id'].toString()}",
                          "member": controller.posts[i]['member']['id'],
                          "userID": controller.userID,
                        });
                      },
                      onTapSave: InkWell(
                        onTap: () async {
                          await controller.savePost(
                              i, posts['id'], controller.userID);
                        },
                        child: Icon(
                          controller.isSavePost[i].value == true
                              ? Icons.save
                              : Icons.save_outlined,
                          color: controller.isSavePost[i].value == true
                              ? const Color.fromRGBO(146, 227, 169, 1)
                              : Colors.black,
                        ),
                      ),
                      memberPic:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd_XRGE9j0tQkvkYFKQU5MlZw86IXuV9TbfA&s",
                      memberFullName: posts['member']['full_name'],
                      postTime: "${timeago.format(postTime, locale: 'en')}   ",
                      postTitle: posts['post_title'],
                      likesNumber: controller.formatNumber(currentLike.value),
                      commentsNumber:
                          controller.formatNumber(posts['post_comments']),
                      likeWidget: LikeButton(
                        animationDuration: const Duration(seconds: 2),
                        bubblesSize: 10,
                        circleColor: const CircleColor(
                            start: TColors.primary, end: Colors.red),
                        isLiked: controller.likePosts[i].value,
                        onTap: (val) async {
                          if (controller.likePosts[i].value) {
                            currentLike.value = currentLike.value - 1;
                            controller.currentLikePost[i] = currentLike.value;
                            posts['is_liked'] = false;
                          } else {
                            currentLike.value = currentLike.value + 1;

                            controller.currentLikePost[i] = currentLike.value;
                            posts['is_liked'] = true;
                          }
                          return await controller.likeDislikePost(
                              posts['id'], i);
                        },
                      ),
                      images: posts['images'],
                      onTapLikes: () async {
                        controller.box.write('post_id', posts['id']);
                        //Get.to(() => const ShowLikesPost());
                      },
                      viewCommentsOntap: InkWell(
                          onTap: () async {
                            Get.to(() => const PostCommentView(), arguments: {
                              "commentNumber": posts['post_comments'],
                              "postID": posts['id'],
                              'userID': controller.userID
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.comment_outlined),
                              Text('  Comments')
                            ],
                          )),
                      onTapComment: () async {
                        Get.to(() => const PostCommentView(), arguments: {
                          "commentNumber": posts['post_comments'],
                          "postID": posts['id'],
                          'userID': controller.userID
                        });
                      }));
                }));
  }
}
