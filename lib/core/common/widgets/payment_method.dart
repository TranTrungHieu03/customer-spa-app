import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class TPaymentSelection extends StatefulWidget {
  const TPaymentSelection({
    required this.total,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.isDeposit,
  });

  final double total;
  final PaymentOption selectedOption;
  final bool isDeposit;
  final Function(PaymentOption) onOptionChanged; // Callback để báo về component cha

  @override
  _PaymentSelectionState createState() => _PaymentSelectionState();
}

class _PaymentSelectionState extends State<TPaymentSelection> {
  late PaymentOption _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  void _onOptionSelected(PaymentOption option) {
    setState(() {
      _selectedOption = option;
    });
    widget.onOptionChanged(option);
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
          Row(
            children: [
              const Icon(Iconsax.wallet, color: TColors.primary),
              const SizedBox(width: TSizes.sm),
              Text(AppLocalizations.of(context)!.bank_transfer),
              const Spacer(),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChoiceChip(
                label: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.fullPayment),
                    TProductPriceText(
                      price: widget.total.toString(),
                      isLarge: false,
                      color: _selectedOption == PaymentOption.full ? Colors.white : Colors.black,
                    )
                  ],
                ),
                selected: _selectedOption == PaymentOption.full,
                onSelected: (selected) => _onOptionSelected(PaymentOption.full),
                selectedColor: TColors.primary,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(TSizes.sm),
                labelStyle: TextStyle(color: _selectedOption == PaymentOption.full ? Colors.white : Colors.black),
              ),
              if (widget.isDeposit)
                ChoiceChip(
                  label: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.deposit30),
                      TProductPriceText(
                          price: (widget.total * 0.3).toString(),
                          isLarge: false,
                          color: _selectedOption == PaymentOption.deposit ? Colors.white : Colors.black)
                    ],
                  ),
                  selected: _selectedOption == PaymentOption.deposit,
                  onSelected: (selected) => _onOptionSelected(PaymentOption.deposit),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(TSizes.sm),
                  selectedColor: TColors.primary,
                  labelStyle: TextStyle(color: _selectedOption == PaymentOption.deposit ? Colors.white : Colors.black),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
