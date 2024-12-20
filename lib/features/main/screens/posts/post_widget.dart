import 'package:cached_network_image/cached_network_image.dart';

import 'package:edify/features/main/screens/posts/show_post_image.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:readmore/readmore.dart';
import 'dart:math' as math;

class PostView extends StatelessWidget {
  final String memberPic;
  final String memberFullName;
  final void Function()? onTapFollow;
  final String postTime;
  final void Function()? onTapRemovePost;
  final String postTitle;
  final String likesNumber;
  final String commentsNumber;
  final Widget likeWidget;
  final void Function()? onTapComment;
  final Widget? viewCommentsOntap;

  final Widget? onTapSave;
  final void Function()? onTapShare;

  final void Function()? onTapLikes;
  final void Function()? postReport;

  final List images;

  const PostView(
      {super.key,
      required this.postReport,
      required this.memberPic,
      required this.memberFullName,
      this.onTapFollow,
      required this.postTime,
      this.onTapRemovePost,
      required this.postTitle,
      required this.likesNumber,
      required this.commentsNumber,
      required this.likeWidget,
      this.onTapComment,
      this.onTapSave,
      this.onTapShare,
      required this.images,
      this.onTapLikes,
      this.viewCommentsOntap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(memberPic),
              radius: 20.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        memberFullName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: onTapFollow,
                          child: const Text(
                            'Follow',
                            style: TextStyle(color: Colors.purple),
                          ))
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    postTime,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: postReport,
              child: InkWell(
                  onTap: postReport,
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                    size: 20,
                  )),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReadMoreText(
              postTitle,
              trimLines: 2, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Read More',
              trimExpandedText: 'Read Less',
              style: const TextStyle(color: Colors.black),
              moreStyle: const TextStyle(color: TColors.primary),
              lessStyle:
                  const TextStyle(color: Color.fromARGB(255, 173, 172, 172)),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        images.isEmpty
            ? Container()
            : SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width / 1.5,
                child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, i) => Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => ShowPostImage(
                                    urlImage:
                                        "https://education15845d.pythonanywhere.com${images[i]["image"]}"));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://education15845d.pythonanywhere.com${images[i]['image']}",
                                  placeholder: (context, url) => Center(
                                    child: Lottie.asset(
                                        'assets/images/animations/141397-loading-juggle.json'),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: Get.width / 1.5,

                                  // لضبط شكل الصورة في العنصر
                                ),
                              ),
                            ),
                            images.length == 1
                                ? Container()
                                : Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            const Color.fromARGB(136, 0, 0, 0),
                                      ),
                                      child: Text(
                                        "${i + 1} / ${images.length}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )),
                          ],
                        )),
              ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(onTap: onTapLikes, child: Text('$likesNumber likes')),
              InkWell(
                onTap: onTapComment,
                child: Text("$commentsNumber comments"),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [likeWidget, const Text('Like')],
            ),
            viewCommentsOntap!,
            Row(
              children: [onTapSave!, const Text(' Save')],
            ),
            Row(
              children: [
                InkWell(
                  onTap: onTapShare,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: const Icon(
                      Icons.reply_rounded,
                    ),
                  ),
                ),
                const Text(' Share')
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
