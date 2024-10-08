import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/tiles/custom_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/user_controller.dart';
import '../edit_profile/edit_page.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final userController = Get.find<UserController>();
    final controller = AuthenticationRepository.instance;
    return Scaffold(
      backgroundColor: isDark ? TColors.black : TColors.light,
      appBar: AppBar(
        backgroundColor: isDark ? TColors.black : TColors.white,
        centerTitle: true,
        title: const Text("Account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: isDark ? TColors.black : TColors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage("assets/images/content/user.png"),
                  ),

                  const SizedBox(height: 8),
                  // Add some space between avatar and name
                  Text(
                    "${userController.userUsername.value}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge, // Adjust styling
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "@${userController.userUsername.value}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16.0),
                  ),
                  // Space between name and email
                  const SizedBox(height: 8),
                  // Space between name and email
                  Center(
                    // Center the row
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // Shrinks the row width to content
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.document),
                        SizedBox(width: 8), // Add space between icon and email
                        Text("${userController.userEmail.value}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Space before button
                  TextButton(
                    onPressed: () {},
                    child: userController.userIsInstructor.value
                        ? Text("Switch to instructor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: TColors.primary))
                        : Text("Become an instructor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: TColors.primary)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Video prefrences"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: isDark ? TColors.black : TColors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CustomTile(title: 'Download options'),
                      CustomTile(title: 'vidoe playback options'),
                      CustomTile(title: 'Your downloaded courses'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Account settings"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: isDark ? TColors.black : TColors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CustomTile(
                          title: 'Edit information',
                          onTap: () {
                            Get.to(() => const EditProfileScreen());
                          }),
                      CustomTile(title: 'Career goal'),
                      CustomTile(title: 'learning reminders'),
                      CustomTile(title: 'Account security'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("app Settings"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: isDark ? TColors.black : TColors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CustomTile(title: 'notification'),
                      CustomTile(title: 'language'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Support"),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: isDark ? TColors.black : TColors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CustomTile(title: 'About Edify'),
                      CustomTile(title: 'About Edify Business'),
                      CustomTile(title: 'Help and support'),
                      CustomTile(title: 'Share the Edify app'),
                      CustomTile(title: 'app version: '),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      controller.logout();
                    },
                    child: Text("Sign out",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: TColors.primary)),
                  ),
                  Text("Edify v1.0.0"),
                  const SizedBox(height: 16), // Space before button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
