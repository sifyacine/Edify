import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class BSheetAddHashtag extends StatelessWidget {
  final void Function()? addHashtag;
  final TextEditingController hashtagController;
  const BSheetAddHashtag(
      {super.key, required this.addHashtag, required this.hashtagController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Center(
            child: Text(
              'Add Hashtag',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: hashtagController,
            decoration: InputDecoration(
                labelText: 'add hashtag here',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: addHashtag,
            color: TColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
