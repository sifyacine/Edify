import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/controller/homepage/menu/my_courses/my_courses_controller.dart';
import 'package:edify/features/main/screens/courses/course_details/course_purchase/course_purchase.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/loaders/empty_data.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    MyCoursesControllerImp controller = Get.put(MyCoursesControllerImp());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Courses",
            style: TextStyle(fontFamily: "NotoSansArabic"),
          ),
        ),
        body: controller.isLoading.value
            ? Lottie.asset('assets/images/animations/loading2.json')
            : controller.myCourses.isEmpty
                ? const EmptyData(empty: "No Courses")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.myCourses.length,
                    itemBuilder: (BuildContext context, int i) => InkWell(
                        onTap: () {
                          Get.to(() => CoursePurchase(course: []));
                        },
                        child: ListTile(
                          leading: SizedBox(
                            height: 150,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://foundr.com/wp-content/uploads/2023/04/How-to-create-an-online-course.jpg.webp",
                                fit: BoxFit.fill,
                                width: Get.width,
                                placeholder: (context, url) => LottieBuilder.asset(
                                    "assets/images/animations/141397-loading-juggle.json"),
                                errorWidget: (context, url, error) => Lottie.asset(
                                    "assets/images/animations/53207-empty-file.json"),
                              ),
                            ),
                          ),
                          title: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: TColors.primary,
                              ),
                              Expanded(
                                child: ReadMoreText(
                                  "  Java Content",
                                  trimLines:
                                      1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '...Read More',
                                  trimExpandedText: '...Read Less',

                                  moreStyle:
                                      const TextStyle(color: TColors.primary),
                                  lessStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 173, 172, 172)),

                                  style: const TextStyle(
                                      fontFamily: 'NotoSansArabic',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          subtitle: const Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ReadMoreText(
                                      "  Java & Kotlin & Node js",
                                      trimLines:
                                          1, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: ' ',
                                      trimExpandedText: ' ',

                                      moreStyle: const TextStyle(
                                          color: TColors.primary),
                                      lessStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 173, 172, 172)),

                                      style: const TextStyle(
                                          fontFamily: 'NotoSansArabic',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      "  2025/01/31",
                                      style: TextStyle(
                                          fontFamily: "NotoSansArabic",
                                          color: TColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ],
                          ),
                        )

                        /*Column(children: [
                        Row(
                          children: [
                            
                            Column(
                              children: [
                                
                                Row(
                                  children: [
                                    Text(
                                      "Java & Kotlin & Node js",
                                      style: TextStyle(
                                          fontFamily: 'NotoSansArabic',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                
                              ],
                            )
                          ],
                        ),
                        Divider()
                      ]))*/
                        ),
                  ));
  }
}
