import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class TBottomCheckoutService extends StatelessWidget {
  const TBottomCheckoutService({
    super.key,
    required this.price,
    // required this.params,
    required this.onPressed,
  });

  // final CreateAppointmentParams params;
  final VoidCallback onPressed;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm, vertical: TSizes.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.totalPayment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              width: TSizes.sm / 2,
            ),
            TProductPriceText(price: price),
            const SizedBox(width: TSizes.md),
            ElevatedButton(
              onPressed: () {
                onPressed();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.md, vertical: 10),
              ),
              child: Text(
                AppLocalizations.of(context)!.order,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: TSizes.md,
                    ),
              ),
            ),
          ],
        ));
  }
}
