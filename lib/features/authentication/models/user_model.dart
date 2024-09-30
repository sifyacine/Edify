class UserModel {
  final int id; // Maps to 'user.id'
  final String email; // Maps to 'user.email'
  String username; // Maps to 'user.username'
  String? fullName; // Maps to 'full_name'
  String? profilePic; // Maps to 'profile_pic'
  String? aboutMe; // Maps to 'about_me'
  bool isInstructor; // Maps to 'is_instructor'
  int numFollowers; // Maps to 'num_followers'
  int numReviews; // Maps to 'num_reviews'
  int numCourses; // Maps to 'num_courses'
  double generalRating; // Maps to 'general_rating'
  List<String> myPosts; // Maps to 'my_posts'
  List<String> myShorts; // Maps to 'my_shorts'
  List<String> myCourses; // Maps to 'my_courses'
  List<String> savedPosts; // Maps to 'saved_posts'
  List<String> savedShorts; // Maps to 'saved_shorts'
  List<String> savedCourses; // Maps to 'saved_courses'

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.profilePic,
    this.aboutMe,
    this.isInstructor = false,
    this.numFollowers = 0,
    this.numReviews = 0,
    this.numCourses = 0,
    this.generalRating = 0.0,
    List<String>? myPosts,
    List<String>? myShorts,
    List<String>? myCourses,
    List<String>? savedPosts,
    List<String>? savedShorts,
    List<String>? savedCourses,
  })  : myPosts = myPosts ?? [],
        myShorts = myShorts ?? [],
        myCourses = myCourses ?? [],
        savedPosts = savedPosts ?? [],
        savedShorts = savedShorts ?? [],
        savedCourses = savedCourses ?? [];

  // Getters for profile picture URL and formatted full name
  String get profilePictureUrl => profilePic ?? 'default_image_url';
  String get formattedFullName => fullName ?? 'No Name';

  // Factory method for creating an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String?,
      profilePic: json['profile_pic'] as String?,
      aboutMe: json['about_me'] as String?,
      isInstructor: json['is_instructor'] as bool? ?? false,
      numFollowers: json['num_followers'] as int? ?? 0,
      numReviews: json['num_reviews'] as int? ?? 0,
      numCourses: json['num_courses'] as int? ?? 0,
      generalRating: (json['general_rating'] as num?)?.toDouble() ?? 0.0,
      myPosts: (json['my_posts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      myShorts: (json['my_shorts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      myCourses: (json['my_courses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      savedPosts: (json['saved_posts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      savedShorts: (json['saved_shorts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      savedCourses: (json['saved_courses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  // Method to serialize the object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
      'about_me': aboutMe,
      'is_instructor': isInstructor,
      'num_followers': numFollowers,
      'num_reviews': numReviews,
      'num_courses': numCourses,
      'general_rating': generalRating,
      'my_posts': myPosts,
      'my_shorts': myShorts,
      'my_courses': myCourses,
      'saved_posts': savedPosts,
      'saved_shorts': savedShorts,
      'saved_courses': savedCourses,
    };
  }

  // Optional: Implement == and hashCode for better comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
