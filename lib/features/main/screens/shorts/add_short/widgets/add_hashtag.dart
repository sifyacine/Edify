import 'package:flutter/material.dart';

class AddHashtags extends StatelessWidget {
  const AddHashtags({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.manage_search_sharp,
          color: Colors.purple,
        ),
        Text(' Add Hashtags', style: TextStyle(fontSize: 15))
      ],
    );
  }
}
