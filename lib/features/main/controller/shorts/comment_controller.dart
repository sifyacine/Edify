import 'package:edify/features/personalization/controllers/user_controller.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/dio/dio_client.dart';
import 'package:edify/utils/helpers/network_manager.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get_rx/get_rx.dart';
import 'package:lottie/lottie.dart';

abstract class ShortCommnetController extends GetxController {
  getComments(int shortID);
  likeDeslikeComment(int commentID);
  addComment(int shortVideo);
  addReply(int parent, int commentIndex, BuildContext context);
  addReplyBottomSheet(int parent, String memberFullName, int commentIndex,
      BuildContext context);
  deleteComment(int commentID, bool isParent, int commentIndex, int memberID);
}

class ShortCommentControllerImp extends ShortCommnetController {
  int userID = 3;

  RxList comments = [].obs;
  List<RxBool> showRepliesList = [];
  RxBool isLoading = false.obs;
  RxBool isEndOfList = false.obs;
  RxBool isAddingCommnet = false.obs;
  RxBool isCommentLoading = false.obs;
  RxBool isCommentAdded = false.obs;
  TextEditingController newComment = TextEditingController();
  // reply
  TextEditingController repley = TextEditingController();
  RxBool isAddingReply = false.obs;
  // isDeleing comment
  RxBool isDeletingComment = false.obs;
  List<int> currentLikeComment = [];
  RxInt currentCommentPage = 1.obs;
  List<bool> likeCommentsShort = [];
  ScrollController scrollController = ScrollController();
  int shortID;
  ShortCommentControllerImp({required this.shortID});
  @override
  void onInit() async {
    await getComments(shortID);
    scrollController.addListener(onScroll);
    super.onInit();
  }

