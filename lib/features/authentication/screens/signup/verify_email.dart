
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/success_screen/success_acreen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controller/signup/signup_controller.dart';
import '../signin/signin_screen.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String? email; // Allow email to be nullable

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.find<SignUpController>(); // Use Get.find() to get the controller

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // image
              Image(
                width: THelperFunctions.screenWidth() * 0.6,
                image: const AssetImage(
                  TImages.deliveredEmailIllustration,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections,),

              // title and subtitle
              Text(
                TTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems,),

              // Show email only if it's not null or empty
              if (email != null && email!.isNotEmpty)
                Text(
                  email!,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: TSizes.spaceBtwItems,),

              Text(
                TTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections,),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => SuccessScreen(
                      image: TImages.staticSuccessIllustration,
                      title: TTexts.yourAccountCreatedTitle,
                      subtitle: 'We have sent you an email to ${email ?? 'your registered email address'}',
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ));
                  },
                  child: const Text(
                    TTexts.tContinue,
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems,),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Logic for resending the email
                    signUpController.resendVerificationEmail();
                  },
                  child: const Text(
                    TTexts.resendEmail,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
