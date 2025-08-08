import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

abstract class CoursesActivitiesController extends GetxController {
  getCourses();
  deleteCourse(int id, int courseIndex);
}

class CoursesActivitiesControllerImp extends CoursesActivitiesController {
  CoursesActivitiesControllerImp(this.userID);
  int userID;

  // loading
  RxBool isLoading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  // courses
  RxList courses = [].obs;

  @override
  void onInit() async {
    await getCourses();
    super.onInit();
  }

  @override
  getCourses() async {
    try {
      var isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
        isLoading.value = true;
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/courses/mread/",
            {"member": userID},
            uploadProgress);
        if (response.statusCode == 200) {
          courses.addAll(response.data["message"]);
        }
        isLoading.value = false;
      } else {
        TLoaders.errorDialog("No Internt");
      }
    } catch (e) {
      TLoaders.errorDialog(e.toString());
    }
  }

  @override
  deleteCourse(int id, int courseIndex) async {
    try {
      var isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
        isLoading.value = true;
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/courses/delete/",
            {"id": id},
            uploadProgress);
        if (response.statusCode == 200) {
          TLoaders.successSnackBar(
              title: "Success", message: "Course has been deleted");
          courses.removeAt(courseIndex);
        }
        isLoading.value = false;
      } else {
        TLoaders.errorDialog("No Internt");
      }
    } catch (e) {
      TLoaders.errorDialog(e.toString());
    }
  }
}
