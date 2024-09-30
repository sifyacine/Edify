import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'features/main/screens/home_page/home_page.dart';
import 'features/main/screens/shorts/shorts.dart';
import 'features/main/screens/wishlist/wishlist.dart';
import 'features/personalization/screens/account/account_page.dart';
import 'features/personalization/screens/notification/notification_page.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? TColors.dark : TColors.light,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
          showSelectedLabels: false,
          // Hides the label for selected item
          showUnselectedLabels: false,
          // Hides the label for unselected items
          selectedItemColor: TColors.primary,
          // Changes the color of selected item
          unselectedItemColor: isDark ? Colors.white : Colors.grey,
          // Color for unselected items
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.heart),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.video),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.notification),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user),
              label: '', // No label
            ),
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
    ShortsPage(),
    const NotificationsScreen(),
    const AccountScreen(),
  ];
}
