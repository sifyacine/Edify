import 'package:edify/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'data/repositories/user/user_repository.dart';
import 'features/personalization/controllers/user_controller.dart'; // Import UserRepository

Future<void> main() async {
  /// Add Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Init Local Storage
  await GetStorage.init();

  // Preserve splash screen while app initializes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize repositories
  Get.put(UserController());
  Get.put(AuthenticationRepository());
  Get.put(NetworkManager());
  Get.put(UserRepository()); // User repository initialization

  // Start the app
  runApp(App());
}
