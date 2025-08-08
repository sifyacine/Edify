import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'dart:math' as math;

class Rightpart extends StatelessWidget {
  final String shortComments;
  final Widget shortLikes;

  final void Function()? comment;
  final void Function()? share;
  final Widget? save;
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
        CircleAvatar(
          radius: 20,
          child: Image.asset(
            memerPhotoProfil,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        like!,
        shortLikes,
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: comment,
          child: const Icon(Iconsax.message, size: 30, color: Colors.white),
        ),
        Text(
          shortComments.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        save!,
        const Text(
          ' save ',
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
              Iconsax.share,
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
