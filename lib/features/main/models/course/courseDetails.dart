import 'package:edify/features/main/screens/courses/course_details/course_details.dart';

class CourseDetails {
  final String videoUrl;
  final String courseName;
  final String courseTitle;
  final String courseDesc;
  final double courseRating;
  final String createBy;
  final String createAt;
  final int coursePrice;
  final List benefits;
  final List videos;

  // Constructor
  CourseDetails(
      {required this.videoUrl,
      required this.courseName,
      required this.courseTitle,
      required this.courseDesc,
      required this.courseRating,
      required this.createBy,
      required this.createAt,
      required this.coursePrice,
      required this.benefits,
      required this.videos});

  factory CourseDetails.fromMap(Map map) {
    return CourseDetails(
        videoUrl:
            "https://education15845d.pythonanywhere.com${map["course_intro"]}",
        courseName: map["course_name"],
        courseTitle: map["course_title"],
        courseDesc: map["course_desc"],
        courseRating: map["course_rating"],
        createBy: map["member"]["full_name"],
        createAt: map["create_at"],
        coursePrice: map['course_price'],
        benefits: List.from(map["benefits"]),
        videos: List.from(map["videos"]));
  }
}

class VideoDetails {
  final String videoTitle;
  final String videoDesc;
  final String videoUrl;
  final String createAt;

  VideoDetails(
      {required this.videoTitle,
      required this.videoDesc,
      required this.videoUrl,
      required this.createAt});

  factory VideoDetails.fromMap(Map<String, dynamic> map) {
    return VideoDetails(
        videoTitle: map["video_title"],
        videoDesc: map["video_desc"],
        videoUrl:
            "https://education15845d.pythonanywhere.com${map["video_video"]}",
        createAt: map["create_at"]);
  }
}
