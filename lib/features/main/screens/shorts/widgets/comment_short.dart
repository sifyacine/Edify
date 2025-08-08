import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:edify/features/main/controller/shorts/comment_controller.dart';
import 'package:edify/features/main/screens/report/report.dart';
import 'package:edify/features/personalization/screens/edit_profile/edit_page.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../utils/dio/dio_client.dart';

class CommentShort extends StatelessWidget {
  final int shortId;
  const CommentShort({super.key, required this.shortId});

  @override
  Widget build(BuildContext context) {
    ShortCommentControllerImp controller =
        Get.put(ShortCommentControllerImp(shortID: shortId));
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Comments',
            style: TextStyle(fontFamily: "NotoSansArabic"),
          ),
        ),
        body: Obx(() => Column(children: [
              Expanded(
                  child: controller.isLoading.value
                      ? Lottie.asset("assets/images/animations/loading3.json",
                          width: 100, height: 100)
                      : controller.comments.isEmpty
                          ? const Center(
                              child: Text(
                                "No comments yet",
                                style: TextStyle(
                                    fontFamily: "NotoSansArabic",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                  controller: controller.scrollController,
                                  shrinkWrap: true,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(
                                            height: 10,
                                          ),
                                  itemCount: controller.comments.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    RxList comments = controller.comments;
                                    DateTime dateTime = DateTime.parse(
                                        controller.comments[i]['created_at']);
                                    return InkWell(
                                      onLongPress: controller.userID ==
                                              comments[i]["member"]['id']
                                          ? () async {
                                              await controller.deleteComment(
                                                  comments[i]['id'],
                                                  true,
                                                  i,
                                                  comments[i]["member"]['id']);
                                            }
                                          : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: controller.userID ==
                                                  comments[i]["member"]['id']
                                              ? const Color.fromARGB(
                                                  55, 154, 238, 172)
                                              : Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {},
                                                  child: const CircleAvatar(
                                                      radius: 16,
                                                      backgroundImage: NetworkImage(
                                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSZsINAeXhg_aONZrbZrMTZEjopaRJ1xmlVA&s")),
                                                ),
                                                Text(
                                                    " ${controller.comments[i]['member']['full_name'] ?? "Unknown"}",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "NotoSansArabic",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text(
                                                    "   ${timeago.format(dateTime, locale: 'en_short')}",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "NotoSansArabic",
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 138, 136, 136),
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        () =>
                                                            const SendReport(),
                                                        arguments: {
                                                          "member": controller
                                                                  .comments[i]
                                                              ['id'],
                                                          "userID":
                                                              controller.userID,
                                                          "type":
                                                              "short comment"
                                                        });
                                                  },
                                                  child: Icon(Icons.more_vert,
                                                      size: 18,
                                                      color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ReadMoreText(
                                                        "${controller.comments[i]['content']}",
                                                        trimLines: 2,
                                                        colorClickableText:
                                                            Colors.green,
                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText:
                                                            ' Show more',
                                                        trimExpandedText:
                                                            ' Show less',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "NotoSansArabic",
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Obx(() => controller
                                                        .comments[i]["replies"]
                                                        .isEmpty
                                                    ? Text(
                                                        controller.comments[i]
                                                                ['created_at']
                                                            .toString()
                                                            .substring(0, 10),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "NotoSansArabic",
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    138,
                                                                    136,
                                                                    136),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400))
                                                    : InkWell(
                                                        onTap: () {
                                                          controller
                                                              .showRepliesList[
                                                                  i]
                                                              .toggle();
                                                        },
                                                        child: Text(
                                                            !controller
                                                                    .showRepliesList[
                                                                        i]
                                                                    .value
                                                                ? "  ___ View ${controller.comments[i]["replies"].length} replies"
                                                                : "  ___ Hide ${controller.comments[i]["replies"].length} replies",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "NotoSansArabic",
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      )),
                                                InkWell(
                                                  onTap: () async {
                                                    controller
                                                        .addReplyBottomSheet(
                                                            comments[i]['id'],
                                                            comments[i]
                                                                    ["member"]
                                                                ["full_name"],
                                                            i,
                                                            context);
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      const Text('Reply',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansArabic",
                                                            color: Colors.grey,
                                                          )),
                                                      const Icon(
                                                        Icons.comment,
                                                        size: 19,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                LikeButton(
                                                  size: 20,
                                                  isLiked: controller
                                                      .likeCommentsShort[i],
                                                  likeCount: controller
                                                      .currentLikeComment[i],
                                                  likeCountPadding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  onTap: (isLiked) async {
                                                    await controller
                                                        .likeDeslikeComment(
                                                            controller
                                                                    .comments[i]
                                                                ['id']);
                                                    return !isLiked;
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Obx(
                                              () => controller
                                                      .showRepliesList[i].value
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              left: 25,
                                                              bottom: 10),
                                                      child: ShowCommentReplies(
                                                          i: i,
                                                          controller:
                                                              controller,
                                                          replies: controller
                                                                  .comments[i]
                                                              ["replies"]),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: Column(
                  children: [
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
                              hintText: " Add a comment ...",
                              hintStyle: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                              border: InputBorder.none, // إزالة الحدود الأساسية
                              enabledBorder:
                                  InputBorder.none, // إزالة الحدود عند التفعيل
                              focusedBorder: InputBorder.none,
                            ),
                            controller: controller.newComment,
                          ),
                        )),
                        Obx(() => controller.isAddingCommnet.value
                            ? const CircularProgressIndicator(
                                color: TColors.primary,
                              )
                            : InkWell(
                                onTap: () async {
                                  controller.addComment(
                                    controller.shortID,
                                  );
                                  FocusScope.of(context).unfocus();
                                },
                                child: const Icon(Icons.send)))
                      ],
                    ),
                  ],
                ),
              )
            ])));
  }
}

