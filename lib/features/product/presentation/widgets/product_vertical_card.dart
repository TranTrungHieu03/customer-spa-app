import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/styles/shadow_styles.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/out_of_stock_overlay.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.productModel, required this.width});

  final double width;
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = PurchasingData.of(context);

    return GestureDetector(
      child: Container(
        width: width + 10,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkerGrey : TColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TRoundedContainer(
            //   height: TSizes.productHeight,
            //   width: width + 15,
            //   padding: const EdgeInsets.all(TSizes.sm),
            //   backgroundColor: dark ? TColors.dark : TColors.light,
            //   child: Stack(
            //     children: [
            //       TRoundedImage(
            //         width: width,
            //         imageUrl: productModel.images!.isNotEmpty ? productModel.images![0] : TImages.product1,
            //         applyImageRadius: true,
            //         isNetworkImage: productModel.images!.isNotEmpty,
            //         fit: BoxFit.contain,
            //       ),
            //       // Positioned(
            //       //   top: 12,
            //       //   child: TRoundedContainer(
            //       //     radius: TSizes.sm,
            //       //     backgroundColor: TColors.secondary.withOpacity(0.8),
            //       //     padding: const EdgeInsets.symmetric(
            //       //         horizontal: TSizes.sm, vertical: TSizes.xs),
            //       //     child: Text(
            //       //       productModel.discount.toString() + "%",
            //       //       style: Theme.of(context)
            //       //           .textTheme
            //       //           .labelLarge!
            //       //           .apply(color: TColors.black),
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
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
                  // Add the out of stock overlay when stock is 0
                  if (productModel.stockQuantity <= 0)
                    Positioned.fill(
                      child: OutOfStockOverlay(
                        width: width + 15,
                        height: TSizes.productHeight,
                        text: 'Hết hàng',
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.spacebtwItems / 2,
            ),

            //details

            GestureDetector(
              onTap: () => goProductDetail(productModel.productBranchId, controller),
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
                        const SizedBox(
                          height: TSizes.spacebtwItems / 2,
                        ),
                        // TBrandTitleWithVerifiedIcon(title: 'Nike'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Price
                Padding(
                  padding: const EdgeInsets.all(TSizes.xs),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.85), child: TProductPriceText(price: productModel.price.toString())),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: (state is CartLoading || productModel.stockQuantity == 0) ? TColors.primaryBackground : TColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(TSizes.cardRadiusMd),
                          bottomRight: Radius.circular(TSizes.productImageRadius),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: productModel.stockQuantity > 0
                            ? () {
                                context.read<CartBloc>().add(AddProductToCartEvent(
                                    params: AddProductCartParams(
                                        userId: 0, productId: productModel.productBranchId, quantity: 1, operation: 0)));
                              }
                            : null,
                        child: const SizedBox(
                          width: TSizes.iconLg * 1.2,
                          height: TSizes.iconLg * 1.2,
                          child: Center(
                            child: Icon(
                              Iconsax.add,
                              color: TColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
