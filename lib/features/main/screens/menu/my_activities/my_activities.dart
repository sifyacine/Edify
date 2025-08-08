import 'package:edify/features/main/controller/homepage/menu/my_activities/my_activities_controller.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyActivities extends StatelessWidget {
  final String userType;
  const MyActivities({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    MyActivityControllerImp controller =
        Get.put(MyActivityControllerImp(userType));
    return DefaultTabController(
        length: controller.tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "My Activities",
              style: TextStyle(fontFamily: "NotoSansArabic"),
            ),
            bottom: TabBar(
                labelColor: Colors.green,
                dividerColor: TColors.primary,
                indicatorColor: TColors.primary,
                tabs: controller.tabs),
          ),
          body: TabBarView(children: controller.tabsView),
        ));
  }
}
