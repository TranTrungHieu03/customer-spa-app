import 'package:flutter/material.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_card_routine.dart';

class ProductOrderListView extends StatelessWidget {
  final RoutineStepModel data;

  const ProductOrderListView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sản phẩm (${data.productRoutineSteps.length})", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          color: Colors.white,
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: data.productRoutineSteps.length,
            separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                child: TProductCardRoutine(
                  productModel: data.orderDetails![index].product!,
                  width: THelperFunctions.screenWidth(context) * 0.45,
                  status: data.orderDetails![index].status.toLowerCase(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
