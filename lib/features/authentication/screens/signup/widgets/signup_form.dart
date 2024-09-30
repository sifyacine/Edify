import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controller/signup/signup_controller.dart';
import '../widgets/terms_and_conditions.dart'; // Update the import path

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.find<SignUpController>(); // Use Get.find() to get the controller

    return Form(
      key: signUpController.signUpFormKey,
      child: Column(
        children: [
          // Username
          TextFormField(
            controller: signUpController.username,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            validator: (value) => value!.isEmpty ? 'Username is required' : null,
          ),
          const SizedBox(height: 16.0),

          // Email
          TextFormField(
            controller: signUpController.email,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct),
            ),
            validator: (value) => value!.isEmpty || !GetUtils.isEmail(value) ? 'Valid email is required' : null,
          ),
          const SizedBox(height: 16.0),

          // Password
          TextFormField(
            controller: signUpController.password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
            validator: (value) => value!.isEmpty ? 'Password is required' : null,
          ),
          const SizedBox(height: 16.0),

          // Terms and Conditions
          Obx(() => TermsAndConditions(
            isAgreed: signUpController.termsAndConditions.value,
            onChanged: (value) {
              signUpController.termsAndConditions.value = value ?? false;
            },
          )),

          // Sign Up Button
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: signUpController.signUp,
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
