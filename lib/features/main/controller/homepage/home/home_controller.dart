import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  getObjects();
  formatNumber(int number);
  // posts
  likeDislikePost(int postID, bool isLiked);
  saveUnSavePost(int postID, bool isSaved);
}

class HomeControllerImp extends HomeController {
  RxBool isLoading = false.obs;
  RxList mixedObjects = [].obs;
  int currentPage = 1;
  int userID = 3;
  RxBool hasMore = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    await getObjects();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isLoading.value &&
          hasMore.value) {
        currentPage++;
        getObjects();
      }
    });
    super.onInit();
  }

  @override
  getObjects() async {
    bool isConneted = await NetworkManager.instance.isConnected();
    if (isConneted) {
      isLoading.value = true;
      try {
        var response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/objectsmixed/get/",
            {"page": currentPage, "user_id": userID, "member": userID},
            0.0.obs);
        if (response.statusCode == 200) {
          List newShorts = response.data['results'];
          print(newShorts);
          mixedObjects.addAll(newShorts);
          if (response.data['next'] != null) {
            hasMore.value = true;
          } else {
            hasMore.value = false;
          }
          print(
              "current page ------------------------------------- : $currentPage");
          print(
              "has more ------------------------------------- : ${hasMore.value}");
        } else {
          TLoaders.errorDialog("Failed to load data");
        }
      } catch (e) {
        TLoaders.errorDialog("Failed to load data");
      }
      isLoading.value = false;
    } else {
      TLoaders.customToast(
        message: "No Interent",
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  String formatNumber(dynamic number) {
    number is RxInt ? number = number.value : number;
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toString();
    }
  }

  @override
  likeDislikePost(
    int postID,
    bool isLiked,
  ) async {
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        var response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/postlike/postlike/",
            {"post": postID, "member": userID},
            0.0.obs);
        if (response.statusCode == 200) {
        } else if (response.statusCode == 400) {
          TLoaders.errorDialog("Already liked/disliked");
        } else if (response.statusCode == 401) {
          TLoaders.errorDialog("Unauthorized");
        } else if (response.statusCode == 403) {
          TLoaders.errorDialog("Forbidden");
        } else {
          TLoaders.errorDialog("Failed to like/dislike post");
        }
      } catch (e) {
        TLoaders.errorDialog("Failed to like/dislike post");
      }
    } else {
      TLoaders.customToast(
        message: "No Interent",
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  saveUnSavePost(int postID, bool isSaved) async {
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        var response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/post/savepost/",
            {"post": postID, "member": userID},
            0.0.obs);
        if (response.statusCode == 200) {
        } else if (response.statusCode == 400) {
          TLoaders.errorDialog("Already saved/unsaved");
        } else if (response.statusCode == 401) {
          TLoaders.errorDialog("Unauthorized");
        } else if (response.statusCode == 403) {
          TLoaders.errorDialog("Forbidden");
        } else {
          TLoaders.errorDialog("Failed to save/unSave post");
        }
      } catch (e) {
        TLoaders.errorDialog("Failed to save/unSave post");
      }
    } else {
      TLoaders.customToast(
        message: "No Interent",
        duration: const Duration(seconds: 3),
      );
    }
  }
}
