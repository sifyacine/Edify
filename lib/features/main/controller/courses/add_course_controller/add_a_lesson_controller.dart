import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:edify/features/main/screens/courses/edit_course/edit_course.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

abstract class AddALessonController extends GetxController {
  initData();
  chooseLesson();
  videoCompressing();
  chooseSourse();
  publishLesson();
  publishSources(int videoID);
  deleteImgSource(int index);
  RxBool checkInformation();
  progressDownload(RxDouble progress);
}

class AddALessonControllerImp extends AddALessonController {
  int courseID;
  int userID;
  AddALessonControllerImp(this.courseID, this.userID);
  RxBool isLoading = false.obs;

  // for video lesson
  XFile? lessonVideo;
  RxBool lessonVideoExist = false.obs;
  RxBool isCompress = false.obs;
  RxBool videoisComprissing = false.obs;
  RxBool isChooseLesson = false.obs;
  // fields
  Rx<TextEditingController> title = TextEditingController().obs;
  Rx<TextEditingController> desc = TextEditingController().obs;
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  RxList<XFile>? listSources = <XFile>[].obs;
  // uploading
  RxList multipartFiles = [].obs;
  RxDouble uploadProgressCourse = 0.0.obs;
  RxDouble uploadProgressSources = 0.0.obs;

  Random random = Random();
  @override
  initData() {}
  @override
  void onInit() async {
    chooseLesson();

    super.onInit();
  }

  @override
  chooseLesson() async {
    isChooseLesson.value = true;
    lessonVideoExist.value = false;

    final picker = ImagePicker();
    lessonVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (lessonVideo != null) {
      lessonVideoExist.value = true;
      isChooseLesson.value = false;
    } else {
      lessonVideoExist.value = false;
      isChooseLesson.value = false;
    }
  }

  var compressedVideo;
  @override
  videoCompressing() async {
    isCompress.value = false;
    videoisComprissing.value = true;
    try {
      compressedVideo = await VideoCompress.compressVideo(
        lessonVideo!.path,
        quality: VideoQuality.MediumQuality,
      );
      isCompress.value = true;
      videoisComprissing.value = false;
      print("${compressedVideo!.file!.path} +++++++++++++++++++++++++++++++++");
      return true;
    } catch (e) {
      compressedVideo = lessonVideo!;
      isCompress.value = false;
      videoisComprissing.value = false;
      TLoaders.errorSnackBar(title: 'error : $e');
      return true;
    }
  }

  @override
  chooseSourse() async {
    if (listSources!.length <= 10) {
      final picker = ImagePicker();
      final listImages = await picker.pickMultiImage(limit: 10);
      for (var i in listImages) {
        if (listSources!.length <= 9) {
          listSources!.add(i);
        }
      }
    } else {
      TLoaders.customToast(
          message: "Can't add more than this.",
          duration: const Duration(seconds: 5));
    }
  }

  @override
  publishLesson() async {
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        isLoading.value = true;
        if (checkInformation().isTrue) {
          // compress video
          await videoCompressing();
          int randomLessonName = random.nextInt(100000);
          // upload video
          print("${randomLessonName.toString()}${lessonVideo!.name}");
          dio.Response response = await TDioHelper.post(
              "https://education15845d.pythonanywhere.com/videos/create/",
              {
                "video_title": title.value.text.trim(),
                "video_desc": desc.value.text.trim(),
                "video_video": await dio.MultipartFile.fromFile(
                    compressedVideo!.file!.path,
                    filename:
                        "${randomLessonName.toString()}${lessonVideo!.name}"),
                "course": courseID,
                "member": userID,
                "member_id": userID
              },
              // progress
              uploadProgressCourse
              // options

              );
          print(response.statusCode);
          if (response.statusCode == 201) {
            // upload course
            await publishSources(response.data['message']['id']);
            Get.offAll(() => EditCourse(
                  userID: userID,
                  courseID: courseID,
                ));
          } else {
            TLoaders.errorSnackBar(
                title: "Error 400",
                message: "please check your information and try again");
          }
        } else {
          TLoaders.customToast(
              message: "المعلومات غير مكتملة",
              duration: const Duration(seconds: 3));
        }
        isLoading.value = false;
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
  }

  @override
  publishSources(int videoID) async {
    try {
      for (XFile file in listSources!) {
        int randomFileName = random.nextInt(100000);
        dio.Response response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/homework/create/",
          {
            "homework_file": await dio.MultipartFile.fromFile(file.path,
                filename: "${randomFileName.toString()}${file.name}"),
            "video": videoID,
          },
          uploadProgressSources,
        );
        print(response.statusCode);
      }
      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "File Error",
          message:
              "One of your files is invalid. Try checking the files you entered.",
          duration: const Duration(seconds: 5));
      return false;
    }
  }

  @override
  deleteImgSource(int index) {
    listSources!.removeAt(index);
  }

  @override
  RxBool checkInformation() {
    if (forms.currentState!.validate()) {
      if (title.value.text.isNotEmpty &&
          lessonVideo != null &&
          desc.value.text.isNotEmpty) {
        return true.obs;
      } else {
        TLoaders.customToast(
            message: "المعلومات غير مكتملة",
            duration: const Duration(seconds: 5));
        return false.obs;
      }
    }
    return false.obs;
  }

  @override
  progressDownload(RxDouble progress) {
    return progress * 100;
  }
}
