import 'package:edify/features/main/controller/posts/post_comment_controller.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/features/main/screens/shorts/widgets/comments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/colors.dart';

class PostCommentView extends StatelessWidget {
  const PostCommentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PostCommentControllerImp controller = Get.put(PostCommentControllerImp());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Commnets'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: controller.comments.isEmpty && controller.isLoading.value
                    ? Center(
                        child: Lottie.asset(
                            'assets/images/animations/141397-loading-juggle.json'),
                      )
                    : controller.comments.isEmpty && !controller.isLoading.value
                        ? const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.comments_disabled,
                                  size: 60,
                                ),
                                Text('  No Comments'),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.comments.length +
                                (controller.isLoading.value ? 1 : 0),
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              if (i == controller.comments.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Lottie.asset(
                                        'assets/images/animations/141397-loading-juggle.json',
                                        width: 200,
                                        height: 80),
                                  ),
                                );
                              }
                              RxInt currentLike =
                                  controller.currentLikeComment[i].obs;
                              DateTime commentTime = DateTime.parse(
                                  controller.comments[i]['created_at']);
                              controller.comments[i]['is_liked'] == true
                                  ? controller.likeCommentsPost[i].value = true
                                  : controller.likeCommentsPost[i].value =
                                      false;

                              return Obx(() => ViewComments(
                                    commentReport: () async {
                                      Get.to(() => const SendReport(),
                                          arguments: {
                                            "type":
                                                "comment post ${controller.comments[i]['id'].toString()}",
                                            "member": controller.comments[i]
                                                ['member']['id'],
                                            "userID": controller.userID,
                                          });
                                    },
                                    commentTime: commentTime,
                                    showReply: controller.showRepliesList[i],
                                    commentsNumber: controller
                                        .formatNumber(controller.commentNumber),
                                    memberPic: 'assets/logos/google-icon.png',
                                    memberFullName: controller.comments[i]
                                        ['member']['full_name'],
                                    content: controller.comments[i]['content'],
                                    commentLike: LikeButton(
                                      size: 20,
                                      isLiked:
                                          controller.likeCommentsPost[i].value,
                                      onTap: (val) async {
                                        if (controller
                                            .likeCommentsPost[i].value) {
                                          currentLike.value =
                                              currentLike.value - 1;
                                          controller.currentLikeComment[i] =
                                              currentLike.value;
                                          controller.comments[i]['is_liked'] =
                                              false;
                                        } else {
                                          currentLike.value =
                                              currentLike.value + 1;

                                          controller.currentLikeComment[i] =
                                              currentLike.value;
                                          controller.comments[i]['is_liked'] =
                                              true;
                                        }

                                        return await controller
                                            .likeDislikePostComment(
                                                controller.comments[i]['id'],
                                                i,
                                                controller.userID);
                                      },
                                    ),
                                    commentlike: currentLike.value.toString(),
                                    repliesNumber: controller
                                        .comments[i]['replies'].length,
                                    repley: () async {
                                      controller.box.write("commentIndex", i);
                                      controller.addRepleyCommentPost(
                                          controller.comments[i]['member']
                                              ['full_name'],
                                          controller.postID,
                                          controller.comments[i]['id'],
                                          controller.userID);
                                    },
                                    showRepliesList: controller.showRepliesList,
                                    i: i,
                                    replies: controller.comments[i]['replies'],
                                  ));
                            }),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd_XRGE9j0tQkvkYFKQU5MlZw86IXuV9TbfA&s"),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: " Add a comment ...",
                              hintStyle: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                              border: InputBorder.none, // إزالة الحدود الأساسية
                              enabledBorder:
                                  InputBorder.none, // إزالة الحدود عند التفعيل
                              focusedBorder: InputBorder.none,
                            ),
                            controller: controller.newComment,
                          ),
                        )),
                        controller.isAddingCommnet.value
                            ? const CircularProgressIndicator(
                                color: TColors.primary,
                              )
                            : InkWell(
                                onTap: () async {
                                  await controller.addComment(controller.postID,
                                      null, controller.userID);
                                },
                                child: const Icon(Icons.send))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
