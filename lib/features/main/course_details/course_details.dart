import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../instructor_profile/instructor_profile_page.dart';
import '../ratings_reviews/widgets/rating_progress_indicator.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.export_1)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              /// preview this course
              Container(
                height: 240,
                width: double.infinity,
                color: Colors.blue,
              ),
              SizedBox(height: 12.0),

              /// course details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// course title
                  Text(
                    "100 days of code: The complete python pro bootcamp",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),

                  /// course description
                  Text(
                    "master python by building 100 projects in 100 days learn data science, automation, build websites, games and apps!",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),

                  /// course rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "4.6",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: TColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RatingBarIndicator(
                            rating: 4.6,
                            itemSize: 16,
                            itemBuilder: (_, __) => const Icon(
                              Iconsax.star1,
                              color: TColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "(132 ratings) 459 students",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  /// created by
                  Row(
                    children: [
                      Text("Created by",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const InstructorProfilePage());
                        },
                        child: Text(
                          "Sif Yacine, software engineer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: TColors.primary,
                              fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),

                  /// last update and language
                  Row(
                    children: [
                      Icon(Iconsax.danger),
                      Text(" Last updated 9/2024"),
                    ],
                  ),
                  SizedBox(height: 6.0),

                  Row(
                    children: [
                      Icon(Iconsax.language_square),
                      Text(" Arabic"),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(Iconsax.subtitle),
                      Text(" English, arabic, french"),
                    ],
                  ),
                  SizedBox(height: 12.0),

                  /// price
                  Text(
                    "4300 DA",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                  SizedBox(height: 6.0),

                  /// buy and add to wishlist buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Buy now"),
                    ),
                  ),
                  SizedBox(height: 4.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text("add to wishlist"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    color: isDark ? TColors.dark : TColors.light,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "what will you learn in this course",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the top
                          children: [
                            Icon(Iconsax.tick_circle),
                            SizedBox(width: 12.0),
                            // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                            Expanded(
                              child: Text(
                                "You will master Python programming language by building 100 unique projects over 100 days",
                                style: TextStyle(fontSize: 14.0),
                                // Optional: adjust font size
                                overflow: TextOverflow
                                    .visible, // Ensure text doesn't get clipped
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the top
                          children: [
                            Icon(Iconsax.tick_circle),
                            SizedBox(width: 12.0),
                            // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                            Expanded(
                              child: Text(
                                "You will master Python programming language by building 100 unique projects over 100 days",
                                style: TextStyle(fontSize: 14.0),
                                // Optional: adjust font size
                                overflow: TextOverflow
                                    .visible, // Ensure text doesn't get clipped
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the top
                          children: [
                            Icon(Iconsax.tick_circle),
                            SizedBox(width: 12.0),
                            // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                            Expanded(
                              child: Text(
                                "You will master Python programming language by building 100 unique projects over 100 days",
                                style: TextStyle(fontSize: 14.0),
                                // Optional: adjust font size
                                overflow: TextOverflow
                                    .visible, // Ensure text doesn't get clipped
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the top
                          children: [
                            Icon(Iconsax.tick_circle),
                            SizedBox(width: 12.0),
                            // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                            Expanded(
                              child: Text(
                                "You will master Python programming language by building 100 unique projects over 100 days",
                                style: TextStyle(fontSize: 14.0),
                                // Optional: adjust font size
                                overflow: TextOverflow
                                    .visible, // Ensure text doesn't get clipped
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "show more",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                                fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "students feedback",
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
                  Row(
                    children: [
                      Text(
                        "4.6",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0),
                      ),
                      Text("  course rating"),
                    ],
                  ),
                  TRatingprogressIndicator(text: '70%', value: 0.7, stars: 5),
                  TRatingprogressIndicator(text: '24%', value: 0.24, stars: 4),
                  TRatingprogressIndicator(text: '4%', value: 0.04, stars: 3),
                  TRatingprogressIndicator(text: '1%', value: 0.01, stars: 2),
                  TRatingprogressIndicator(text: '1%', value: 0.01, stars: 1),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    color: isDark ? TColors.black : TColors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("karim"),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: 4.5,
                              itemSize: 16,
                              itemBuilder: (_, __) => const Icon(
                                Iconsax.star1,
                                color: TColors.primary,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text("2 days"),
                          ],
                        ),
                        Text("Was good one i liked the course!!!")
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    color: isDark ? TColors.black : TColors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("karim"),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: 4.5,
                              itemSize: 16,
                              itemBuilder: (_, __) => const Icon(
                                Iconsax.star1,
                                color: TColors.primary,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text("2 days"),
                          ],
                        ),
                        Text("Was good one i liked the course!!!")
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    color: isDark ? TColors.black : TColors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("karim"),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: 4.5,
                              itemSize: 16,
                              itemBuilder: (_, __) => const Icon(
                                Iconsax.star1,
                                color: TColors.primary,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text("2 days", ),
                          ],
                        ),
                        Text("Was good one i liked the course!!!")
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
