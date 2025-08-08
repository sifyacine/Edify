import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class ShowPostImage extends StatelessWidget {
  final String urlImage;
  const ShowPostImage({super.key, required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: urlImage,
              placeholder: (context, url) => Center(
                child: Lottie.asset(
                    'assets/images/animations/141397-loading-juggle.json'),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,

              // لضبط شكل الصورة في العنصر
            ),
          ),
          Positioned(
              top: 25,
              right: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Iconsax.close_circle,
                  color: Colors.white,
                  size: 35,
                ),
              )),
        ]));
  }
}
