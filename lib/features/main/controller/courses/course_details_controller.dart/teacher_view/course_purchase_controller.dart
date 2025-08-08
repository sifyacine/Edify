import 'package:better_player/better_player.dart';
import 'package:edify/features/main/screens/courses/course_details/course_purchase/course_purchase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CoursePurchaseController extends GetxController {}

class CoursePurchaseControllerImp extends CoursePurchaseController {
  String videoUrl;

  CoursePurchaseControllerImp(this.videoUrl);
  late BetterPlayerController betterPlayerController;

  @override
  void onInit() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4");
    betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
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
        betterPlayerDataSource: dataSource);
    super.onInit();
  }

  List homeworks = [
    "https://www.citystgeorges.ac.uk/__data/assets/image/0010/685342/varieties/breakpoint-max.jpg",
    "https://www.citystgeorges.ac.uk/__data/assets/image/0010/685342/varieties/breakpoint-max.jpg",
    "https://www.citystgeorges.ac.uk/__data/assets/image/0010/685342/varieties/breakpoint-max.jpg"
  ];
}
