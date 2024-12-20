import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/screens/posts/post_widget.dart';
import 'package:edify/features/main/screens/shorts/add_short/widgets/add_hashtag.dart';
import 'package:edify/test_page_controller.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    TestPageControllerImp controller = Get.put(TestPageControllerImp());
    return Scaffold(
      body: Obx(() {
        if (controller.comments.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.comments.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.comments.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final comment = controller.comments[index];
            return ListTile(
              title: Text(comment['content']),
              subtitle: Text('Liked: ${comment['is_liked']}'),
            );
          },
        );
      }),
    );
  }
}
