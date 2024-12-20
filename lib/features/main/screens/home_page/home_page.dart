import 'package:edify/features/main/controller/homepage/homepage_controller.dart';
import 'package:edify/features/main/screens/posts/post_comment.dart';

import 'package:edify/features/main/screens/posts/post_widget.dart';
import 'package:edify/features/main/screens/report/report.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final userController = Get.find<UserController>();

    // Fetch posts and sort by publishedDate
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    HomePageControllerImp controller = Get.put(HomePageControllerImp());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : TColors.light,
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                'https://education15845d.pythonanywhere.com/admin/login/?next=/admin/',
                subject:
                    "https://education15845d.pythonanywhere.com/admin/login/?next=/admin/",
              );
            }, // Add functionality here
            icon: const Icon(Iconsax.add),
          ),
          IconButton(
            onPressed: () {}, // Add functionality here
            icon: const Icon(Iconsax.search_normal_1),
          ),
          IconButton(
            onPressed: () {}, // Add functionality here
            icon: const Icon(Iconsax.message),
          ),
        ],
        title: GestureDetector(
          onTap: () {}, // Add functionality here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "Welcome, ${userController.userUsername.value}",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 2.0),
              Text(
                "Edit goal",
                style: TextStyle(color: TColors.primary, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: userController
                            .userProfilePicture.value.isEmpty
                        ? const AssetImage("assets/images/content/user.png")
                        : NetworkImage(userController.userProfilePicture.value)
                            as ImageProvider,
                  ),
                  const SizedBox(width: 12.0),
                  const Text("What's on your mind?"),
                ],
              ),
              Icon(Iconsax.image),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          // Sort posts by publishedDate (only once or as needed)
          Obx(() => controller.isLoading.value && controller.posts.isEmpty
              ? Center(
                  child: Lottie.asset(
                      'assets/images/animations/141397-loading-juggle.json'),
                )
              : !controller.isLoading.value && controller.posts.isEmpty
                  ? const Center(child: Text('No Content yet'))
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
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
                            postTime:
                                "${timeago.format(postTime, locale: 'en')}   ",
                            postTitle: posts['post_title'],
                            likesNumber:
                                controller.formatNumber(currentLike.value),
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
                                  controller.currentLikePost[i] =
                                      currentLike.value;
                                  posts['is_liked'] = false;
                                } else {
                                  currentLike.value = currentLike.value + 1;

                                  controller.currentLikePost[i] =
                                      currentLike.value;
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
                                  Get.to(() => const PostCommentView(),
                                      arguments: {
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
                      }))
        ],
      ),

      /// Posts

      /// Suggested courses
    );
  }
}
