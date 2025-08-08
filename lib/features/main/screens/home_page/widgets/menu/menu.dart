import 'package:edify/features/main/screens/menu/my_activities/my_activities.dart';
import 'package:edify/features/main/screens/menu/my_courses/my_courses.dart';
import 'package:edify/features/personalization/screens/instructor_profile/instructor_profile_page.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // profile
        ListTile(
          onTap: () {
            Get.to(() => const InstructorProfilePage());
          },
          leading: const Icon(Icons.person),
          title: const Text("Profile"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        // my activities
        ListTile(
          onTap: () {
            Get.to(() => const MyActivities(userType: "teacher"));
          },
          leading: const Icon(Icons.access_time_outlined),
          title: const Text("Activity Center"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Get.to(() => const MyCourses());
          },
          leading: const Icon(Icons.video_collection),
          title: const Text("My Courses"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        // settings
        ListTile(
          onTap: () {
            Get.to(() => const MyCourses());
          },
          leading: const Icon(Icons.settings_outlined),
          title: const Text("Settings"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        // sent a report
        ListTile(
          onTap: () {
            Get.to(() => const MyCourses());
          },
          leading: const Icon(Icons.flag),
          title: const Text("Report a problem"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        // support
        ListTile(
          onTap: () {
            Get.to(() => const MyCourses());
          },
          leading: const Icon(Icons.messenger_outline_sharp),
          title: const Text("Support"),
          trailing: const Icon(
            Icons.chevron_right_sharp,
            color: TColors.primary,
          ),
        ),
        const Divider(),
        // sign out
        ListTile(
          onTap: () {
            Get.to(() => const MyCourses());
          },
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: const Text("Log out"),
          trailing: const Icon(Icons.chevron_right_sharp, color: Colors.red),
        ),
      ],
    );
  }
}
