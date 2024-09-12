import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controller/onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getAppBarHeight(), right:TSizes.defaultSpace ,child: TextButton(onPressed: () => OnBoardingController.instance.skipPage(), child: const Text('skip', style: TextStyle(color: TColors.primary),),));
  }
}