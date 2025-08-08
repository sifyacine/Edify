import 'package:better_player/better_player.dart';
import 'package:edify/features/main/controller/courses/course_details_controller.dart/course_details_controller.dart';
import 'package:edify/features/main/models/course/courseDetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../personalization/screens/instructor_profile/instructor_profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class CourseDetailsView extends StatelessWidget {
  final CourseDetails courseDetails;
  const CourseDetailsView({
    super.key,
    required this.courseDetails,
  });

  @override
  Widget build(BuildContext context) {
    CourseDetailsControllerImp controller =
        Get.put(CourseDetailsControllerImp(courseDetails.videoUrl));
    DateTime courseTime = DateTime.parse(courseDetails.createAt);
    String courseTimeFormate = DateFormat('yyyy-MM-dd').format(courseTime);
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child:
                  BetterPlayer(controller: controller.betterPlayerController),
            ),
            Column(
              children: [
                /// preview this course

                const SizedBox(
                  height: 20,
                ),

                /// course details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // course name
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 187, 187, 187),
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "  ${courseDetails.courseName}  ",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "NotoSansArabic"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      /// course title
                      Text(
                        courseDetails.courseTitle,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Rowdies',
                        ),
                      ),

                      /// course description
                      ReadMoreText(
                        courseDetails.courseDesc,
                        trimLines: 2, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...Read More',
                        trimExpandedText: '...Read Less',

                        moreStyle: const TextStyle(color: TColors.primary),
                        lessStyle: const TextStyle(
                            color: Color.fromARGB(255, 173, 172, 172)),
                        style: const TextStyle(
                            fontFamily: 'NotoSansArabic',
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0),
                      ),

                      const SizedBox(height: 8.0),

                      /// course rating
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                courseDetails.courseRating.toString(),
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
                            "(${courseDetails.courseRating.toString()} ratings)",
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
                          const Text("Created by",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const InstructorProfilePage());
                            },
                            child: Text(
                              courseDetails.createBy,
                              style: const TextStyle(
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
                          const Icon(Iconsax.danger),
                          Text(
                              " $courseTimeFormate (${timeago.format(courseTime)}) "),
                        ],
                      ),

                      const SizedBox(height: 20.0),

                      /// price
                      Text(
                        "${courseDetails.coursePrice.toString()} DA",
                        style: const TextStyle(
                            fontFamily: 'Rowdies',
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
                      ),
                      const SizedBox(height: 6.0),

                      /// buy and add to wishlist buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Buy now",
                            style: TextStyle(fontFamily: 'NotoSansArabic'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark ? TColors.dark : TColors.light,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "What will you learn in this course",
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: 'Rowdies'),
                            ),
                            const SizedBox(height: 12.0),
                            ...List.generate(
                              courseDetails.benefits.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // Align items to the top
                                  children: [
                                    const Icon(Iconsax.tick_circle),
                                    const SizedBox(width: 12.0),
                                    // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                                    Expanded(
                                      child: Text(
                                        courseDetails.benefits[index]
                                            ['course_benefit'],
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'NotoSansArabic'),
                                        // Optional: adjust font size
                                        overflow: TextOverflow
                                            .visible, // Ensure text doesn't get clipped
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "students feedback",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontFamily: "Rowdies", fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      ...List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          color: isDark ? TColors.black : TColors.white,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    child: Image.asset(
                                        'assets/logos/linkedIn_logo.jpg'),
                                  ),
                                  const Text("karim"),
                                ],
                              ),
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
                                  const SizedBox(width: 10.0),
                                  const Text("2 days"),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Was good one i liked the course!!!")
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
