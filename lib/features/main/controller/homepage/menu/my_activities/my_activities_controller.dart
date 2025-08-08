import 'package:edify/features/main/screens/menu/my_activities/my_courses/my_courses_activities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class MyActivitiesController extends GetxController {}

class MyActivityControllerImp extends MyActivitiesController {
  MyActivityControllerImp(this.userType);

  String userType;

  int userID = 1;
  late List<Widget> tabs;
  late List<Widget> tabsView;

  @override
  void onInit() {
    tabs = [
      if (userType == "teacher")
        const Row(
          children: [Icon(Icons.book), Text(" Courses")],
        ),
      const Row(
        children: [
          Icon(Icons.post_add),
          Text(" Posts"),
        ],
      ),
      const Row(
        children: [Icon(Icons.play_circle_fill), Text(" Shorts")],
      )
    ];
    tabsView = [
      if (userType == "teacher")
        MyCoursesActivities(
          userID: userID,
        ),
      Container(),
      Container(),
    ];
    super.onInit();
  }
}
