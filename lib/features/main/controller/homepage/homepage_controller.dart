import 'package:dio/dio.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

abstract class HomePageController extends GetxController {
  getPosts();
  likeDislikePost(id, int i);

  formatNumber(int number);

  savePost(int i, int post, int member);
}

class HomePageControllerImp extends HomePageController {
  int userID = 2;
  int currentPostID = 0;
  int index = 0;
  RxList posts = [].obs;
  RxBool isLoading = false.obs;
  List<RxBool> isSavePost = [];
  List<RxBool> likePosts = [];

  GetStorage box = GetStorage();

  List<int> currentLikePost = [];

  RxInt currentLike = 0.obs;
  Dio dio = Dio();
  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    await getPosts();

    super.onInit();
  }

  @override
  getPosts() async {
    isLoading.value = true;
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
        var response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/post/getall/",
            {'user_id': userID},
            0.0.obs);

        if (response.statusCode == 200) {
          posts.addAll(response.data['message']);

          posts.isNotEmpty
              ? likePosts = List.generate(posts.length, (index) => false.obs)
              : [];
          posts.isNotEmpty
              ? currentLikePost = List.generate(
                  posts.length, (index) => posts[index]["post_likes"])
              : [];
          posts.isNotEmpty
              ? isSavePost = List.generate(posts.length, (index) => false.obs)
              : [];
        } else if (response.statusCode == 400) {
          TLoaders.errorSnackBar(
              title: 'Warring', message: "There are no posts");
        }
      } else {
        TLoaders.errorSnackBar(
            title: "Warring", message: "There is no network");
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Error 404");
    }
    isLoading.value = false;
  }

  @override
  likeDislikePost(id, i) async {
    if (likePosts[i].value) {
      likePosts[i].toggle();

      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/postlike/postlike/',
            {"post": id, "member": userID},
            0.0.obs);
      } catch (e) {
        print("error $e");
      }
    } else {
      likePosts[i].toggle();

      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/postlike/postlike/',
            {"post": id, "member": userID},
            0.0.obs);
      } catch (e) {
        print("error $e");
      }
    }
    update();
  }

  @override
  String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toString();
    }
  }

  @override
  savePost(int i, int post, int member) async {
    if (isSavePost[i].value) {
      isSavePost[i].toggle();
    } else {
      isSavePost[i].toggle();
    }
    print(isSavePost[i].value);
    try {
      var isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
        var response = await dio.post(
            "https://education15845d.pythonanywhere.com/post/savepost/",
            data: {"post": post, "member": member});
        if (response.statusCode == 200) {}
      } else {
        TLoaders.errorSnackBar(title: "Network", message: "Check your network");
      }
    } catch (e) {
      print(e);
    }
  }
}
