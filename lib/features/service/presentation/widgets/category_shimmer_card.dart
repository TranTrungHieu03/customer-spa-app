import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TCategoryShimmerCard extends StatelessWidget {
  const TCategoryShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(width: TSizes.xs),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                constraints: const BoxConstraints(minWidth: 80),
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.md,
                  vertical: TSizes.sm / 2,
                ),
                child: const TShimmerEffect(
                  width: TSizes.shimmerMd,
                  height: TSizes.shimmerSx,
                ),
              );
            }));
  }
}
