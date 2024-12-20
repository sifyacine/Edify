import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewComments extends StatelessWidget {
  const ViewComments({
    super.key,
    required this.commentsNumber,
    required this.memberPic,
    required this.memberFullName,
    required this.content,
    this.repley,
    required this.commentLike,
    required this.repliesNumber,
    required this.showReply,
    required this.replies,
    required this.i,
    required this.showRepliesList,
    required this.commentlike,
    required this.commentReport,
    required this.commentTime,
  });
  final String commentsNumber;
  final void Function()? commentReport;
  final String memberPic;
  final String memberFullName;
  final String content;
  final void Function()? repley;
  final DateTime commentTime;
  final RxBool showReply;
  final Widget commentLike;
  final List replies;
  final int i;
  final List<RxBool> showRepliesList;
  final int repliesNumber;
  final String commentlike;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      child: Image.asset(memberPic, fit: BoxFit.fill),
                    ),
                    Text(
                      '  @$memberFullName',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                InkWell(
                  onTap: commentReport,
                  child: InkWell(
                      onTap: commentReport,
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 20,
                      )),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Text("   $content"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "  ${timeago.format(commentTime, locale: 'en')}",
                  style: TextStyle(color: Colors.grey[500]),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: repley,
                        icon: const Icon(Icons.comment_outlined, size: 18)),
                    const Text(' Repley'),
                  ],
                ),
                Row(
                  children: [
                    commentLike,
                    Text(commentlike),
                  ],
                ),
              ],
            ),
            repliesNumber > 0
                ? InkWell(
                    onTap: () {
                      showRepliesList[i].toggle();
                    },
                    child: Row(
                      children: [
                        Text('   _________ View ${repliesNumber.toString()} ▼')
                      ],
                    ),
                  )
                : Container(),
            // repley ----------------------------------------------------------------
            Obx(() => showReply.value && repliesNumber > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (context, indexReplies) {
                      DateTime repleyTime =
                          DateTime.parse(replies[indexReplies]['created_at']);
                      return Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: Get.width / 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        child: Image.asset(
                                            'assets/logos/google-icon.png',
                                            fit: BoxFit.fill),
                                      ),
                                      Text(
                                        '  @${replies[indexReplies]['member']['full_name']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                      onTap: commentReport,
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                              SizedBox(
                                width: Get.width,
                                child: ReadMoreText(
                                  "  ${replies[indexReplies]['content']}",
                                  trimLines:
                                      2, // عدد الأسطر قبل ظهور زر "قراءة المزيد"
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Read More',
                                  trimExpandedText: 'Read Less',

                                  moreStyle:
                                      const TextStyle(color: TColors.primary),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "  ${timeago.format(repleyTime, locale: 'en')}",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              )
                            ],
                          ));
                    })
                : Container()),
          ],
        ));
  }
}
