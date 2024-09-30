import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/device/device_utility.dart';

class TRatingprogressIndicator extends StatelessWidget {
  const TRatingprogressIndicator({
    super.key,
    required this.text,
    required this.value,
    required this.stars,
  });

  final String text;
  final double value;
  final double stars;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            width: TDeviceUtils.getScreenWidth(context) * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: TColors.grey,
              valueColor: const AlwaysStoppedAnimation(TColors.primary),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                RatingBarIndicator(
                  rating: stars,
                  itemSize: 16,
                  itemBuilder: (_, __) => const Icon(
                    Iconsax.star1,
                    color: TColors.primary,
                  ),
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
      ],
    );
  }
}
