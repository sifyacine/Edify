import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class CompressFileView extends StatelessWidget {
  const CompressFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/animations/loading2.json'),
          Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                " ... يتم ضغط الفيديو الرجاء الانتظار ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'CairoPlay',
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
