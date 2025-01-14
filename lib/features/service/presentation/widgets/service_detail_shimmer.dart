import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TServiceDetailShimmer extends StatelessWidget {
  const TServiceDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer cho Carousel
          Stack(
            alignment: Alignment.center,
            children: [
              TShimmerEffect(
                width: double.infinity,
                height: THelperFunctions.screenHeight(context) * (1 / 3),
                radius: 0,
              ),
            ],
          ),
          const SizedBox(height: TSizes.md),
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TShimmerEffect(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: TSizes.shimmerSx,
                ),
                const SizedBox(height: TSizes.md),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TShimmerEffect(width: TSizes.shimmerLg, height: TSizes.shimmerSx),
                    TShimmerEffect(width: TSizes.shimmerSm, height: TSizes.shimmerSx),
                  ],
                ),
                const SizedBox(height: TSizes.sm),
                const TShimmerEffect(
                  width: double.infinity,
                  height: TSizes.shimmerLg,
                ),
                const SizedBox(height: TSizes.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
