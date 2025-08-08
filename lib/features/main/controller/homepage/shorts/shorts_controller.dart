import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:video_player/video_player.dart';

abstract class ShortsController extends GetxController {
  getShorts();
  Future<bool> likeDislike(int shortVideo, int likeIndex);
  pausePlayVideo(int i);
  saveUnSaveShort(int shortID, bool isSaved);
}

class ShortsControllerImp extends ShortsController {
  RxList shorts = [].obs;
  RxList videosController = [].obs;
  RxBool isLoading = false.obs;
  RxInt currentShortPage = 1.obs;
  RxBool isEndOfList = false.obs;
  PageController scrollController = PageController();
  RxList shortsLikes = [].obs;
  RxList shortsIsLiked = [].obs;
  int userID = 3;
  @override
  void onInit() async {
    await getShorts();
    super.onInit();
  }

  @override
  getShorts() async {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    print("جلب بيانات الصفحة: $currentShortPage");

    var response = await TDioHelper.post(
        "https://education15845d.pythonanywhere.com/shortvideo/readall/",
        {"page": currentShortPage.value, "user_id": 3},
        0.0.obs);

    if (response.statusCode == 200) {
      List newShorts = response.data['results'];
      print(newShorts);
      bool hasMore = response.data['next'] != null;

      if (newShorts.isNotEmpty) {
        shorts.addAll(newShorts);
        shortsLikes = List.generate(
            shorts.length, (index) => shorts[index]['short_likes']).obs;
        print(shortsLikes);
        shortsIsLiked =
            List.generate(shorts.length, (index) => shorts[index]['is_liked'])
                .obs;
        print(shortsIsLiked[0]);

        hasMore ? currentShortPage.value++ : null;
        print("الصفحة التالية: ${currentShortPage.value}");
      }

      isEndOfList.value = !hasMore;

      // إضافة فيديوهات جديدة فقط
      for (var short in newShorts) {
        VideoPlayerController video = VideoPlayerController.networkUrl(Uri.parse(
            "https://education15845d.pythonanywhere.com${short["short_video"]}"));
        video.initialize();
        videosController.add(video);
      }
    } else {
      TLoaders.errorDialog("No Data");
    }

    isLoading.value = false;
  }

  @override
  pausePlayVideo(int i) async {
    if (videosController[i].value.isPlaying) {
      videosController[i].pause();
    } else {
      videosController[i].play();
    }
  }

  void onPageChanged(int index) {
    if (index == shorts.length) {
      getShorts();
    }
  }

  @override
  Future<bool> likeDislike(int shortVideo, int likeIndex) async {
    try {
      dio.Response response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/shortlike/create/",
          {"shortvideo": shortVideo, "member": userID},
          0.0.obs);
      if (response.statusCode == 200) {
        if (response.data["message"] == "like") {
          shortsLikes[likeIndex] = shortsLikes[likeIndex] + 1;

          shortsIsLiked[likeIndex] = shortsIsLiked[likeIndex] = true;
          print(shortsIsLiked[likeIndex]);
          print(shortsLikes[likeIndex]);

          return true;
        } else {
          shortsLikes[likeIndex] = shortsLikes[likeIndex] - 1;
          print("${shortsLikes[likeIndex]} ----------------- unlike");
          print(shortsIsLiked[likeIndex]);

          shortsIsLiked[likeIndex] = shortsIsLiked[likeIndex] = false;
          return false;
        }
      } else {
        TLoaders.errorDialog("Can't add this action now , please try again.");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  saveUnSaveShort(int shortID, bool isSaved) async {
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        var response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/shortvideo/saveshort/",
            {"short": shortID, "member": userID},
            0.0.obs);
        if (response.statusCode == 200) {
        } else if (response.statusCode == 400) {
          TLoaders.errorDialog("Already saved/unsaved");
        } else if (response.statusCode == 401) {
          TLoaders.errorDialog("Unauthorized");
        } else if (response.statusCode == 403) {
          TLoaders.errorDialog("Forbidden");
        } else {
          TLoaders.errorDialog("Failed to save/unSave short");
        }
      } catch (e) {
        TLoaders.errorDialog("Failed to save/unSave short");
      }
    } else {
      TLoaders.customToast(
        message: "No Interent",
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in videosController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void onClose() {
    for (var controller in videosController) {
      controller.dispose();
    }
    videosController.clear();
    super.onClose();
  }
}
