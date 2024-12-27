import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TProductCardShimmer extends StatelessWidget {
  const TProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = THelperFunctions.screenWidth(context) * 0.4;
    return Container(
      width: width,
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TShimmerEffect(width: width + 15, height: TSizes.productHeight),
          const SizedBox(
            height: TSizes.sm,
          ),
          TShimmerEffect(width: width, height: TSizes.shimmerSx),
          const SizedBox(
            height: TSizes.sm,
          ),
          TShimmerEffect(width: width / 2, height: TSizes.shimmerSx),
        ],
      ),
    );
  }
}
