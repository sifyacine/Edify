import 'package:edify/features/main/screens/home_page/widgets/course_card.dart';
import 'package:edify/features/main/screens/home_page/widgets/post_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controller/posts/posts_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final userController = Get.find<UserController>();

    // Fetch posts and sort by publishedDate
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.light,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        actions: [
          IconButton(
            onPressed: () {}, // Add functionality here
            icon: const Icon(Iconsax.add),
          ),
          IconButton(
            onPressed: () {}, // Add functionality here
            icon: const Icon(Iconsax.search_normal_1),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => Container());
            }, // Add functionality here
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
      body: Obx(
            () {

          // Sort posts by publishedDate (only once or as needed)

          return ListView(
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
                          backgroundImage: userController.userProfilePicture.value.isEmpty
                              ? const AssetImage("assets/images/content/user.png")
                              : NetworkImage(userController.userProfilePicture.value) as ImageProvider,

                        ),
                        SizedBox(width: 12.0),
                        Text("What's on your mind?"),
                      ],
                    ),
                    Icon(Iconsax.image),
                  ],
                ),
              ),

              /// Posts

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
                          onPressed: () {}, // Add functionality here
                          child: const Text(
                            "view all",
                            style: TextStyle(color: TColors.primary),
                          ),
                        ),
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
            ],
          );
        },
      ),
    );
  }
}
