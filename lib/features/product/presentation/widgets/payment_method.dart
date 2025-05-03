import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TPaymentMethod extends StatefulWidget {
  const TPaymentMethod({
    super.key,
    required this.onChanged,
    this.initialMethod = 'PayOs',
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
      width: THelperFunctions.screenWidth(context),
      borderColor: TColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.payment_method,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: TSizes.sm),
          Wrap(
            spacing: TSizes.md,
            runSpacing: TSizes.md,
            children: [
              _buildChip(
                icon: Iconsax.money_send,
                label: AppLocalizations.of(context)!.cash,
                method: 'Cash',
              ),
              _buildChip(
                icon: Iconsax.wallet,
                label: AppLocalizations.of(context)!.bank_transfer,
                method: 'PayOs',
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String label, required String method}) {
    final bool isSelected = selectedMethod == method;

    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => _selectMethod(method),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : TColors.primary, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : TColors.primary,
      ),
      selectedColor: TColors.primary,
      backgroundColor: TColors.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: TColors.primary),
      ),
    );
  }
}
