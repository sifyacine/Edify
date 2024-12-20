import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'dart:math' as math;

class Rightpart extends StatelessWidget {
  final String shortComments;
  final String shortLikes;

  final void Function()? comment;
  final void Function()? share;
  final void Function()? save;
  final Widget? like;
  final String memerPhotoProfil;
  final Widget soundControl;
  const Rightpart(
      {super.key,
      required this.shortComments,
      required this.comment,
      required this.share,
      required this.save,
      required this.like,
      required this.shortLikes,
      required this.memerPhotoProfil,
      required this.soundControl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 20,
              child: Image.asset(
                memerPhotoProfil,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: -5,
                right: 10,
                child: Center(
                  child: LikeButton(
                    circleColor: const CircleColor(
                        start: Colors.white, end: TColors.primary),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,

                        color: isLiked
                            ? TColors.primary
                            : const Color.fromARGB(167, 255, 255,
                                255), // هنا نغير اللون إلى الأبيض
                      );
                    },
                    size: 20,
                  ),
                )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        like!,
        Text(shortLikes),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: comment,
          child: const Icon(Icons.comment, size: 30, color: Colors.white),
        ),
        Text(shortComments.toString()),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: save,
          child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
        ),
        const Text(
          'save ',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: share,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: const Icon(
              Icons.reply_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        const Text(
          'share ',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        soundControl
      ],
    );
  }
}
