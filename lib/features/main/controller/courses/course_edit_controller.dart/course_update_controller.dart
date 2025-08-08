import 'dart:convert';

import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:http/http.dart' as http;

abstract class CourseUpdateController extends GetxController {
  // for course
  RxBool isLoadingSubject = false.obs;
  RxBool isLoadingTitle = false.obs;
  RxBool isLoadingDesc = false.obs;
  RxBool isLoadingPrice = false.obs;
  RxBool isLoadingThumbnail = false.obs;
  RxBool isLoadingIntro = false.obs;

  RxDouble uploadProgress = 1.1.obs;
  // update
  updateObjectCourse(data, RxDouble uploadProgress, String object);

  // edit intro

  editVideoInto(XFile? newIntro);
  // edit thumbnail
  editThumbnail(XFile? newThumbnail);
  // edit subject
  editSubject(String newSubject);
  // edit title
  editTitle(String newTitle);
  //edit desc
  editDesc(String newDesc);
  // edit price
  editPrice(String newPrice);

  // compress video
  compressVideoIntro(XFile? video);
  // ---------------- Video -------------------------
}

class CourseUpdateControllerImp extends CourseUpdateController {
  CourseUpdateControllerImp(this.userID);
  RxBool isCompress = false.obs;
  RxBool videoisComprissing = false.obs;
  // video intro
  RxBool introChanged = false.obs;
  XFile? newVideoIntro;
  int userID;

  //  -------------- edit course intro and thumbnail -------------------
  @override
  editVideoInto(XFile? newIntro) async {
    if (!isLoadingIntro.value) {
      isLoadingIntro.value = true;

      if (newIntro != null) {
        await updateObjectCourse({
          "course_intro": await dio.MultipartFile.fromFile(newIntro.path,
              filename: newIntro.name.toString()),
          "id": userID
        }, uploadProgress, "Intro");
        newIntro = null;
      }
    }

    isLoadingIntro.value = false;
  }

  @override
  editThumbnail(XFile? newThumbnail) async {
    if (!isLoadingThumbnail.value) {
      isLoadingThumbnail.value = true;
      if (newThumbnail != null) {
        await updateObjectCourse({
          "course_thumbnail": await dio.MultipartFile.fromFile(
              newThumbnail.path,
              filename: newThumbnail.name),
          "id": userID
        }, uploadProgress, "Thumbnail");
        newThumbnail = null;
      }
    }

    isLoadingThumbnail.value = false;
  }

  // --------------- edit subject of the course  -----------------------------------------
  @override
  editSubject(String newSubject) async {
    if (!isLoadingSubject.value) {
      isLoadingSubject.value = true;
      if (newSubject.isNotEmpty) {
        if (newSubject.length < 3) {
          TLoaders.errorDialog("subject can't be less than 3 characters");
        } else {
          await updateObjectCourse({"id": userID, "course_name": newSubject},
              uploadProgress, "Subject");
        }
      }
    }

    isLoadingSubject.value = false;
  }

  //  -------------- edit title of the course and title of the video  --------------------
  @override
  editTitle(String newTitle) async {
    if (!isLoadingTitle.value) {
      isLoadingTitle.value = true;
      if (newTitle.isNotEmpty) {
        if (newTitle.length < 10) {
          TLoaders.errorDialog("title can't be less than 10 characters");
        } else {
          await updateObjectCourse({"course_title": newTitle, "id": userID},
              uploadProgress, "Title");
        }
      }
    }

    isLoadingTitle.value = false;
  }

  // ------------------- edit desc of the course and desc of the video --------------------------
  @override
  editDesc(String newDesc) async {
    if (!isLoadingDesc.value) {
      isLoadingDesc.value = true;
      if (newDesc.isNotEmpty) {
        if (newDesc.length < 100) {
          TLoaders.errorDialog("description can't be less than 100 characters");
        } else {
          await updateObjectCourse({"course_desc": newDesc, "id": userID},
              uploadProgress, "Description");
        }
      }
    }

    isLoadingDesc.value = false;
  }

  //  ----------------- edit course price  -----------
  @override
  editPrice(String newPrice) async {
    isLoadingPrice.value = true;
    if (newPrice.isNotEmpty) {
      int.parse(newPrice);

      await updateObjectCourse(
          {"course_price": newPrice, "id": userID}, uploadProgress, "Price");
    }
    isLoadingPrice.value = false;
  }

// ----------------------- update the objects of the   course ------------------
  @override
  updateObjectCourse(data, RxDouble uploadProgress, String object) async {
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/courses/update/",
            data,
            uploadProgress);
        if (response.statusCode == 200) {
          TLoaders.successDialog("$object has been updated");
        } else {
          TLoaders.errorDialog(
              "can't update $object please check your information. and try again");
        }
      } on dio.DioException catch (e) {
        TLoaders.errorDialog("$e Please try again");
      }
    } else {
      TLoaders.errorSnackBar(
          title: "Internet", message: "There is no internet");
    }

    uploadProgress.value = 1.1;
  }

  // compress video  @override
  var compressedVideo;
  @override
  compressVideoIntro(XFile? video) async {
    isCompress.value = false;
    videoisComprissing.value = true;
    try {
      compressedVideo = await VideoCompress.compressVideo(
        video!.path,
        quality: VideoQuality.MediumQuality,
      );
      isCompress.value = true;
      videoisComprissing.value = false;
      print("${compressedVideo!.file!.path} +++++++++++++++++++++++++++++++++");
      return true;
    } catch (e) {
      compressedVideo = video;
      isCompress.value = false;
      videoisComprissing.value = false;
      TLoaders.errorSnackBar(title: 'error : $e');
      return true;
    }
  }
}
