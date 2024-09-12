import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  final Dio _dio = Dio(); // Dio instance for API requests
  final String _baseUrl = 'http://127.0.0.1:8000'; // Base URL for API

  /// Fetch user data from the backend
  Future<UserModel?> fetchUser(String username) async {
    try {
      // Ensure correct URL and add username to the endpoint
      final response = await _dio.get(
        '$_baseUrl/member/members/$username/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userData = response.data;

        // Parse user data to UserModel
        final user = UserModel(
          id: userData['id'] as int,
          username: userData['user']['username'] as String? ?? "",
          email: userData['user']['email'] as String? ?? "",
          firstName: userData['user']['first_name'] as String? ?? "",
          lastName: userData['user']['last_name'] as String? ?? "",
          phoneNumber: userData['phone_number'] as String? ?? "",
          profilePicture: userData['profile_picture'] as String? ?? "",
          aboutMe: userData['about_me'] as String? ?? "",
          isInstructor: userData['is_instructor'] as bool? ?? false,
          numFollowers: userData['num_followers'] as int? ?? 0,
          numReviews: userData['num_reviews'] as int? ?? 0,
          numCourses: userData['num_courses'] as int? ?? 0,
          generalRating: (userData['general_rating'] as num?)?.toDouble() ?? 0.0,
        );

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
}
