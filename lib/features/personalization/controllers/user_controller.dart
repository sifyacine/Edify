import 'package:get/get.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/loaders/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Observable properties
  var userEmail = ''.obs;
  var userUsername = ''.obs;
  var userFullName = ''.obs;
  var userProfilePicture = ''.obs;
  var userAboutMe = ''.obs;
  var userIsInstructor = false.obs;
  var userNumFollowers = 0.obs;
  var userNumReviews = 0.obs;
  var userNumCourses = 0.obs;
  var userGeneralRating = 0.0.obs;

  // Observable lists for posts, shorts, courses, and saved items
  var myPosts = <String>[].obs;
  var myShorts = <String>[].obs;
  var myCourses = <String>[].obs;
  var savedPosts = <String>[].obs;
  var savedShorts = <String>[].obs;
  var savedCourses = <String>[].obs;

  /// Fetch user record by username
  Future<void> fetchUserRecord(String username) async {
    try {
      print("Fetching data for user: $username");
      final userRepository = Get.find<UserRepository>();
      final userResponse = await userRepository.fetchUser(username);

      if (userResponse != null) {
        // Update observable properties with user data
        userEmail.value = userResponse.email;
        userUsername.value = userResponse.username;
        userFullName.value = userResponse.fullName ?? '';
        userProfilePicture.value = userResponse.profilePic ?? '';
        userAboutMe.value = userResponse.aboutMe ?? '';
        userIsInstructor.value = userResponse.isInstructor;
        userNumFollowers.value = userResponse.numFollowers;
        userNumReviews.value = userResponse.numReviews;
        userNumCourses.value = userResponse.numCourses;
        userGeneralRating.value = userResponse.generalRating;

        // Update lists with user data
        myPosts.assignAll(userResponse.myPosts ?? []);
        myShorts.assignAll(userResponse.myShorts ?? []);
        myCourses.assignAll(userResponse.myCourses ?? []);
        savedPosts.assignAll(userResponse.savedPosts ?? []);
        savedShorts.assignAll(userResponse.savedShorts ?? []);
        savedCourses.assignAll(userResponse.savedCourses ?? []);

        TLoaders.successSnackBar(
          title: "Data Fetched",
          message: "User information has been successfully fetched.",
        );
      } else {
        TLoaders.warningSnackBar(
          title: "No Data",
          message: "User data is empty.",
        );
      }
    } catch (e, stackTrace) {
      print("Error fetching user record: $e");
      print("Stack trace: $stackTrace");

      TLoaders.errorSnackBar(
        title: "Fetch Failed",
        message: "Something went wrong while fetching user information.",
      );
    }
  }
}
