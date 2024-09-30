import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/authentication/screens/onboarding/onboarding_screen.dart';
import '../../../features/authentication/screens/signin/signin_screen.dart';
import '../../../features/authentication/screens/signup/verify_email.dart';
import '../../../navigation_menu.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final dio = Dio();
  final baseUrl = 'https://edify-jicc8.ondigitalocean.app';

  /// Determine the appropriate screen to redirect to
  Future<void> screenRedirect() async {
    try {
      // Check if it's the first time the user launches the app
      final isFirstTime = deviceStorage.read("IsFirstTime") ?? true;
      if (isFirstTime) {
        deviceStorage.write("IsFirstTime", false);
        Get.off(() => const OnBoardingScreen());
        return;
      }

      // Check if the user is signed in (i.e., access token exists)
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken != null) {
        // Fetch user data to check if the email is verified
        final userResponse = await dio.get(
          '$baseUrl/auth/login/', // Correct endpoint for user details
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

        // Check for a valid response and print user data for debugging
        if (userResponse.statusCode == 200) {
          print("User Data: ${userResponse.data}");

          // Check email verification status
          if (userResponse.data['is_email_verified'] == true) {
            Get.off(() => const NavigationMenu());
          } else {
            Get.off(() => VerifyEmailScreen(email: userResponse.data['email']));
          }
        } else {
          // Handle cases where the user response is not successful
          Get.off(() => const LoginScreen());
        }
      } else {
        // No access token, navigate to login screen
        Get.off(() => const LoginScreen());
      }
    } catch (e) {
      // Error handling (network issues, etc.)
      print("Error in screen redirect: $e");
      Get.off(() => const LoginScreen());
    }
  }

  @override
  void onReady() {
    // Remove splash screen and handle redirection
    FlutterNativeSplash.remove();
    screenRedirect();
    super.onReady();
  }

  /// Logout functionality
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      // Check if refresh token is available
      if (refreshToken == null) {
        // No refresh token available, force logout and redirect to login
        await _forceLogout(prefs);
        return;
      }

      // Attempt to send a logout request to the server
      final response = await dio.post(
        '$baseUrl/authentication/logout/',
        data: {'refresh': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('access_token')}',
          },
        ),
      );

      // If the server responds successfully, clear the tokens and navigate to login
      if (response.statusCode == 204) {
        await _clearTokens(prefs);
        Get.offAll(() => const LoginScreen());
      } else {
        // If the server responds with an error status, throw an exception
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs (network error, missing token, etc.), force logout
      print('Logout error: $e');
      await _forceLogout(await SharedPreferences.getInstance());
    }
  }

  /// Clear tokens and redirect to login
  Future<void> _clearTokens(SharedPreferences prefs) async {
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  /// Force logout and redirect to login in case of missing tokens or other issues
  Future<void> _forceLogout(SharedPreferences prefs) async {
    await _clearTokens(prefs);
    Get.offAll(() => const LoginScreen());
  }

}
