class Post {
  final int id;
  final Member member;
  final DateTime publishedDate;
  final String description;
  final List<ImageData> images;
  final int numLikes;
  final int numComments;
  final int numShares;
  final bool isSaved;

  Post({
    required this.id,
    required this.member,
    required this.publishedDate,
    required this.description,
    required this.images,
    required this.numLikes,
    required this.numComments,
    required this.numShares,
    required this.isSaved,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      member: Member.fromJson(json['member']),
      publishedDate: DateTime.parse(json['published_date']),
      description: json['description'],
      images: (json['images'] as List)
          .map((image) => ImageData.fromJson(image))
          .toList(),
      numLikes: json['num_likes'],
      numComments: json['num_comments'],
      numShares: json['num_shares'],
      isSaved: json['is_saved'],
    );
  }
}

class Member {
  final int id;
  final User user;
  final String profilePicture;
  final String aboutMe;
  final bool isInstructor;
  final int numFollowers;
  final int numReviews;
  final int numCourses;
  final double generalRating;

  Member({
    required this.id,
    required this.user,
    required this.profilePicture,
    required this.aboutMe,
    required this.isInstructor,
    required this.numFollowers,
    required this.numReviews,
    required this.numCourses,
    required this.generalRating,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      user: User.fromJson(json['user']),
      profilePicture: json['profile_picture'],
      aboutMe: json['about_me'],
      isInstructor: json['is_instructor'],
      numFollowers: json['num_followers'],
      numReviews: json['num_reviews'],
      numCourses: json['num_courses'],
      generalRating: json['general_rating'],
    );
  }
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

class ImageData {
  final int id;
  final String image;

  ImageData({
    required this.id,
    required this.image,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      image: json['image'],
    );
  }
}
