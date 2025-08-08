import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:edify/features/main/screens/courses/edit_course/edit_course.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

abstract class AddCourseController extends GetxController {
  initData();
  addBenefits(String myBenefit);
  removeBenefits(int benefitIndex);
  chooseThumbnail();
  chooseIntro();
  addHashtag();
  removeHashtag(index);
  videoCompressing();
  publishPartOne(int userID);
  RxBool checkCompletedData();
  progressDownload(RxDouble progress);

  animationText(TickerProvider vsync);
}

class AddCourseControllerImp extends AddCourseController
    with SingleGetTickerProviderMixin {
  AddCourseControllerImp(this.userID, this.courseID);
  int userID;
  int? courseID;

  // loading
  RxBool isLoading = false.obs;
  RxBool videoisComprissing = false.obs;
  RxBool checkVideo = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxBool publish = false.obs;

  //text field
  TextEditingController modelName = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController benefit = TextEditingController();
//files
  XFile? thumbnail;
  RxBool thumbnailExist = false.obs;
  XFile? intro;
  RxBool isCompress = false.obs;
  RxBool videoIntroExist = false.obs;

  final ExpansionTileController expansionTileController =
      ExpansionTileController();
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  VideoPlayerController? videoPlayerController;
  RxList hashtags = [].obs;

  RxInt benefitLength = 0.obs;

  TextEditingController hashtag = TextEditingController();
  RxList benefits = [].obs;
  Dio myDio = Dio();
  RxBool isExpanded = false.obs;
  RxInt price = 1.obs;

  List<RxInt> prices = [
    0.obs,
    200.obs,
    300.obs,
    400.obs,
    500.obs,
    600.obs,
    700.obs,
    800.obs,
    900.obs,
    1000.obs,
    1200.obs,
    1400.obs,
    1500.obs
  ];
  Random random = Random();
// for text animation
  AnimationController? animationController;
  Animation<Offset>? animation;

  @override
  void onInit() async {
    animationText(this);
    super.onInit();
  }

  @override
  initData() {}

  @override
  addBenefits(String myBenefit) {
    if (benefits.length == 10) {
      TLoaders.warningSnackBar(
          duration: 5,
          title: "Warring",
          message: "You can't add more than 10 benefits");
      return null;
    }

    benefits.add(myBenefit);
    benefit.text = "";
  }

  @override
  removeBenefits(int benefitIndex) {
    benefits.removeAt(benefitIndex);
  }

  @override
  chooseThumbnail() async {
    thumbnailExist.value = false;
    final picker = ImagePicker();
    thumbnail = await picker.pickImage(source: ImageSource.gallery);
    if (thumbnail != null) {
      thumbnailExist.value = true;
    }
  }

  @override
  chooseIntro() async {
    checkVideo.value = true;
    videoIntroExist.value = false;
    final picker = ImagePicker();
    intro = await picker.pickVideo(source: ImageSource.gallery);
    if (intro != null) {
      int videoSize = await intro!.length();
      if (videoSize > 200 * 1024 * 1024) {
        checkVideo.value = false;
        intro = null;
        return TLoaders.errorSnackBar(
            duration: 5,
            title: "حجم الفيديو كبير جداا , يجب ان لايتجاوز 200 جيجا ");
      }
    }

    if (intro != null) {
      videoIntroExist.value = true;
      videoPlayerController = VideoPlayerController.file(File(intro!.path));
    }
    checkVideo.value = false;
  }

  @override
  addHashtag() async {
    if (hashtag.value.text.isNotEmpty && hashtag.value.text.length <= 30) {
      if (hashtags.length >= 5) {
        TLoaders.errorSnackBar(
            duration: 5, title: 'Warring', message: 'max of the hashtag is 5');
      } else {
        hashtags.add(hashtag.value.text);
        hashtag.text = "";
      }
    } else {
      hashtag.value.text.isEmpty
          ? TLoaders.errorSnackBar(
              duration: 5, title: "Warring", message: "can't be than empty")
          : TLoaders.errorSnackBar(
              duration: 5,
              title: "Warring",
              message: "can't be than more 30 characters");
    }
  }

  @override
  removeHashtag(index) {
    hashtags.removeAt(index);
  }

  // ignore: prefer_typing_uninitialized_variables
  var compressedVideo;
  @override
  videoCompressing() async {
    isCompress.value = false;
    videoisComprissing.value = true;
    try {
      compressedVideo = await VideoCompress.compressVideo(
        intro!.path,
        quality: VideoQuality.MediumQuality,
      );
      isCompress.value = true;
      videoisComprissing.value = false;
      print("${compressedVideo!.file!.path} +++++++++++++++++++++++++++++++++");
      return true;
    } catch (e) {
      compressedVideo = intro;
      isCompress.value = false;
      videoisComprissing.value = false;
      TLoaders.errorSnackBar(title: 'error : $e');
      return true;
    }
  }

  @override
  publishPartOne(int userID) async {
    int randomThumbnail = random.nextInt(1000000);
    int randomIntro = random.nextInt(1000000);
    if (checkCompletedData().isTrue) {
      try {
        await videoCompressing();

        isLoading.value = true;
        print("${randomThumbnail.toString()}${thumbnail!.name}");
        dio.Response response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/courses/create/",
          {
            "course_name": modelName.value.text.trim(),
            "course_title": title.value.text.trim(),
            "course_desc": description.value.text.trim(),
            "course_intro": await dio.MultipartFile.fromFile(
                compressedVideo!.file!.path,
                filename: "${randomIntro.toString()}${intro!.name}"),
            "course_thumbnail": await dio.MultipartFile.fromFile(
                thumbnail!.path,
                filename: "${randomThumbnail.toString()}${thumbnail!.name}"),
            "course_price": price.value,
            "benefits": benefits,
            "hashtags": hashtags,
            "member": userID,
            "member_id": userID,
          },
          uploadProgress,
        );
        print(response.statusCode);

        if (response.statusCode == 201) {
          Get.off(() => EditCourse(
                userID: userID,
                courseID: response.data["data"]['id']!,
              ));
        } else {
          TLoaders.errorSnackBar(
              title: "Error", message: "Check Your Information");
        }

        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        TLoaders.errorSnackBar(title: "Error 404", message: "$e");
      }
    }
  }

  @override
  RxBool checkCompletedData() {
    if (forms.currentState!.validate()) {
      if (benefits.isNotEmpty &&
          title.value.text.isNotEmpty &&
          description.value.text.isNotEmpty &&
          modelName.value.text.isNotEmpty &&
          !checkVideo.value &&
          hashtags.isNotEmpty &&
          price.value != 1.0 &&
          thumbnail != null &&
          intro != null) {
        return true.obs;
      } else {
        TLoaders.customToast(
            message: "المعلومات غير مكتملة.",
            duration: const Duration(seconds: 5));
        return false.obs;
      }
    } else {
      TLoaders.customToast(
          message: "You must follow the field conditions",
          duration: const Duration(seconds: 5));
      return false.obs;
    }
  }

  @override
  progressDownload(RxDouble progress) {
    return progress * 100;
  }

  @override
  animationText(TickerProvider vsync) {
    animationController =
        AnimationController(vsync: vsync, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    animation = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(1.0, 0.0))
        .animate(CurvedAnimation(
            parent: animationController!, curve: Curves.easeOut));
  }
}
