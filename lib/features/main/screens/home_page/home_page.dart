import 'package:edify/features/main/controller/homepage/homepage_controller.dart';
import 'package:edify/features/main/screens/courses/add_course/add_course.dart';
import 'package:edify/features/main/screens/courses/course_details/course_card.dart';
import 'package:edify/features/main/screens/home_page/widgets/add/add.dart';
import 'package:edify/features/main/screens/home_page/widgets/bottom_bar_items.dart';
import 'package:edify/features/main/screens/home_page/widgets/groups/groups.dart';
import 'package:edify/features/main/screens/home_page/widgets/home/home.dart';
import 'package:edify/features/main/screens/home_page/widgets/menu/menu.dart';
import 'package:edify/features/main/screens/menu/my_activities/my_activities.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:edify/features/main/screens/posts/post_comment.dart';

import 'package:edify/features/main/screens/posts/post_widget.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/features/main/screens/shorts/shorts.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const ShortVideo(),
    const Add(),
    const Groups(),
    const Menu(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 64, 197, 102),
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "NotoSansArabic",
        ),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
