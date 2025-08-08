import 'package:dio/dio.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

abstract class PostCommentController extends GetxController {
  getCommnets(int postID, int userID);
  addComment(int postID, int? parentID, int userID);
  formatNumber(int number);
  likeDislikePostComment(int commentID, int commentIndex, int userID);
  addRepleyCommentPost(
      String memberFullName, int postID, int parentID, int userID);
}

class PostCommentControllerImp extends PostCommentController {
  RxList comments = [].obs;
  List<RxBool> showRepliesList = [];
  GetStorage box = GetStorage();
  Dio dio = Dio();
  ScrollController scrollController = ScrollController();
  RxBool isEndOfList = false.obs;
  List<int> currentLikePost = [];
  List<int> currentLikeComment = [];
  RxInt currentCommentPage = 1.obs;
  List<RxBool> likeCommentsPost = [];
  RxBool isAddingCommnet = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController newComment = TextEditingController();

  int commentNumber = Get.arguments['commentNumber'];
  int postID = Get.arguments['postID'];
  int userID = Get.arguments['userID'];

  @override
  void onInit() async {
    await getCommnets(postID, userID);
    scrollController.addListener(onScroll);

    super.onInit();
  }

  void onScroll() async {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isEndOfList.value) {
      await getCommnets(postID, userID);
    }
  }

  @override
  getCommnets(int postID, int userID) async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      if (isLoading.value || isEndOfList.value) return;
      isLoading.value = true;
      var response = await dio.post(
        "https://education15845d.pythonanywhere.com/postcomment/read/",
        data: {
          "post": postID,
          "user_id": userID,
          "page": currentCommentPage.value,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        List newComment = response.data['results']['message'];
        bool hasMore = response.data['next'] != null;
        comments.addAll(newComment);
        isEndOfList.value = !hasMore;
        if (hasMore) currentCommentPage.value++;
        comments.isNotEmpty
            ? likeCommentsPost =
                List.generate(comments.length, (index) => false.obs)
            : [];
        showRepliesList = List.generate(comments.length, (index) => false.obs);
        comments.isNotEmpty
            ? currentLikeComment = List.generate(
                comments.length, (index) => comments[index]["comment_likes"])
            : [];
      } else if (response.statusCode == 400) {
        comments = [].obs;
        TLoaders.customToast(
            message: "Can't get comments", duration: Duration(seconds: 5));
      } else {
        TLoaders.errorSnackBar(
            title: 'Server Error',
            message: "Server Error 404 , Please Try Again");
      }
    } else {
      TLoaders.customToast(
          message: "Check Your Network", duration: Duration(seconds: 5));
    }
    isLoading.value = false;
  }

  @override
  addComment(int postID, int? parentID, int userID) async {
    if (isLoading.value) return;
    isAddingCommnet.value = true;
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
        if (newComment.text.isNotEmpty) {
          var response = await TDioHelper.post(
              "https://education15845d.pythonanywhere.com/postcomment/create/",
              {
                "content": newComment.text.trim(),
                "member": userID,
                'member_id': userID,
                "post": postID,
                "parent": parentID
              },
              0.0.obs);

          if (response.statusCode == 201) {
            Map myComment = response.data['message'];

            myComment["is_liked"] = false;
            if (parentID == null) {
              comments.add(myComment);
              likeCommentsPost.add(false.obs);
              showRepliesList.add(false.obs);
              currentLikeComment.add(myComment["comment_likes"]);
              Future.delayed(const Duration(milliseconds: 100), () {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            } else {
              int commentIndex = box.read("commentIndex");

              comments[commentIndex]['replies'].add(myComment);
              likeCommentsPost.add(false.obs);
              showRepliesList.add(false.obs);
              currentLikeComment.add(myComment["comment_likes"]);
            }

            comments.refresh();
          } else {
            TLoaders.errorSnackBar(
                title: "Error", message: "Post has been deleted");
          }
        }
      } else {
        TLoaders.warningSnackBar(
            title: "Network", message: "Please Check your network");
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Server Error 404");
    }
    newComment.text = "";
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    isAddingCommnet.value = false;
  }

  @override
  likeDislikePostComment(int commentID, int commentIndex, int userID) async {
    if (likeCommentsPost[commentIndex].value) {
      likeCommentsPost[commentIndex].toggle();

      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/postcomment/commentlike/',
            {"id": commentID, "member": userID},
            0.0.obs);
      } catch (e) {
        print("error $e");
      }
    } else {
      likeCommentsPost[commentIndex].toggle().obs;
      try {
        await TDioHelper.post(
            'https://education15845d.pythonanywhere.com/postcomment/commentlike/',
            {"id": commentID, "member": userID},
            0.0.obs);
      } catch (e) {
        print("error $e");
      }
    }
  }

  @override
  addRepleyCommentPost(
      String memberFullName, int postID, int parentID, int userID) async {
    Get.bottomSheet(
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                  child: Text(
                'Reply',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd_XRGE9j0tQkvkYFKQU5MlZw86IXuV9TbfA&s"),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 1,
                      minLines: 1,
                      maxLength: 255,
                      buildCounter: (
                        BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) {
                        return null; // إخفاء العداد
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'''[!\$^*\\[\]{}|\\:;"\'<>/]'''),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: " Add a Reply to @$memberFullName ...",
                        hintStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 13),
                        border: InputBorder.none, // إزالة الحدود الأساسية
                        enabledBorder:
                            InputBorder.none, // إزالة الحدود عند التفعيل
                        focusedBorder: InputBorder.none,
                      ),
                      controller: newComment,
                    ),
                  )),
                  Obx(() => isAddingCommnet.value
                      ? const CircularProgressIndicator(
                          color: TColors.primary,
                        )
                      : InkWell(
                          onTap: () async {
                            await addComment(postID, parentID, userID);
                            Get.back();
                          },
                          child: const Icon(
                            Icons.send,
                            color: TColors.primary,
                          )))
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white);
  }

  @override
  String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)} M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} K';
    } else {
      return number.toString();
    }
  }
}
