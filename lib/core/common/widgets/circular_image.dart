import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover, // Default to BoxFit.cover
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
  });

  final BoxFit fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white),
        shape: BoxShape.circle, // Ensures the container is circular
      ),
      child: ClipOval(
        child: isNetworkImage
            ? CachedNetworkImage(
                imageUrl: image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: fit,
                      colorFilter: overlayColor != null ? ColorFilter.mode(overlayColor!, BlendMode.srcATop) : null,
                    ),
                  ),
                ),
                placeholder: (context, url) => TShimmerEffect(width: width, height: height),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Image.asset(
                image,
                fit: fit,
                width: width,
                height: height,
                color: overlayColor,
              ),
      ),
    );
  }
}
