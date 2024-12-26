import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TServiceCardShimmer extends StatelessWidget {
  const TServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: THelperFunctions.screenWidth(context) * 0.45,
      height: 200,
      radius: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TShimmerEffect(
            width: THelperFunctions.screenWidth(context) * 0.45,
            height: 150,
            radius: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TShimmerEffect(
                  width: THelperFunctions.screenWidth(context) * 0.4,
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
