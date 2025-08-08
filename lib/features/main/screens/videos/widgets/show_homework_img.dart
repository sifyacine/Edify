import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowHomework extends StatelessWidget {
  final String url;
  const ShowHomework({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: "https://education15845d.pythonanywhere.com$url",
            placeholder: (context, url) => Lottie.asset(
                "assets/images/animations/141397-loading-juggle.json"),
            errorWidget: (context, url, error) =>
                Lottie.asset("assets/images/animations/53207-empty-file.json"),
          )
        ],
      ),
    );
  }
}
