import 'package:edify/features/main/home_page/widgets/course_card.dart';
import 'package:edify/features/main/home_page/widgets/post_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/controllers/user_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.light,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: TColors.grey,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Iconsax.document),
                                      SizedBox(width: 8),
                                      Text("Post"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: TColors.grey,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Iconsax.document),
                                      SizedBox(width: 8),
                                      Text("Live"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: TColors.grey,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Iconsax.document),
                                      SizedBox(width: 8),
                                      Text("Short"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: TColors.grey,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Iconsax.document),
                                      SizedBox(width: 8),
                                      Text("Course"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Iconsax.add),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.search_normal_1),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.message),
          ),
        ],
        title: GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
              () => Text(
                  "Welcome, ${userController.userLastName.value + " " + userController.userFirstName.value}",
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
        children: [
          /// Create post field
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: isDark ? Colors.black : Colors.white,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: userController.userProfilePicture.value.isNotEmpty
                          ? NetworkImage(userController.userProfilePicture.value)
                          : AssetImage("assets/images/content/user.png") as ImageProvider,
                    ),
                    SizedBox(width: 12.0),
                    Text("What's in your mind?"),
                  ],
                ),
                Icon(Iconsax.image),
              ],
            ),
          ),

          /// Posts
          const PostContainer(
            shares: 3,
            profileImage: 'assets/images/content/user.png',
            userName: 'Sif Yacine',
            date: '1d',
            postDetails:
            "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase...",
            postImage: 'assets/images/content/post_image.png',
            likes: 12,
            comments: 5,
          ),
          const PostContainer(
            shares: 3,
            profileImage: 'assets/images/content/user.png',
            userName: 'Sif Yacine',
            date: '1d',
            postDetails:
            "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase...",
            postImage: 'assets/images/content/post_image.png',
            likes: 12,
            comments: 5,
          ),

          /// Suggested courses
          Container(
            color: isDark ? Colors.black : Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top courses in Development",
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "view all",
                          style: TextStyle(color: TColors.primary),
                        )),
                  ],
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CourseCard(
                          thumbnail: 'assets/images/content/post_image.png',
                          title: 'Learn Flutter fast',
                          instructor: 'Sif Yacine',
                          price: 4200,
                          promo: 10,
                          rating: 4.8,
                          rateNum: 15),
                      SizedBox(width: 12.0),
                      CourseCard(
                          thumbnail: 'assets/images/content/java_course.png',
                          title: 'Python for Beginners',
                          instructor: 'Karim',
                          price: 3800,
                          promo: 10,
                          rating: 3.5,
                          rateNum: 27),
                      SizedBox(width: 12.0),
                      CourseCard(
                          thumbnail: 'assets/images/content/python_course.png',
                          title: 'Your Guide for Java',
                          instructor: 'Othman',
                          price: 6800,
                          promo: 10,
                          rating: 2.5,
                          rateNum: 16),
                      SizedBox(width: 12.0),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// More posts
          const PostContainer(
            profileImage: 'assets/images/content/user.png',
            userName: 'Sif Yacine',
            date: '1d',
            postDetails:
            "Flutter is an open-source UI software development toolkit created by Google...",
            postImage: 'assets/images/content/post_image.png',
            likes: 12,
            comments: 5,
            shares: 3,
          ),
          const PostContainer(
            profileImage: 'assets/images/content/user.png',
            userName: 'Sif Yacine',
            date: '1d',
            postDetails:
            "Flutter is an open-source UI software development toolkit created by Google...",
            postImage: 'assets/images/content/post_image.png',
            likes: 12,
            comments: 5,
            shares: 3,
          ),
        ],
      ),
    );
  }
}