class ShowCommentReplies extends StatelessWidget {
  final int i;
  final List replies;
  final ShortCommentControllerImp controller;

  const ShowCommentReplies(
      {super.key,
      required this.i,
      required this.replies,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: replies.length,
        separatorBuilder: (BuildContext context, int i) => const SizedBox(
              height: 10,
            ),
        itemBuilder: (BuildContext context, int i) {
          DateTime dateTime = DateTime.parse(replies[i]['created_at']);
          return InkWell(
              onLongPress: controller.userID == replies[i]["member"]['id']
                  ? () async {
                      await controller.deleteComment(replies[i]['id'], false, i,
                          replies[i]["member"]['id']);
                      replies.removeAt(i);
                      controller.showRepliesList[i].value = false;
                      controller.comments.refresh();
                    }
                  : null,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSZsINAeXhg_aONZrbZrMTZEjopaRJ1xmlVA&s",
                        ),
                      ),
                      Text(
                        " ${replies[i]['member']['full_name'] ?? "Unknown"}",
                        style: const TextStyle(
                          fontFamily: "NotoSansArabic",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        timeago.format(dateTime),
                        style: const TextStyle(
                          fontFamily: "NotoSansArabic",
                          fontSize: 12,
                          color: Color.fromARGB(255, 138, 136, 136),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const SendReport(), arguments: {
                            "member": replies[i]['id'],
                            "userID": 2,
                            "type": "short comment"
                          });
                        },
                        child: Icon(Icons.more_vert,
                            size: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ReadMoreText(
                          "  ${replies[i]['content']}",
                          trimLines: 2,
                          colorClickableText:
                              const Color.fromARGB(255, 228, 16, 1),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style: const TextStyle(
                            fontFamily: "NotoSansArabic",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "  ${replies[i]["created_at"].toString().substring(0, 10)}",
                        style: const TextStyle(
                          fontFamily: "NotoSansArabic",
                          fontSize: 12,
                          color: Color.fromARGB(255, 138, 136, 136),
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                      const Spacer(),
                    ],
                  )
                ],
              ));
        });
  }
}
