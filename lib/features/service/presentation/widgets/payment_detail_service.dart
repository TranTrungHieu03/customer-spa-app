import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class TPaymentDetailService extends StatelessWidget {
  const TPaymentDetailService({super.key, required this.price, required this.total, this.promotePrice = 0});

  final String price;
  final String total;
  final double promotePrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.payment_details, style: Theme.of(context).textTheme.titleLarge),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.total_order_amount, style: Theme.of(context).textTheme.bodyMedium),
                TProductPriceText(
                  price: price,
                  isLarge: false,
                )
              ],
            ),
            if (promotePrice > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Phí giảm giá", style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: promotePrice.toString(),
                    isLarge: false,
                  )
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.total_payment, style: Theme.of(context).textTheme.labelLarge),
                TProductPriceText(
                  price: total,
                  isLarge: true,
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
