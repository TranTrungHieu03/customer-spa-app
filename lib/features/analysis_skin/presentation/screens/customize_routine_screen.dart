import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class CustomizeRoutineScreen extends StatefulWidget {
  const CustomizeRoutineScreen({super.key, required this.controller});

  final MixDataController controller;

  @override
  State<CustomizeRoutineScreen> createState() => _CustomizeRoutineScreenState();
}

class _CustomizeRoutineScreenState extends State<CustomizeRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    final branch = widget.controller.branch;
    final listProduct = widget.controller.productQuantities;
    final listService = widget.controller.services;
    var isAuto = widget.controller.isAuto;
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customize Your Routine",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.md),
              TRoundedContainer(
                padding: EdgeInsets.all(TSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.building,
                      color: TColors.primary,
                    ),
                    const SizedBox(
                      width: TSizes.sm,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branch?.branchName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          branch?.branchAddress ?? "",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listProduct.length,
                itemBuilder: (context, itemIndex) {
                  final cartItem = listProduct[itemIndex];
                  return TProductItem(
                    product: cartItem.product,
                    quantity: cartItem.quantity,
                    onToggleSelection: (quantity) {
                      widget.controller.updateProductQuantityItem(itemIndex, quantity);
                    },
                  );
                },
              ),
              const SizedBox(height: TSizes.sm),
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Chọn nhân viên sau',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: true,
                groupValue: isAuto,
                onChanged: (value) {
                  setState(() {
                    isAuto = value ?? true;
                    widget.controller.isAuto = value!;
                  });
                  widget.controller.updateAuto(value!);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Chọn nhân viên cho từng dịch vụ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: false,
                groupValue: isAuto,
                onChanged: (value) {
                  setState(() {
                    isAuto = value ?? false;
                    widget.controller.isAuto = value!;
                  });
                  if (value == false) {
                    goUpdateStaffMix(widget.controller, widget.controller.branchId);
                  }
                  widget.controller.updateAuto(value!);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: TSizes.sm),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listService.length,
                itemBuilder: (context, index) {
                  final service = listService[index];
                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm / 2, vertical: TSizes.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TRoundedImage(
                            imageUrl: service.images!.isNotEmpty ? service.images![0] : TImages.product1,
                            applyImageRadius: true,
                            isNetworkImage: service.images!.isNotEmpty,
                            fit: BoxFit.cover,
                            onPressed: () => {},
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                            width: THelperFunctions.screenWidth(context) * 0.28,
                            height: THelperFunctions.screenWidth(context) * 0.28,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: THelperFunctions.screenWidth(context) * 0.5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TProductTitleText(
                                    title: service.name,
                                    maxLines: 2,
                                    smallSize: true,
                                  ),
                                  TProductPriceText(
                                    price: service.price.toString(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        final totalPrice = widget.controller.productQuantities.fold(0.0, (a, b) => a + b.quantity * b.product.price) +
                            widget.controller.services.fold(0.0, (a, b) => a + b.price);
                        widget.controller.updateTotalPrice(totalPrice);
                        goReviewChangeRoutine(widget.controller);
                      },
                      child: Text(AppLocalizations.of(context)!.continue_book))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TProductItem extends StatefulWidget {
  final ProductModel product;
  final int quantity;

  final Function(int) onToggleSelection;

  const TProductItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.onToggleSelection,
  });

  @override
  _TProductItemState createState() => _TProductItemState();
}

class _TProductItemState extends State<TProductItem> {
  late TextEditingController _quantityController;
  Timer? _debounce;
  late int quantity;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.quantity.toString());
    quantity = widget.quantity;
    _quantityController.addListener(() {
      setState(() {
        quantity = int.tryParse(_quantityController.text) ?? 1;
      });
    });
  }

  //
  @override
  void didUpdateWidget(TProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity && widget.quantity != quantity) {
      quantity = widget.quantity;
      _quantityController.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _incrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity < widget.product.stockQuantity) {
      setState(() {
        currentQuantity++;
        _quantityController.text = currentQuantity.toString();
        quantity = currentQuantity;
      });
      onChangeQuantity();
    } else {
      TSnackBar.warningSnackBar(context,
          message: "${AppLocalizations.of(context)!.quantity_limit_exceeded} ${widget.product.stockQuantity}");
    }
  }

  void _decrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity > 1) {
      setState(() {
        currentQuantity--;
        _quantityController.text = currentQuantity.toString();
        quantity = currentQuantity;
      });

      onChangeQuantity();
    } else {
      TSnackBar.warningSnackBar(context, message: AppLocalizations.of(context)!.confirm_delete_product);
    }
  }

  void onChangeQuantity() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _saveQuantity();
      widget.onToggleSelection(quantity);
    });
  }

  void _saveQuantity() {
    final newQuantity = int.tryParse(_quantityController.text) ?? quantity;
    if (newQuantity > 0 && newQuantity < 1000) {
      setState(() {
        quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm / 2, vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox for item selection

          TRoundedImage(
            imageUrl: widget.product.images!.isNotEmpty ? widget.product.images![0] : TImages.product1,
            applyImageRadius: true,
            isNetworkImage: widget.product.images!.isNotEmpty,
            fit: BoxFit.cover,
            onPressed: () => {},
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            width: THelperFunctions.screenWidth(context) * 0.28,
            height: THelperFunctions.screenWidth(context) * 0.28,
          ),
          Padding(
            padding: const EdgeInsets.only(left: TSizes.sm),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: THelperFunctions.screenWidth(context) * 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  TProductTitleText(
                    title: widget.product.productName,
                    maxLines: 2,
                    smallSize: true,
                  ),
                  // Product price
                  TProductPriceText(
                    price: widget.product.price.toString(),
                  ),
                  const SizedBox(height: TSizes.spacebtwItems / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decrement button
                      GestureDetector(
                        onTap: int.parse(_quantityController.text) > 0 ? _decrementQuantity : null,
                        child: TRoundedIcon(
                          icon: Iconsax.minus,
                          backgroundColor: TColors.primary.withOpacity(0.05),
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: TSizes.sm / 2),
                      // Quantity input
                      SizedBox(
                        width: THelperFunctions.screenWidth(context) * 0.15,
                        height: THelperFunctions.screenWidth(context) * 0.1,
                        child: TextFormField(
                          controller: _quantityController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(TSizes.sm),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Validate input doesn't exceed stock quantity
                              int parsedValue = int.tryParse(value) ?? 0;
                              if (parsedValue > widget.product.stockQuantity) {
                                TSnackBar.warningSnackBar(context,
                                    message: "${AppLocalizations.of(context)!.quantity_limit_exceeded} ${widget.product.stockQuantity}");
                                _quantityController.text = widget.product.stockQuantity.toString();

                                parsedValue = widget.product.stockQuantity;
                              }
                              onChangeQuantity();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm / 2),
                      // Increment button
                      GestureDetector(
                        onTap: int.parse(_quantityController.text) < widget.product.stockQuantity ? _incrementQuantity : () {},
                        child: TRoundedIcon(
                          icon: Iconsax.add,
                          width: 40,
                          backgroundColor: TColors.primary.withOpacity(0.05),
                          height: 40,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
