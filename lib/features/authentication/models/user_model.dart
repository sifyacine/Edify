import '../../../utils/formatters/formatter.dart';

class UserModel {
  final int id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String? phoneNumber;
  String? profilePicture; // Nullable
  String? aboutMe; // Nullable
  bool isInstructor;
  int numFollowers;
  int numReviews;
  int numCourses;
  double generalRating;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phoneNumber = "",
    this.profilePicture = "",
    this.aboutMe = "",
    this.isInstructor = false,
    this.numFollowers = 0,
    this.numReviews = 0,
    this.numCourses = 0,
    this.generalRating = 0.0,
  });

  // Get full name
  String get fullName => '$firstName $lastName';

  // Format phone number
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber!);

  // Split full name
  static List<String> nameParts(String fullName) => fullName.split(" ");

  // Generate username
  static String generateUserName(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUserName = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUserName";
    return usernameWithPrefix;
  }

  // Empty user model
  static UserModel empty() => UserModel(
    id: 0,
    firstName: '',
    lastName: '',
    username: '',
    email: '',
  );

  // Override the toString method for easy debugging
  @override
  String toString() {
    return 'UserModel{id: $id, firstName: $firstName, lastName: $lastName, username: $username, email: $email, phoneNumber: $phoneNumber}';
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      profilePicture: json['profile_picture'] as String?,
      aboutMe: json['about_me'] as String?,
      isInstructor: json['is_instructor'] as bool? ?? false,
      numFollowers: json['num_followers'] as int? ?? 0,
      numReviews: json['num_reviews'] as int? ?? 0,
      numCourses: json['num_courses'] as int? ?? 0,
      generalRating: (json['general_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'about_me': aboutMe,
      'is_instructor': isInstructor,
      'num_followers': numFollowers,
      'num_reviews': numReviews,
      'num_courses': numCourses,
      'general_rating': generalRating,
    };
  }

}
