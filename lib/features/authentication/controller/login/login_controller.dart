import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/user_controller.dart';
import 'package:dio/dio.dart' as dio;
import '../../screens/signin/signin_screen.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final emailOrUsername = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>(); // Get existing instance
  final dio.Dio _dio = dio.Dio();

  @override
  void onInit() {
    super.onInit();

    // Load remembered email if any
    emailOrUsername.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';

    // Set up Dio interceptors to automatically handle tokens
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = localStorage.read('auth_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options); // Continue request
      },
      onError: (dio.DioError e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshToken = localStorage.read('refresh_token');
          if (refreshToken != null) {
            try {
              final refreshResponse = await _dio.post(
                'https://edify-jicc8.ondigitalocean.app/auth/token/refresh/',
                data: {'refresh': refreshToken},
              );

              if (refreshResponse.statusCode == 200) {
                final newAccessToken = refreshResponse.data['access'];
                localStorage.write('auth_token', newAccessToken);

                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccessToken';
                final cloneReq = await _dio.request(
                  opts.path,
                  options: dio.Options(method: opts.method),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            } catch (refreshError) {
              localStorage.remove('auth_token');
              localStorage.remove('refresh_token');
              Get.offAll(() => LoginScreen()); // Navigate to login if refresh fails
            }
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> emailOrUsernameAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Please fill in all fields correctly.',
      );
      return;
    }

    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection.',
        );
        return;
      }

      // Show loading screen before making network requests
      TFullScreenLoader.openLoadingDialog(
        "Logging you in...",
        "assets/images/animations/loader-animation.json",
      );

      final loginData = {
        'email': emailOrUsername.text.trim(),
        'password': password.text.trim(),
      };

      final dio.Response response = await _dio.post(
        'https://edify-jicc8.ondigitalocean.app/auth/login/',
        data: loginData,
      );

      if (response.statusCode == 200) {
        await _handleSuccessfulLogin(response.data);
      } else if (response.statusCode == 401) {
        // Handle incorrect email/password
        final errorMessage = response.data['detail'] ?? 'Incorrect email or password.';
        TLoaders.errorSnackBar(
          title: 'Login Failed',
          message: errorMessage,
        );
      } else {
        // General error
        TLoaders.errorSnackBar(
          title: 'Login Failed',
          message: 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Unexpected Error',
        message: 'An error occurred: ${e.toString()}',
      );
    } finally {
      // Ensure the loader stops regardless of success or failure
      TFullScreenLoader.stopLoading();
    }
  }


  Future<void> _handleSuccessfulLogin(Map<String, dynamic> data) async {
    final authToken = data['tokens']['access'];
    final refreshToken = data['tokens']['refresh'];

    if (authToken != null && refreshToken != null && authToken.isNotEmpty && refreshToken.isNotEmpty) {
      localStorage.write('auth_token', authToken);
      localStorage.write('refresh_token', refreshToken);

      final dio.Response userResponse = await _dio.get(
        'https://edify-jicc8.ondigitalocean.app/member/${data['username']}/',
      );

      if (userResponse.statusCode == 200 && userResponse.data != null) {
        await userController.fetchUserRecord(userResponse.data['username']);
        _handleRememberMe();

        // Show success message
        TLoaders.successSnackBar(
          title: 'Login Success',
          message: 'Welcome back!',
        );

        Get.off(() => const NavigationMenu());
      } else {
        TLoaders.errorSnackBar(
          title: 'User Data Error',
          message: 'Unable to retrieve user data.',
        );
      }
    } else {
      TLoaders.errorSnackBar(
        title: 'Token Error',
        message: 'Invalid token received.',
      );
    }
  }

  void _handleRememberMe() {
    if (rememberMe.value) {
      localStorage.write("REMEMBER_ME_EMAIL", emailOrUsername.text.trim());
      localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
    } else {
      localStorage.remove("REMEMBER_ME_EMAIL");
      localStorage.remove("REMEMBER_ME_PASSWORD");
    }
  }
}
