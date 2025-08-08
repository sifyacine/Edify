import 'package:get/get.dart';

abstract class HomeCoursesController extends GetxController {}

class HomeCoursesControllerImp extends HomeCoursesController {
  RxList courses = [].obs;
}
