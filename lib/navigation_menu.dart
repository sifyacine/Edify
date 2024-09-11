import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/main/account/account_page.dart';
import 'features/main/home_page/home_page.dart';
import 'features/main/notification/notification_page.dart';
import 'features/main/shorts/shorts.dart';
import 'features/main/wishlist/wishlist.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 74,
          backgroundColor: isDark ? TColors.dark : TColors.light,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
            NavigationDestination(icon: Icon(Iconsax.video), label: 'Shorts'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Notification'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Account'),

          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const WishlistScreen(),
    const ShortsScreen(),
    const NotificationsScreen(),
    const AccountScreen(),
  ];
}
