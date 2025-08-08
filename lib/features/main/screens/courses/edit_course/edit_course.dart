import 'package:edify/features/main/controller/courses/course_edit_controller.dart/edit_course_controller.dart';
import 'package:edify/features/main/controller/courses/course_edit_controller.dart/course_update_controller.dart';
import 'package:edify/features/main/screens/courses/add_course/add_a_lesson.dart';
import 'package:edify/features/main/screens/courses/course_details/teacher_view/course_details_creater.dart';

import 'package:edify/features/main/screens/courses/edit_course/widgets/drop_down_price.dart';
import 'package:edify/features/main/screens/videos/show_list_videos.dart';

import 'package:edify/features/main/screens/videos/video_view.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EditCourse extends StatefulWidget {
  final int userID;
  final int courseID;

  const EditCourse({super.key, required this.userID, required this.courseID});

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    EditCourseControllerImp controller =
        Get.put(EditCourseControllerImp(widget.courseID));
    CourseUpdateControllerImp courseUpdateControllerImp =
        Get.put(CourseUpdateControllerImp(widget.userID));

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Course"),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => AddALesson(
                          courseID: widget.courseID,
                          userID: widget.userID,
                        ));
                  },
                  icon: const Icon(
                    Icons.add_box_outlined,
                    size: 32,
                  ))
            ],
            bottom: const TabBar(
              labelColor: Colors.green,
              dividerColor: TColors.primary,
              indicatorColor: TColors.primary,
              tabs: [
                Row(
                  children: [
                    Tab(icon: Icon(Icons.edit_document)),
                    Text(
                      " Edit course",
                      style: TextStyle(fontFamily: "NotoSansArabic"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Tab(icon: Icon(Icons.video_file)),
                    Text(
                      " Edit lessons",
                      style: TextStyle(fontFamily: "NotoSansArabic"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Obx(() => TabBarView(
                children: [
                  controller.isLoading.value
                      ? Lottie.asset('assets/images/animations/loading2.json')
                      : controller.course.isNotEmpty
                          ? Obx(() {
                              return CourseDetailsCreaterView(
                                userID: widget.userID,
                                courseDetails: controller.getCourceDetails()!,
                                // change price
                                dropDownMenu: DropDownPrice(
                                  controller: courseUpdateControllerImp,
                                  selectedItem: controller.selectedItem,
                                  prices: controller.prices,
                                ),

                                // for updated ui
                                introChanged: controller.introChanged,
                                newIntro: controller.newVideoIntro,
                                thumbnailChanged: controller.thumbnailChanged,
                                newThumbnail: controller.thumbnail,
                                // choose video
                                changeVideoIntro: () async {
                                  if (!controller.isChoosePicker.value) {
                                    await controller.chooseVideoIntro();
                                  }
                                  setState(() {});
                                },

                                // choose video and thumbnail

                                changeThumbnail: () async {
                                  if (!controller.isChoosePicker.value) {
                                    await controller.chooseThumbnail();
                                  }
                                  setState(() {});
                                },
                                // new data
                                editName: controller.newSubjectController,
                                editTitle: controller.newTitleController,
                                editDesc: controller.newDescController,
                              );
                            })
                          : const Text('No Data'),
                  Obx(() => controller.isLoading.value
                      ? Lottie.asset(
                          "assets/images/animations/141397-loading-juggle.json")
                      : ShowListVideos(
                          userID: widget.userID,
                          courseID: widget.courseID,
                          videos: controller.videos))
                ],
              )),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
