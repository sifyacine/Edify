import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

import '../../../features/authentication/screens/signin/signin_screen.dart';
import '../../../navigation_menu.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final dio = Dio(); // Using Dio for API requests
  final baseUrl = 'http://127.0.0.1:8000'; // Your Django API URL

  /// Check if the user is already authenticated and redirect accordingly
  Future<void> screenRedirect() async {
    final token = deviceStorage.read('auth_token');
    if (token != null) {
      // Validate token (Optional: make a call to check token validity)
      Get.offAll(() => const NavigationMenu());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  /// Function to log in with email and password
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/authentication/login/',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Save token and user information
        deviceStorage.write('auth_token', data['access']); // Save token
        deviceStorage.write('refresh_token', data['refresh']); // Save refresh token if needed
        deviceStorage.write('user', data['user']); // Save user details

        // Redirect to main screen
        Get.offAll(() => const NavigationMenu());
      } else {
        // Handle invalid credentials or errors
        throw Exception('Login failed. Please check your email and password.');
      }
    } catch (e) {
      // Handle general errors
      throw Exception('An error occurred while logging in: $e');
    }
  }

  /// Function to register a new user
  Future<void> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final response = await dio.post(
        '$baseUrl/authentication/register/',
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        // Registration successful, auto-login or navigate to login
        Get.offAll(() => const LoginScreen());
      } else {
        throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

  /// Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    super.onReady();
  }

  /// Function to request password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final response = await dio.post(
        '$baseUrl/authentication/password/reset/',
        data: {
          'email': email,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Notify user that the email has been sent
        Get.snackbar('Success', 'Password reset email sent successfully');
      } else {
        throw Exception('Failed to send password reset email');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Function to verify email (if required by your backend)
  Future<void> verifyEmail(String token) async {
    try {
      final response = await dio.post(
        '$baseUrl/authentication/verify-email/',
        data: {
          'token': token,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Email verified successfully');
      } else {
        throw Exception('Email verification failed');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }


  /// logout user
  Future<void> logout() async {
    try {
      final dio = Dio();

      // Replace with your Django logout endpoint
      final response = await dio.post(
        'http://127.0.0.1:8000/authentication/logout/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        Get.offAll(() => const LoginScreen());
      } else {
        // Handle server errors
        final error = response.data;
        throw Exception(error['detail'] ?? 'Failed to logout');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail'] ?? 'Failed to logout');
      } else {
        throw Exception("Something went wrong, please try again");
      }
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw Exception("Something went wrong, please try again");
    }
  }
}
