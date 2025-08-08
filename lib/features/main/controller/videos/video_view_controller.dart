import 'package:better_player/better_player.dart';
import 'package:edify/features/main/screens/courses/edit_course/edit_course.dart';
import 'package:edify/features/main/screens/home_page/home_page.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

abstract class VideoViewController extends GetxController {
  deleteLesson(int lessonID);
  deleteHomeWork(int homeworkID);
}

class VideoViewControllerImp extends VideoViewController {
  int userID;
  int courseID;

  Map videoUrl;
  VideoViewControllerImp(this.videoUrl, this.courseID, this.userID);
  late BetterPlayerController betterPlayerController;

  @override
  void onInit() {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://education15845d.pythonanywhere.com${videoUrl["video_video"]}",
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 100 * 1024 * 1024, // 100MB كحد أقصى للتخزين
        maxCacheFileSize: 10 * 1024 * 1024, // 10MB لكل ملف
      ),
    );
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        errorBuilder: (context, errorMessage) {
          return const Icon(Icons.error_outline);
        },
        fit: BoxFit.fill,
        fullScreenAspectRatio: 16 / 9,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          enableAudioTracks: true,
          showControls: true,
          enableProgressBar: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    super.onInit();
  }

  @override
  void onClose() {
    betterPlayerController.dispose();
    super.onClose();
  }

  @override
  deleteLesson(int lessonID) async {
    try {
      var response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/videos/delete/",
          {"id": lessonID},
          0.0.obs);
      if (response.statusCode == 200) {
        TLoaders.successSnackBar(title: "Video", message: "Has Been Deleted");
        Get.offAll(() => EditCourse(
              courseID: courseID,
              userID: userID,
            ));
      } else {
        TLoaders.errorDialog("Some thing is wrong");
      }
    } catch (e) {}
  }

  @override
  deleteHomeWork(int homeworkID) async {
    try {
      var response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/homework/delete/",
          {"id": homeworkID},
          0.0.obs);
      if (response.statusCode == 200 && response.data["status"] == "success") {
        TLoaders.successSnackBar(
            title: "HomeWork", message: "Has Been Deleted");
        Get.back();
      } else {
        TLoaders.errorDialog("Some thing is wrong");
      }
    } catch (e) {}
  }
}
