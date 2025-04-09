import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TPaymentMethod extends StatefulWidget {
  const TPaymentMethod({
    super.key,
    required this.onChanged,
    this.initialMethod = 'payOs',
  });

  final String initialMethod;
  final Function(String method) onChanged;

  @override
  State<TPaymentMethod> createState() => _TPaymentMethodState();
}

class _TPaymentMethodState extends State<TPaymentMethod> {
  late String selectedMethod;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.initialMethod;
  }

  void _selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
    widget.onChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      radius: 10,
      padding: const EdgeInsets.all(TSizes.sm),
      borderColor: TColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.payment_method, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: TSizes.sm),

          /// Cash Option
          GestureDetector(
            onTap: () => _selectMethod('cash'),
            child: Row(
              children: [
                const Icon(Iconsax.money_send, color: TColors.primary),
                const SizedBox(width: TSizes.sm),
                Text(AppLocalizations.of(context)!.cash, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                if (selectedMethod == 'cash') const Icon(Iconsax.tick_circle, color: TColors.primary),
              ],
            ),
          ),

          const SizedBox(height: TSizes.sm),

          /// Bank Transfer Option
          GestureDetector(
            onTap: () => _selectMethod('payOs'),
            child: Row(
              children: [
                const Icon(Iconsax.wallet, color: TColors.primary),
                const SizedBox(width: TSizes.sm),
                Text(AppLocalizations.of(context)!.bank_transfer, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                if (selectedMethod == 'payOs') const Icon(Iconsax.tick_circle, color: TColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
