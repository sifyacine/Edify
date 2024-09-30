import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  final Dio _dio = Dio(); // Dio instance for API requests
  final String _baseUrl = 'https://edify-jicc8.ondigitalocean.app/'; // Base URL for API

  /// Fetch user data from the backend and save it locally
  Future<UserModel?> fetchUser(String username) async {
    try {
      // Ensure correct URL and add username to the endpoint
      final response = await _dio.get(
        '$_baseUrl/member/$username/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userData = response.data;

        // Parse user data to UserModel
        final user = UserModel.fromJson(userData);

        // Save user data to SharedPreferences
        await _saveUserData(user);

        return user;
      } else {
        print("Failed to fetch user data: ${response.data}");
        throw Exception("Failed to fetch user data: ${response.data}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw FormatException('Unexpected error occurred while fetching user data', e.toString());
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store the user data as key-value pairs
      await prefs.setInt('user_id', user.id);
      await prefs.setString('email', user.email);
      await prefs.setString('username', user.username);
      await prefs.setString('full_name', user.fullName ?? '');
      await prefs.setString('profile_pic', user.profilePic ?? '');
      await prefs.setString('about_me', user.aboutMe ?? '');
      await prefs.setBool('is_instructor', user.isInstructor);
      await prefs.setInt('num_followers', user.numFollowers);
      await prefs.setInt('num_reviews', user.numReviews);
      await prefs.setInt('num_courses', user.numCourses);
      await prefs.setDouble('general_rating', user.generalRating);

      // Save list fields as JSON strings
      await prefs.setString('my_posts', user.myPosts?.join(',') ?? '');
      await prefs.setString('my_shorts', user.myShorts?.join(',') ?? '');
      await prefs.setString('my_courses', user.myCourses?.join(',') ?? '');
      await prefs.setString('saved_posts', user.savedPosts?.join(',') ?? '');
      await prefs.setString('saved_shorts', user.savedShorts?.join(',') ?? '');
      await prefs.setString('saved_courses', user.savedCourses?.join(',') ?? '');

      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: $e");
      throw Exception("Failed to save user data: $e");
    }
  }

  /// Retrieve user data from SharedPreferences
  Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('user_id')) {
        return UserModel(
          id: prefs.getInt('user_id')!,
          email: prefs.getString('email') ?? '',
          username: prefs.getString('username') ?? '',
          fullName: prefs.getString('full_name') ?? '',
          profilePic: prefs.getString('profile_pic') ?? '',
          aboutMe: prefs.getString('about_me') ?? '',
          isInstructor: prefs.getBool('is_instructor') ?? false,
          numFollowers: prefs.getInt('num_followers') ?? 0,
          numReviews: prefs.getInt('num_reviews') ?? 0,
          numCourses: prefs.getInt('num_courses') ?? 0,
          generalRating: prefs.getDouble('general_rating') ?? 0.0,

          // Split the stored strings back into lists
          myPosts: prefs.getString('my_posts')?.split(',') ?? [],
          myShorts: prefs.getString('my_shorts')?.split(',') ?? [],
          myCourses: prefs.getString('my_courses')?.split(',') ?? [],
          savedPosts: prefs.getString('saved_posts')?.split(',') ?? [],
          savedShorts: prefs.getString('saved_shorts')?.split(',') ?? [],
          savedCourses: prefs.getString('saved_courses')?.split(',') ?? [],
        );
      } else {
        return null; // No user data saved
      }
    } catch (e) {
      print("Error retrieving user data: $e");
      return null;
    }
  }
}
