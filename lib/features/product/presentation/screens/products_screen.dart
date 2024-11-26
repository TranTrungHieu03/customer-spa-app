import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/categories.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_vertical_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TAppbar(
          title: Text(
            'Product',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .apply(color: TColors.black),
          ),
          actions: const [
            TRoundedIcon(
              icon: Iconsax.shopping_bag,
              size: 30,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Luxury of Skincare",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Curated for You",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: TSizes.sm,
                ),
                const SizedBox(height: 50, child: TCategories()),
                const SizedBox(
                  height: TSizes.spacebtwItems,
                ),
                // TProductBanner(
                //     itemBuilder: Container(
                //       decoration: BoxDecoration(
                //         color: TColors.lightGrey,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: TColors.primary, width: 1),
                //         boxShadow: [
                //           BoxShadow(
                //             color: TColors.primary.withOpacity(0.5),
                //             blurRadius: 10,
                //             offset: const Offset(0, 3),
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         children: [
                //           TRoundedImage(
                //             imageUrl:
                //                 "https://mfparis.vn/wp-content/uploads/2022/09/serum-la-roche-posay-pure-niacinamide-10-30ml.jpg",
                //             applyImageRadius: true,
                //             isNetworkImage: true,
                //             fit: BoxFit.contain,
                //             onPressed: () => {},
                //             width: MediaQuery.of(context).size.width * 0.5,
                //           ),
                //           const SizedBox(height: TSizes.spacebtwItems),
                //           ConstrainedBox(
                //             constraints: BoxConstraints(
                //               minWidth: MediaQuery.of(context).size.width * 0.7,
                //             ),
                //             child: const TProductTitleText(
                //               title:
                //                   'Green Nike Air Shoes Green Nike Air Shoes',
                //               smallSize: true,
                //               maxLines: 1,
                //             ),
                //           ),
                //           const TProductPriceText(price: '35.0'),
                //           SizedBox(
                //             width: TSizes.iconLg * 2,
                //             height: TSizes.iconLg * 2,
                //             child: Center(
                //               child: Icon(
                //                 Iconsax.add,
                //                 color: TColors.primary,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     itemCount: 4),
                const SizedBox(
                  height: TSizes.sm,
                ),
                TGridLayout(
                    crossAxisCount: 2,
                    itemCount: 6,
                    itemBuilder: (_, index) => const TProductCardVertical()),
              ],
            ),
          ),
        ));
  }
}
