import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

import 'package:edify/features/main/screens/shorts/shorts.dart';

import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

abstract class AddShortController extends GetxController {
  initData();
  chooseVideo();
  addHashtag(BuildContext context);
  addShort();
  removeHashtag(int i);
  stepContinue();
  stepClose();
  videoCompressing();
  finishPublish();
  publisherror();
}

class AddShortControllerImp extends AddShortController {
  int userId;
  AddShortControllerImp(this.userId);

  XFile? shortVideo;
  RxBool isInitialVideo = false.obs;

  Rx<TextEditingController> hashtagController = TextEditingController().obs;
  Rx<TextEditingController> titleController = TextEditingController().obs;
  RxBool publishError = false.obs;
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  RxDouble uploadProgress = 0.0.obs;
  var hashtags = [].obs;
  Dio myDio = Dio();
  RxBool isCompress = false.obs;
  RxBool isCompressing = false.obs;
  VideoPlayerController? videoPlayerController;
  RxBool isPublish = false.obs;
  RxBool isPulishing = false.obs;
  @override
  void onInit() async {
    await chooseVideo();
    await initData();
    super.onInit();
  }

  @override
  addHashtag(context) async {
    if (hashtagController.value.text.isNotEmpty &&
        hashtagController.value.text.length <= 25) {
      if (hashtags.length >= 5) {
        TLoaders.errorSnackBar(
            title: 'Warring', message: 'max of the hashtag is 5');
      } else {
        hashtags.add(hashtagController.value.text);
        hashtagController.value.text = "";
        update();
        print(hashtags);
      }
    } else {
      hashtagController.value.text.isEmpty
          ? TLoaders.warningSnackBar(
              title: "Warring", message: "can't be than empty")
          : TLoaders.warningSnackBar(
              title: "Warring", message: "can't be than more 25 characters");
    }
  }

  @override
  chooseVideo() async {
    final picker = ImagePicker();
    shortVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (shortVideo != null) {
      videoPlayerController =
          VideoPlayerController.file(File(shortVideo!.path));
    }
  }

  @override
  initData() async {}

  @override
  removeHashtag(int i) {
    hashtags.removeAt(i);
    update();
  }

  var compressedVideo;
  @override
  addShort() async {
    final isConnected = await NetworkManager.instance.isConnected();
    try {
      isPulishing.value = true;
      publishError.value = false;
      isPublish.value = false;
      if (isConnected) {
        dio.Response response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/shortvideo/create/",
          {
            'short_title': titleController.value.text,
            'member': userId,
            'member_id': userId,
            'hashtags': hashtags.value,
            'short_video': await dio.MultipartFile.fromFile(
              compressedVideo!.file!.path,
              filename: 'video.mp4',
            ),
          },
          uploadProgress,
        );

        if (response.statusCode == 201) {
          isPublish.value = true;

          TLoaders.successSnackBar(
              title: "Success", message: "Video was been uploaded");
          Get.off(() => const ShortVideo());
        } else {
          publishError.value = true;
          isPublish.value = false;

          TLoaders.errorSnackBar(title: "Error", message: response.data);
        }
      } else {
        publishError.value = true;
        isPublish.value = false;

        update();
        TLoaders.errorDialog("there is not internet");
      }
    } catch (e) {
      publishError.value = true;

      isPublish.value = false;
      TLoaders.errorDialog("Server Error 404 \n errore");
      Get.back();
    }
    isPulishing.value == false;
  }

  RxInt currentStep = 0.obs;

  @override
  stepContinue() async {
    if (forms.currentState!.validate()) {
      if (currentStep.value == 0 && isCompress.value == false) {
        currentStep.value = currentStep.value + 1;
        update();
        await videoCompressing();
        isCompress.value = true;
        currentStep.value = currentStep.value - 1;
      }
      if (currentStep.value == 1 && isPublish.value == false) {
        currentStep.value = currentStep.value + 1;
        update();
        await addShort();

        currentStep.value = currentStep.value - 1;
      }
      currentStep.value = currentStep.value + 1;
    }
    update();
  }

  @override
  stepClose() {
    if (currentStep.value > 0) {
      if (!isPublish.value) {
        currentStep.value = currentStep.value - 1;
      }

      update();
    }
  }

  @override
  videoCompressing() async {
    isCompressing.value = true;
    isCompress.value = false;
    try {
      compressedVideo = await VideoCompress.compressVideo(
        shortVideo!.path,
        quality: VideoQuality.MediumQuality,
      );

      isCompress.value = true;
    } catch (e) {
      compressedVideo = shortVideo;
      isCompress.value = false;
    }
    isCompressing.value = false;
  }

  @override
  finishPublish() async {
    Get.offAll(const ShortVideo());
  }

  @override
  publisherror() async {
    await addShort();
  }
}
