import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/controller/homepage/menu/my_activities/courses/courses_activities_contoller.dart';
import 'package:edify/features/main/screens/courses/add_course/add_course.dart';
import 'package:edify/features/main/screens/courses/edit_course/edit_course.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class MyCoursesActivities extends StatelessWidget {
  final int userID;
  int? courseID;

  MyCoursesActivities({super.key, required this.userID, this.courseID});

  @override
  Widget build(BuildContext context) {
    CoursesActivitiesControllerImp controller =
        Get.put(CoursesActivitiesControllerImp(userID));
    return Obx(() => controller.isLoading.value
        ? Center(
            child: Lottie.asset("assets/images/animations/loading2.json"),
          )
        : controller.courses.isEmpty
            ? Column(
                children: [
                  Center(
                    child: Lottie.asset(
                        "assets/images/animations/53207-empty-file.json"),
                  ),
                  InkWell(
                      onTap: () async {
                        Get.to(() => AddCourse(
                              userID: userID,
                              courseID: 1,
                            ));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Courses, "),
                          Text(
                            "Add from Here",
                            style: TextStyle(
                                decorationStyle: TextDecorationStyle.dotted,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                fontFamily: "NotoSansArabic",
                                fontWeight: FontWeight.bold,
                                color: TColors.primary),
                          ),
                        ],
                      ))
                ],
              )
            : ListView.builder(
                itemCount: controller.courses.length,
                itemBuilder: (BuildContext context, int i) {
                  var courses = controller.courses;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Course ${i + 1}",
                              style: const TextStyle(
                                  fontFamily: "Rowdies", fontSize: 20),
                            ),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                courses[i]['course_title'],
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontFamily: "NotoSansArabic"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 200,
                          width: Get.width,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(() => EditCourse(
                                        userID: userID,
                                        courseID: courses[i]["id"],
                                      ));
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://education15845d.pythonanywhere.com${courses[i]["course_thumbnail"]}",
                                  fit: BoxFit.fill,
                                  width: Get.width,
                                  placeholder: (context, url) =>
                                      LottieBuilder.asset(
                                          "assets/images/animations/141397-loading-juggle.json"),
                                  errorWidget: (context, url, error) =>
                                      Lottie.asset(
                                          "assets/images/animations/53207-empty-file.json"),
                                ),
                              ),
                              Positioned(
                                  right: 20,
                                  top: 20,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                    child: IconButton(
                                      onPressed: () async {
                                        await controller.deleteCourse(
                                            courses[i]["id"], i);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  right: 20,
                                  bottom: 20,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () async {
                                        Get.to(() => EditCourse(
                                              userID: userID,
                                              courseID: courses[i]['id'],
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const Divider()
                    ],
                  );
                }));
  }
}
