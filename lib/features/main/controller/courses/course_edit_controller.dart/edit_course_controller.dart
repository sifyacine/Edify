import 'package:edify/features/main/models/course/courseDetails.dart';
import 'package:edify/features/main/screens/courses/course_details/course_details.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

abstract class EditCourseController extends GetxController {
  getCourceDetails();
  fetchCourseData();

  // video intro
  chooseVideoIntro();

  // thumbnail
  chooseThumbnail();
}

class EditCourseControllerImp extends EditCourseController {
  EditCourseControllerImp(this.courseID);
  int courseID;
  // loading
  RxBool isLoading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxBool isChoosePicker = false.obs;

  // data
  var course = <Map<String, dynamic>>[].obs;
  var videos = [].obs;
  List benefits = [];

  // new TextEditingController course
  TextEditingController newTitleController = TextEditingController();
  TextEditingController newSubjectController = TextEditingController();
  TextEditingController newDescController = TextEditingController();
  // new TextEditingController video
  TextEditingController editVideoTitle = TextEditingController();
  TextEditingController editVideoDesc = TextEditingController();

  // price

  RxInt selectedItem = 0.obs;

  final ExpansionTileController expansionTileController =
      ExpansionTileController();
  // video intro
  RxBool introChanged = false.obs;
  XFile? newVideoIntro;

  // thumbail
  RxBool thumbnailChanged = false.obs;
  XFile? thumbnail;

  @override
  void onInit() async {
    await fetchCourseData();

    super.onInit();
  }

  @override
  fetchCourseData() async {
    print(courseID);
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      isLoading.value = true;
      try {
        // uploading
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/courses/read/",
            {'id': courseID},
            uploadProgress);
        if (response.statusCode == 200) {
          course.add(response.data['message']);
        } else {
          TLoaders.errorSnackBar(
              title: "Error", message: "No data yet ,Please try again");
        }
      } on dio.DioException catch (e) {
        // ignore: unrelated_type_equality_checks
        if (e.type == dio.DioException.connectionError) {
          TLoaders.customToast(
              message: "انقطع الاتصال بالإنترنت",
              duration: const Duration(seconds: 10));
        }
      }
    } else {
      TLoaders.customToast(
          message: " No Internet", duration: const Duration(seconds: 3));
    }
    isLoading.value = false;
  }

  // Data organization
  @override
  CourseDetails? getCourceDetails() {
    if (course.isNotEmpty) {
      selectedItem.value = course[0]['course_price'];
      videos.value = course[0]['videos'];
      return CourseDetails.fromMap(course[0]);
    } else {
      return null;
    }
  }

  // choose the new video intro
  @override
  chooseVideoIntro() async {
    isChoosePicker.value = true;
    var picker = ImagePicker();
    newVideoIntro = await picker.pickVideo(source: ImageSource.gallery);
    if (newVideoIntro != null) {
      int videoSize = await newVideoIntro!.length();
      if (videoSize > 200 * 1024 * 1024) {
        newVideoIntro = null;
        isChoosePicker.value = false;

        return TLoaders.errorDialog(
            "حجم الفيديو كبير جداا , يجب ان لايتجاوز 200 جيجا ");
      }
      introChanged.value = true;
    }

    isChoosePicker.value = false;
  }

  @override
  chooseThumbnail() async {
    isChoosePicker.value = true;
    var picker = ImagePicker();
    thumbnail = await picker.pickImage(source: ImageSource.gallery);
    if (thumbnail != null) {
      int thumbnailSize = await thumbnail!.length();
      if (thumbnailSize > 10 * 1024 * 1024) {
        thumbnail = null;
        isChoosePicker.value = false;

        return TLoaders.errorDialog(
            "حجم الصورة كبير جداا , يجب ان لايتجاوز 10 ميجا ");
      }
      thumbnailChanged.value = true;
    }

    isChoosePicker.value = false;
  }

  // prices
  List<RxInt> prices = [
    0.obs,
    200.obs,
    300.obs,
    400.obs,
    500.obs,
    600.obs,
    700.obs,
    800.obs,
    900.obs,
    1000.obs,
    1200.obs,
    1400.obs,
    1500.obs
  ];
}