  void onScroll() async {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isEndOfList.value) {
      await getComments(shortID);
    }
  }

  @override
  getComments(int shortID) async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      if (isLoading.value || isEndOfList.value) return;
      isLoading.value = true;
      dio.Response response = await TDioHelper.post(
          "https://education15845d.pythonanywhere.com/shortvideocomment/read/",
          {
            "shortvideo": shortID,
            "user_id": userID,
            "page": currentCommentPage.value,
          },
          0.0.obs);
      print(response.statusCode);
      if (response.statusCode == 200) {
        List newComment = response.data['results']['message'];
        bool hasMore = response.data['next'] != null;
        comments.addAll(newComment);
        isEndOfList.value = !hasMore;
        if (hasMore) currentCommentPage.value++;
        comments.isNotEmpty
            ? likeCommentsShort = List.generate(
                comments.length, (index) => comments[index]["is_liked"])
            : [];
        showRepliesList = List.generate(comments.length, (index) => false.obs);
        comments.isNotEmpty
            ? currentLikeComment = List.generate(
                comments.length, (index) => comments[index]["comment_likes"])
            : [];
        showRepliesList = List.generate(comments.length, (index) => false.obs);
      } else if (response.statusCode == 400) {
        comments = [].obs;
        TLoaders.errorDialog(
          "Can't get comments",
        );
      } else {
        TLoaders.errorDialog("Server Error 404 , Please Try Again");
      }
    } else {
      TLoaders.customToast(
          message: "Check Your Network", duration: const Duration(seconds: 5));
    }
    isLoading.value = false;
    print(comments);

    print("الصفحة الحالية: ${currentCommentPage.value}");
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  likeDeslikeComment(int commentID) async {
    bool isConneccted =
        await NetworkManager.instance.isConnected(); // Check network connection
    if (isConneccted) {
      try {
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/shortvideocomment/like/",
            {
              "member": userID,
              "comment": commentID,
            },
            0.0.obs);
        print(response.statusCode);
      } catch (e) {}
    } else {
      TLoaders.customToast(
          message: "Check Your Network", duration: const Duration(seconds: 5));
    }
  }

  @override
  addComment(int shortVideo) async {
    if (newComment.text.isEmpty) {
      TLoaders.customToast(
          message: "Please add a comment",
          duration: const Duration(seconds: 5));
      return;
    }
    bool isConnetcted = await NetworkManager.instance.isConnected();
    if (isConnetcted) {
      try {
        isAddingCommnet.value = true;
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/shortvideocomment/create/",
            {
              "member": userID,
              "member_id": userID,
              "short_video": shortVideo,
              "content": newComment.text.trim(),
            },
            0.0.obs);
        print(response.statusCode);
        comments.add(response.data['message']);

        likeCommentsShort.add(false);
        currentLikeComment.add(0);
        comments.refresh();

        showRepliesList = List.generate(comments.length, (index) => false.obs);
        currentLikeComment = List.generate(
            comments.length, (index) => comments[index]["comment_likes"]);

        showRepliesList = List.generate(comments.length, (index) => false.obs);
        comments.refresh();
        likeCommentsShort.add(false);
        currentLikeComment.add(0);

        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        TLoaders.errorDialog("Can't add a comment , Please try again");
      }
    } else {
      TLoaders.customToast(
          message: "Check Your Network", duration: const Duration(seconds: 5));
    } // Check network connection
    newComment.clear();
    isCommentAdded.value = true;
    isAddingCommnet.value = false;
  }

  @override
  addReplyBottomSheet(int parent, String memberFullName, int commentIndex,
      BuildContext context) async {
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
                      maxLength: 250,
                      buildCounter: (
                        BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) {
                        return null; // إخفاء العداد
                      },
                      maxLines: 1,
                      minLines: 1,
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
                      controller: repley,
                    ),
                  )),
                  Obx(() => isAddingReply.value
                      ? const CircularProgressIndicator(
                          color: TColors.primary,
                        )
                      : InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            await addReply(parent, commentIndex, context);
                            // إخفاء لوحة المفاتيح
                            repley.clear();
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
  addReply(int parent, int commentIndex, BuildContext context) async {
    isAddingReply.value = true;
    bool isConnected = await NetworkManager.instance.isConnected();
    if (isConnected) {
      try {
        dio.Response response = await TDioHelper.post(
            "https://education15845d.pythonanywhere.com/shortvideocomment/create/",
            {
              "member": userID,
              "member_id": userID,
              "short_video": shortID,
              "content": repley.text.trim(),
              "parent": parent
            },
            0.0.obs);

        comments[commentIndex]["replies"].add(response.data["message"]);
        comments.refresh();
        showRepliesList[commentIndex].value = true;
        Get.back();
      } catch (e) {
        TLoaders.errorDialog("Some Thing worng please try again.");
      }
    } else {
      TLoaders.customToast(
          message: "No Internet", duration: const Duration(seconds: 3));
    }
    isAddingReply.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  deleteComment(
      int commentID, bool isParent, int commentIndex, int memberID) async {
    if (userID == memberID) {
      return Get.dialog(Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(() => isDeletingComment.value
                  ? Lottie.asset("assets/images/animations/loading3.json",
                      width: 100, height: 100)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Are you sure?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "NotoSansArabic",
                              fontSize: 20,
                              color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "You are about delete the comment!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "NotoSansArabic", fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "cancel",
                                  style: TextStyle(color: Colors.red),
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                isDeletingComment.value = true;
                                bool isConnected =
                                    await NetworkManager.instance.isConnected();
                                if (isConnected) {
                                  try {
                                    dio.Response response = await TDioHelper.post(
                                        "https://education15845d.pythonanywhere.com/shortvideocomment/delete/",
                                        {"id": commentID},
                                        0.0.obs);
                                    isParent
                                        ? comments.removeAt(commentIndex)
                                        : null;
                                    comments.refresh();
                                    Get.back();
                                  } catch (e) {
                                    TLoaders.errorDialog(
                                        "Some Thing worng please try again.");
                                  }
                                } else {
                                  TLoaders.customToast(
                                      message: "No Internet",
                                      duration: const Duration(seconds: 3));
                                }
                                isDeletingComment.value = false;
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )
                      ],
                    )))));
    }
  }
}
