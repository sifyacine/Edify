import 'package:edify/features/main/models/course/courseDetails.dart';
import 'package:get/get.dart';

abstract class CourseCardController extends GetxController {
  CourseDetails? getCourseDetails();
}

class CourseCardControllerImp extends CourseCardController {
  Map course;

  CourseCardControllerImp(this.course);

  @override
  CourseDetails? getCourseDetails() {
    if (course.isNotEmpty) {
      print(course["benefits"]);
      print(course);
      return CourseDetails.fromMap(course);
    } else {
      return null;
    }
  }
}
