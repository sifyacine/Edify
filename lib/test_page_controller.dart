import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

abstract class TestPageController extends GetxController {}

class TestPageControllerImp extends TestPageController {
  RxList comments = [].obs;
  RxBool isLoading = false.obs;
  RxBool isEndOfList = false.obs;
  RxInt currentPage = 1.obs;
  ScrollController scrollController = ScrollController();
  Dio dio = Dio();

  Future<void> getComments() async {
    print("true");
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;

    try {
      var response = await dio.post(
        "https://education15845d.pythonanywhere.com/postcomment/read/",
        data: {"post": 17, "user_id": 1, "page": currentPage.value},
      );

      if (response.statusCode == 200) {
        List newComment = response.data["results"]["message"];
        bool hasMore = response.data['next'] != null;

        // إضافة التعليقات الجديدة
        comments.addAll(newComment);

        // تحديث حالة النهاية
        isEndOfList.value = !hasMore;

        // زيادة الصفحة
        if (hasMore) currentPage.value++;
      } else {
        TLoaders.errorSnackBar(
            title: "Error", message: "Failed to get comments");
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Server Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onScroll() async {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isEndOfList.value) {
      await getComments();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getComments();
    scrollController.addListener(onScroll);
  }
}
