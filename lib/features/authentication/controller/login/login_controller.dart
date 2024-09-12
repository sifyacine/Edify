import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/user_controller.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final emailOrUsername = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>(); // Use Get.find() to get the existing instance

  @override
  void onInit() {
    super.onInit();
    // Load remembered email
    emailOrUsername.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
  }

  /// Email or Username and password sign-in
  Future<void> emailOrUsernameAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) {
      // Show error if the form is not valid
      TLoaders.errorSnackBar(title: 'Validation Error', message: 'Please fill in all fields correctly.');
      return;
    }

    try {
      // Show loading screen
      TFullScreenLoader.openLoadingDialog("Logging you in...", "assets/images/animations/loader-animation.json");

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      // Prepare login data
      final loginData = {
        'username': emailOrUsername.text.trim(),
        'password': password.text.trim(),
      };

      // Debug: Print login data
      print('Login Data: $loginData');

      // Send login request
      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        'http://127.0.0.1:8000/authentication/login/', // Ensure correct URL
        data: loginData,
        options: Options(validateStatus: (status) => status! < 500), // Allow status codes < 500
      );

      if (response.statusCode == 200) {
        // Extract tokens
        final authToken = response.data['access'];
        final refreshToken = response.data['refresh'];

        // Save tokens to local storage
        localStorage.write('auth_token', authToken);
        localStorage.write('refresh_token', refreshToken);

        // Fetch user data with the access token
        final userResponse = await dio.get(
          'http://127.0.0.1:8000/member/members/${loginData['username']}/',
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );

        if (userResponse.statusCode == 200) {
          final userCredentials = userResponse.data;
          print("User Credentials: $userCredentials");

          // Save user data to userController
          await userController.fetchUserRecord(loginData['username']!);

          // If "Remember Me" is checked, save email and password
          if (rememberMe.value) {
            localStorage.write("REMEMBER_ME_EMAIL", emailOrUsername.text.trim());
            localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
          } else {
            // Clear the stored values if not remembering
            localStorage.remove("REMEMBER_ME_EMAIL");
            localStorage.remove("REMEMBER_ME_PASSWORD");
          }

          // Stop loader and navigate to the home screen
          TFullScreenLoader.stopLoading();
          Get.off(() => const NavigationMenu());
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(title: 'Fetch Error', message: 'Unable to retrieve user data.');
        }
      } else {
        // Login failed, display error
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Login Failed',
          message: response.data['error'] ?? 'Invalid username or password.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      // Handle login error
      TLoaders.errorSnackBar(title: 'Login Error', message: e.toString());
    }
  }
}
