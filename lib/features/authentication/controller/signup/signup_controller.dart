import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../screens/signup/verify_email.dart';

class SignUpController extends GetxController {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final termsAndConditions = false.obs;
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final Dio _dio = Dio();


  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Please fill in all fields correctly.',
      );
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
      TFullScreenLoader.openLoadingDialog(
        "Signing you up...",
        "assets/images/animations/loader-animation.json",
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection.',
        );
        return;
      }

      final signUpData = {
        'username': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
      };

      _dio.options.headers['Content-Type'] = 'application/json';

      // Send the registration request
      final response = await _dio.post(
        'https://edify-jicc8.ondigitalocean.app/auth/register/',
        data: signUpData,
      );

      TFullScreenLoader.stopLoading();

      if (response.statusCode == 201) {
        final userData = response.data;

        // If the API response contains a token
        if (userData.containsKey('token')) {
          Get.to(() => VerifyEmailScreen(email: userData['email'],));
        } else {
          // Handle case where token isn't returned, only email verification is needed
          Get.to(() => VerifyEmailScreen(email: userData['email'],));
        }

        TLoaders.successSnackBar(
          title: 'Sign Up Successful',
          message: 'Please check your email for verification instructions.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Sign Up Failed',
          message: 'Something went wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      TFullScreenLoader.stopLoading();
      if (e.response != null && e.response!.statusCode == 400) {
        TLoaders.errorSnackBar(
          title: 'Sign Up Error',
          message: 'Email or username already exists.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'An unexpected error occurred.',
        );
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        "Resending email...",
        "assets/images/animations/loader-animation.json",
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection.',
        );
        return;
      }

      // Get the access token from storage (e.g., SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Authentication Error',
          message: 'Please log in again.',
        );
        return;
      }

      // Add authorization token to headers
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      _dio.options.headers['Content-Type'] = 'application/json';

      // Send the request to resend the verification email
      final response = await _dio.post(
        'https://edify-jicc8.ondigitalocean.app/auth/resend-verification/',
      );

      TFullScreenLoader.stopLoading();

      if (response.statusCode == 200) {
        TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Verification email has been resent successfully.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Resend Failed',
          message: 'Could not resend verification email. Please try again.',
        );
      }
    } on DioException catch (e) {
      TFullScreenLoader.stopLoading();
      if (e.response != null && e.response!.statusCode == 400) {
        TLoaders.errorSnackBar(
          title: 'Resend Error',
          message: e.response!.data['error'] ?? 'An unexpected error occurred.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

}
