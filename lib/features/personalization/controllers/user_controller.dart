import 'package:get/get.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/loaders/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find(); // Singleton pattern for accessing the controller

  // Observable properties
  var userEmail = ''.obs;
  var userUsername = ''.obs;
  var userFirstName = ''.obs;
  var userLastName = ''.obs;
  var userPhoneNumber = ''.obs;
  var userProfilePicture = ''.obs;
  var userAboutMe = ''.obs;
  var userIsInstructor = false.obs;
  var userNumFollowers = 0.obs;
  var userNumReviews = 0.obs;
  var userNumCourses = 0.obs;
  var userGeneralRating = 0.0.obs;

  /// Fetch user record by username
  Future<void> fetchUserRecord(String username) async {
    try {
      print("Fetching data for user: $username");
      final userRepository = Get.find<UserRepository>();
      final userResponse = await userRepository.fetchUser(username);

      if (userResponse != null) {

        print(userResponse);
        // Update the email observable for UI tracking
        userEmail.value = userResponse.email;
        userUsername.value = userResponse.username;
        userFirstName.value = userResponse.firstName;
        userLastName.value = userResponse.lastName;
        userPhoneNumber.value = userResponse.phoneNumber?? "";
        userProfilePicture.value = userResponse.profilePicture?? "";
        userAboutMe.value = userResponse.aboutMe ?? "";
        userIsInstructor.value = userResponse.isInstructor;
        userNumFollowers.value = userResponse.numFollowers;
        userNumReviews.value = userResponse.numReviews;
        userNumCourses.value = userResponse.numCourses;
        userGeneralRating.value = userResponse.generalRating;


        // Notify success
        TLoaders.successSnackBar(
          title: "Data Fetched",
          message: "User information has been successfully fetched.",
        );
      } else {
        print("User data is null");
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
