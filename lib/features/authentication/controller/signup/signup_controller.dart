import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../screens/signup/verify_email.dart';

class SignUpController extends GetxController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final termsAndConditions = false.obs;
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) {
      TLoaders.errorSnackBar(title: 'Validation Error', message: 'Please fill in all fields correctly.');
      return;
    }

    if (!termsAndConditions.value) {
      TLoaders.warningSnackBar(
        title: 'Terms and Conditions',
        message: 'You must agree to the terms and conditions to complete the sign-up.',
      );
      return;
    }

    try {
      TFullScreenLoader.openLoadingDialog("Signing you up...", "assets/images/animations/loader-animation.json");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      final signUpData = {
        'first_name': firstName.text.trim(),
        'last_name': lastName.text.trim(),
        'username': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
      };

      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      // Sign up the user
      final response = await dio.post(
        'http://127.0.0.1:8000/authentication/register/', // Adjust URL if needed
        data: signUpData,
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 201) {
        // User created successfully, now create the member record
        final userId = response.data['id']; // Assuming the user ID is returned

        final memberData = {
          'user_id': userId,
          'profile_picture': '', // Optionally handle file uploads or defaults
          'about_me': '',
          'is_instructor': false,
          'num_followers': 0,
          'num_reviews': 0,
          'num_courses': 0,
          'general_rating': 0.0,
        };

        final memberResponse = await dio.post(
          'http://127.0.0.1:8000/member/create_member/', // Adjust URL if needed
          data: memberData,
          options: Options(validateStatus: (status) => status! < 500),
        );

        if (memberResponse.statusCode == 201) {
          TFullScreenLoader.stopLoading();
          Get.off(() => const VerifyEmailScreen());
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(
            title: 'Member Creation Failed',
            message: memberResponse.data['error'] ?? 'An error occurred while creating the member.',
          );
        }
      } else {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Sign-Up Failed',
          message: response.data['error'] ?? 'An error occurred during sign-up.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Sign-Up Error', message: e.toString());
    }
  }
}
