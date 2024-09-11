import 'package:edify/features/main/home_page/widgets/course_card.dart';
import 'package:edify/features/main/home_page/widgets/post_container.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Iconsax.document),
                                  Text("post"),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Iconsax.document),
                                Text("post"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.document),
                                Text("post"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Iconsax.document),
                                Text("post"),
                              ],
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, Yacine Sif",
                style: TextStyle(fontSize: 16.0),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              /// create post Field
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: isDark ? Colors.black : Colors.white,
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/content/user.png"),
                        ),
                        SizedBox(width: 12.0),
                        Text("What's in your mind?"),
                      ],
                    ),
                    Icon(Iconsax.image),
                  ],
                ),
              ),

              /// Post
              const PostContainer(
                shares: 3,
                profileImage: 'assets/images/content/user.png',
                userName: 'Sif Yacine',
                date: '1d',
                postDetails:
                    "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase. Key features of Flutter include: Widgets: Flutter uses a rich set of pre-designed widgets that allow developers to create complex UIs easily...",
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
                    "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase. Key features of Flutter include: Widgets: Flutter uses a rich set of pre-designed widgets that allow developers to create complex UIs easily...",
                postImage: 'assets/images/content/post_image.png',
                likes: 12,
                comments: 5,
              ),

              /// suggested courses
              Container(
                color: isDark ? Colors.black : Colors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      // Enable horizontal scrolling

                      child: Row(
                        children: [
                          CourseCard(
                              thumbnail: 'assets/images/content/post_image.png',
                              title: 'learn flutter fast',
                              instructor: 'Sif Yacine',
                              price: 4200,
                              promo: 10,
                              rating: 4.8,
                              rateNum: 15),
                          SizedBox(width: 12.0),
                          CourseCard(
                              thumbnail:
                                  'assets/images/content/java_course.png',
                              title: 'python for beginners',
                              instructor: 'Karim',
                              price: 3800,
                              promo: 10,
                              rating: 3.5,
                              rateNum: 27),
                          SizedBox(width: 12.0),
                          CourseCard(
                              thumbnail:
                                  'assets/images/content/python_course.png',
                              title: 'your guid for java',
                              instructor: 'Othman ',
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
              const PostContainer(
                profileImage: 'assets/images/content/user.png',
                userName: 'Sif Yacine',
                date: '1d',
                postDetails:
                    "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase. Key features of Flutter include: Widgets: Flutter uses a rich set of pre-designed widgets that allow developers to create complex UIs easily...",
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
                    "Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase. Key features of Flutter include: Widgets: Flutter uses a rich set of pre-designed widgets that allow developers to create complex UIs easily...",
                postImage: 'assets/images/content/post_image.png',
                likes: 12,
                comments: 5,
                shares: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
