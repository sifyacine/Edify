import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:edify/features/main/screens/shorts/widgets/comments.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

abstract class ShowShortController extends GetxController {
  initData();
  getShortVideos();
  likeVideo(index, i);
  increaseWithDecreaseLike(int currentLikes, i);
  getComments(int shortVideoID, int index);
  checkVolumeVideo();
  loadVideos();
  changeVideo(index);
}

class ShowShortControllerImp extends ShowShortController {
  Dio dio = Dio();

  RxDouble uploadProgress = 0.0.obs;
  RxBool showReply = false.obs;
  RxList shorts = [].obs;
  RxBool pause = false.obs;
  RxBool playing = true.obs;
  RxList<VideoPlayerController> videoPlayerControllers =
      <VideoPlayerController>[].obs;
  RxBool isLoading = false.obs;
  RxList videoUrls = [].obs;
  RxInt currentIndex = 0.obs;
  late BetterPlayerPlaylistController playlistController;
  late List<BetterPlayerDataSource> dataSourceList;
  RxBool isLiked = false.obs;
  List<RxBool> likesVideo = [];
  RxList comments = [].obs;
  RxBool volume = true.obs;
  // المتغير الخاص بالفيديو الحال

  @override
  getShortVideos() async {
    isLoading.value = true;
    update();
    var response = await TDioHelper.get(
        "https://education15845d.pythonanywhere.com/shortvideo/readall/", {});

    if (response.statusCode == 200) {
      shorts.addAll(response.data['message']);
      loadVideos();
    } else {
      TLoaders.errorSnackBar(title: 'Error');
    }
    isLoading.value = false;
    update();
  }

  @override
  initData() {}

  @override
  void onInit() async {
    super.onInit();

    await getShortVideos();
    //loadVideos();
    shorts.isNotEmpty
        ? likesVideo = List.generate(shorts.length, (index) => false.obs)
        : [];
  }

  @override
  loadVideos() async {
    for (var video in shorts) {
      var videoController = VideoPlayerController.networkUrl(Uri.parse(
        "https://education15845d.pythonanywhere.com${video['short_video']}",
      ));

      videoController.initialize().then((_) {
        videoPlayerControllers.add(videoController);
      });

      videoPlayerControllers.refresh();
    }
  }

  @override
  changeVideo(index) async {
    videoPlayerControllers[currentIndex.value].pause();
    currentIndex.value = index;
    videoPlayerControllers[currentIndex.value].play();
  }

  @override
  void dispose() {
    for (var controller in videoPlayerControllers) {
      print(
          '/////////////////////////////////////////////////////////////////////////////////');
      controller.dispose();
    }
    super.dispose();
  }

  @override
  checkVolumeVideo() {
    if (volume.value) {
      return const Icon(
        Icons.volume_up_outlined,
        size: 35,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.volume_off_outlined,
        size: 35,
        color: Colors.white,
      );
    }
  }

  @override
  likeVideo(index, i) async {
    if (likesVideo[i].value) {
      likesVideo[i].toggle();

      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/shortvideo/decreaselike/',
            {"id": index.toString()},
            uploadProgress);
      } catch (e) {
        print("error $e");
      }
    } else {
      likesVideo[i].toggle();
      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/shortvideo/increaselike/',
            {"id": index.toString()},
            uploadProgress);
      } catch (e) {
        print("error $e");
      }
    }
    update();
  }

  @override
  increaseWithDecreaseLike(int currentLikes, i) {
    if (likesVideo[i].value) {
      int sumLikes = currentLikes + 1;
      return sumLikes.toString();
    } else {
      currentLikes.toString();
      return currentLikes;
    }
  }

  @override
  getComments(shortVideoID, index) async {
    comments.value = [];
    isLoading.value = true;

    final isConnected = await NetworkManager.instance.isConnected();

    try {
      if (isConnected) {
        print(shortVideoID);
        var response = await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/shortvideocomment/read/',
            {'short_video': shortVideoID},
            uploadProgress);
        if (response.statusCode == 200) {
          comments.addAll(response.data['message']);
          List<RxBool> showRepliesList =
              List.generate(comments.length, (index) => false.obs);

          Get.bottomSheet(
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    return Obx(() => ViewComments(
                          commentReport: () {},
                          commentTime: comments[i]['created_at'],
                          commentlike: "100",
                          showReply: showRepliesList[i],
                          commentsNumber:
                              shorts[index]["short_comments"].toString(),
                          memberPic: 'assets/logos/google-icon.png',
                          memberFullName: comments[i]['member']['full_name'],
                          content: comments[i]['content'],
                          commentLike: const LikeButton(size: 20),
                          repliesNumber: comments[i]['replies'].length,
                          repley: () {},
                          showRepliesList: showRepliesList,
                          i: i,
                          replies: comments[i]['replies'],
                        ));
                  }),
              backgroundColor: Colors.white);
        }
      } else {
        TLoaders.warningSnackBar(
            title: "Warring", message: "Check your intrent");
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: "Error", message: "Server Error 400");
    }
    isLoading.value = false;
  }
}
