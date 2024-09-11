import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: TColors.grey),
          borderRadius: BorderRadius.circular(100)),
      child: Image(
        width: TSizes.iconMd,
        height: TSizes.iconMd,
        image: AssetImage(
          image,
        ),
      ),
    );
  }
}
