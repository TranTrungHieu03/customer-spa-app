import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TBottomCheckoutService extends StatelessWidget {
  const TBottomCheckoutService({
    super.key,
    // required this.params,
    required this.onPressed,
    this.isValue = true,
  });

  // final CreateAppointmentParams params;
  final VoidCallback onPressed;
  final bool isValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
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
            ElevatedButton(
              onPressed: () {
                if (isValue){
                  onPressed();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                  backgroundColor: isValue ? TColors.primary : TColors.primary.withOpacity(0.4)
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
