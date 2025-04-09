import 'package:flutter/material.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class OutOfStockOverlay extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius? borderRadius;

  const OutOfStockOverlay({
    Key? key,
    required this.width,
    required this.height,
    this.text = 'Hết hàng',
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(TSizes.cardRadiusMd),
      child: Container(
        width: width,
        height: height,
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(TSizes.xs),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}