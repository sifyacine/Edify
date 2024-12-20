import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomPartShortView extends StatelessWidget {
  final String title;
  final String memberFullName;
  final String memerPhotoProfil;
  const BottomPartShortView(
      {super.key,
      required this.title,
      required this.memberFullName,
      required this.memerPhotoProfil});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '@$memberFullName',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(136, 161, 159, 159)),
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
