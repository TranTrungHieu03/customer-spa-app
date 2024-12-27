import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TProductBannerShimmer extends StatelessWidget {
  const TProductBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = THelperFunctions.screenWidth(context) * 0.6;
    return Container(
      width: width,
      padding: const EdgeInsets.all(TSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TShimmerEffect(width: width, height: TSizes.productHeight),
          const SizedBox(
            height: TSizes.sm,
          ),
          TShimmerEffect(width: width * 0.8, height: TSizes.shimmerSx),
          const SizedBox(
            height: TSizes.sm,
          ),
          TShimmerEffect(width: width * 0.5, height: TSizes.shimmerSx),
        ],
      ),
    );
  }
}
