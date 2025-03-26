import 'package:flutter/material.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_card_routine.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sản phẩm (${products.length})", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          color: Colors.white,
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                child: TProductCardRoutine(
                  productModel: product,
                  width: THelperFunctions.screenWidth(context) * 0.45,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
