import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:edify/utils/dio/dio_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

abstract class ShowShortController extends GetxController {
  initlizingVideos();
  getShorts();
  preLoading(int index);
}

class ShowShortControllerImp extends ShowShortController {
  Dio dio = Dio();

  RxList videoPlayerControllers = [].obs;

  RxList shorts = [
    "https://education15845d.pythonanywhere.com/media/upload/25/03/23/video.mp4",
    "https://media.istockphoto.com/id/2162665170/video/robotic-vision-concept-in-a-warehouse-workers-managing-inventory-at-logistics-center.mp4?s=mp4-640x640-is&k=20&c=vKypq-bjltrOuQ77fTz5c6kmbVWXlvFjQPap1CIPGb4=",
    "https://education15845d.pythonanywhere.com/media/upload/25/03/28/video_vaiEOiN.mp4",
    "https://media.istockphoto.com/id/480098682/video/sales-growth.mp4?s=mp4-640x640-is&k=20&c=RIsjCbH3NGgiSsLWaTRBK9tk0zkxTG3v0QsITvREKvE="
  ].obs;
  // constroller
  @override
  void onInit() {
    initlizingVideos();

    super.onInit();
  }

  @override
  initlizingVideos() async {
    for (String short in shorts) {
      videoPlayerControllers
          .add(VideoPlayerController.networkUrl(Uri.parse(short)));
    }
    videoPlayerControllers[0].initialize();
  }

  @override
  getShorts() async {
    var response = await TDioHelper.post(
        "https://education15845d.pythonanywhere.com/shortvideo/readall/",
        {},
        0.0.obs);
  }

  @override
  preLoading(int index) {
    videoPlayerControllers[index + 1].initialize();
  }
}

/*  RxDouble uploadProgress = 0.0.obs;
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
  }*/
