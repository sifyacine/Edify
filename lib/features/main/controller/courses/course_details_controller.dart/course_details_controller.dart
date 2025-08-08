import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CourseDetailsController extends GetxController {}

class CourseDetailsControllerImp extends CourseDetailsController {
  CourseDetailsControllerImp(this.videoUrl);
  late BetterPlayerController betterPlayerController;

  RxInt price = 1.obs;
  // video intro
  String videoUrl;

  final ExpansionTileController expansionTileController =
      ExpansionTileController();

  @override
  void onInit() {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
    );
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
      betterPlayerDataSource: dataSource,
    );
    super.onInit();
  }

  @override
  void onClose() {
    betterPlayerController.dispose();
    print("       dddddddddddddddddddddddddddddddddddddddddddddddddddddispose");
    super.onClose();
  }
}
