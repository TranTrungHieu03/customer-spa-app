import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TServiceHorizontalCardShimmer extends StatelessWidget {
  const TServiceHorizontalCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: THelperFunctions.screenWidth(context) * 0.9,
      height: 140,
      radius: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.45,
            height: 120,
            radius: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TShimmerEffect(
                  width: THelperFunctions.screenWidth(context) * 0.3,
                  height: 16,
                ),
                const SizedBox(height: 8),
                TShimmerEffect(
                  width: THelperFunctions.screenWidth(context) * 0.3,
                  height: 14,
                ),
                const SizedBox(height: 8),
                TShimmerEffect(
                  width: THelperFunctions.screenWidth(context) * 0.2,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
