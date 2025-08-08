import 'package:get/get.dart';

abstract class MyCoursesController extends GetxController {}

class MyCoursesControllerImp extends MyCoursesController {
  // loading
  RxBool isLoading = false.obs;
  RxList myCourses = [1, 2, 3, 4, 5].obs;
}
