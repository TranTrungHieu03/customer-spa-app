import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class TPaymentDetailMix extends StatelessWidget {
  const TPaymentDetailMix({super.key, required this.total, this.promotePrice = 0, required this.priceProduct, required this.priceService});

  final double priceProduct;
  final double priceService;
  final double total;
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
            if (priceProduct > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Giá sản phẩm", style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: priceProduct.toString(),
                    isLarge: false,
                  )
                ],
              ),
            if (priceService > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Giá dịch vụ", style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: priceService.toString(),
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
                  price: total.toString(),
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
