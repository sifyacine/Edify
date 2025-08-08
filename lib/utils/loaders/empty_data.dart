import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyData extends StatelessWidget {
  final String empty;
  const EmptyData({super.key, required this.empty});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/images/animations/53207-empty-file.json'),
        Center(
          child: Text(
            empty,
            style: const TextStyle(fontFamily: "NotoSansArabic", fontSize: 18),
          ),
        )
      ],
    );
  }
}
