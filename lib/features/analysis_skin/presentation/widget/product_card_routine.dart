import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/styles/shadow_styles.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class TProductCardRoutine extends StatelessWidget {
  const TProductCardRoutine({super.key, required this.productModel, required this.width, this.status});

  final double width;
  final ProductModel productModel;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      child: Container(
        width: width + 19,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkerGrey : TColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TRoundedContainer(
              height: TSizes.productHeight,
              width: width + 15,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  TRoundedImage(
                    width: width,
                    imageUrl: productModel.images!.isNotEmpty ? productModel.images![0] : TImages.product1,
                    applyImageRadius: true,
                    isNetworkImage: productModel.images!.isNotEmpty,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.spacebtwItems / 2,
            ),

            //details

            GestureDetector(
              // onTap: () => goProductDetail(productModel.productId),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: width,
                          ),
                          child: TProductTitleText(
                            title: productModel.productName,
                            smallSize: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.md,
            ),
            if (status != null)
              Align(
                alignment: Alignment.centerRight,
                child: TRoundedContainer(
                    padding: EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xs * 0.5),
                    backgroundColor: TColors.primaryBackground,
                    child: Text(
                      '${status == "pending" ? "Chưa nhận" : status == "completed" ? 'Da nhan' : "Dang cho"}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 1,
                    )),
              )
          ],
        ),
      ),
    );
  }
}
