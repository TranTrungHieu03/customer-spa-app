import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TOrderHorizontalShimmer extends StatelessWidget {
  const TOrderHorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: THelperFunctions.screenWidth(context) * 0.9,
      height: 140,
      radius: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.745,
            height: 16,
            radius: 10,
          ),
          const SizedBox(height: TSizes.sm),
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.3,
            height: 16,
          ),
          const SizedBox(height: TSizes.sm),
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.5,
            height: 14,
          ),
          const SizedBox(height: TSizes.md),
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.5,
            height: 16,
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TShimmerEffect(
                width: THelperFunctions.screenWidth(context) * 0.5,
                height: 16,
              ),
            ],
          )
        ],
      ),
    );
  }
}
