import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class TPaymentDetailService extends StatelessWidget {
  const TPaymentDetailService(
      {super.key,
      required this.price,
      required this.tips,
      required this.total});

  final String price;
  final String tips;
  final String total;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      radius: 10,
      padding: const EdgeInsets.all(TSizes.sm),
      borderColor: TColors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.payment_details,
              style: Theme.of(context).textTheme.bodyLarge),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.total_order_amount,
                      style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: price,
                    isLarge: true,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Tips", style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: tips,
                    isLarge: true,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.total_payment,
                      style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: total,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
