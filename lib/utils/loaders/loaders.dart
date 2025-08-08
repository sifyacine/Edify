import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message, required duration}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: duration,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: THelperFunctions.isDarkMode(Get.context!)
                ? TColors.darkGrey.withOpacity(0.9)
                : TColors.grey.withOpacity(0.9),
          ),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: TColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: TColors.white));
  }

  static warningSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.yellow,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white));
  }

  static errorSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white));
  }

  // success dialog
  static successDialog(String message) {
    Get.dialog(Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: TColors.primary,
            size: 64,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "TiltNeon", fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'cancel',
                style: TextStyle(color: TColors.primary, fontSize: 16),
              ))
        ],
      ),
    ));
  }

  // error dialog
  static errorDialog(String message) {
    Get.dialog(Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 64,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: "TiltNeon", fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                print(message);
                Get.back();
              },
              child: const Text(
                'cancel',
                style: TextStyle(
                    color: Colors.red, fontFamily: "TiltNeon", fontSize: 16),
              ))
        ],
      ),
    ));
  }
}
