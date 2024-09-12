import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controller/login/login_controller.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm

  ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey, // Ensure this key is unique
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email or Username TextField
            TextFormField(
              controller: controller.emailOrUsername,
              validator: (value) =>
                  TValidator.validateEmptyText(TTexts.email, value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Password TextField with Obx to handle visibility toggle
            Obx(
                  () =>
                  TextFormField(
                    controller: controller.password,
                    validator: (value) =>
                        TValidator.validateEmptyText(TTexts.password, value),
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                        ),
                        onPressed: () {
                          controller.hidePassword.value =
                          !controller.hidePassword.value;
                        },
                      ),
                      labelText: TTexts.password,
                    ),
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // Remember me and Forgot Password row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me Checkbox
                  Row(
                    children: [
                      Obx(
                            () =>
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value =
                                !controller.rememberMe.value;
                              },
                            ),
                      ),
                      const Text(TTexts.rememberMe),
                    ],
                  ),

                  // Forgot Password Button
                  TextButton(
                    onPressed: () => Get.to(() => Container()),
                    // Add your ForgotPassword screen
                    child: const Text(
                      TTexts.forgetPassword,
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwSections),

            // Sign In and Create Account Buttons
            Column(
              children: [
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.emailOrUsernameAndPasswordSignIn(),
                    child: const Text(TTexts.signIn),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Adjusted space
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => SignUpScreen()),
                      // Add your CreateAccount screen
                      child: const Text(TTexts.createAccount),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}