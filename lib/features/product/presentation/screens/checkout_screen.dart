import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/product_detail.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TAppbar(
          showBackArrow: true,
          title: Text(
            AppLocalizations.of(context)!.checkout,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace / 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TContactInformation(),
                SizedBox(
                  height: TSizes.md,
                ),
                TProductCheckout(),
                SizedBox(
                  height: TSizes.md,
                ),
                TPaymentMethod(),
                SizedBox(
                  height: TSizes.md,
                ),
                TPaymentDetail()
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TBottomCheckout());
  }
}

class TPaymentDetail extends StatelessWidget {
  const TPaymentDetail({
    super.key,
  });

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
                  const TProductPriceText(
                    price: "550",
                    isLarge: true,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.shipping_fee,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const TProductPriceText(
                    price: "50",
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
                  const TProductPriceText(
                    price: "500",
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

class TPaymentMethod extends StatelessWidget {
  const TPaymentMethod({
    super.key,
  });

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
          Text(AppLocalizations.of(context)!.payment_method,
              style: Theme.of(context).textTheme.bodyLarge),
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.money_send,
                    color: TColors.primary,
                  ),
                  const SizedBox(
                    width: TSizes.sm,
                  ),
                  Text(AppLocalizations.of(context)!.cash,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  const Icon(
                    Iconsax.tick_circle,
                    color: TColors.primary,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Row(
                children: [
                  const Icon(
                    Iconsax.wallet,
                    color: TColors.primary,
                  ),
                  const SizedBox(
                    width: TSizes.sm,
                  ),
                  Text(AppLocalizations.of(context)!.bank_transfer,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  // const TRoundedIcon(
                  //   icon: Iconsax.tick_circle,
                  //   color: TColors.primary,
                  // ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class TContactInformation extends StatelessWidget {
  const TContactInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.sm, vertical: TSizes.md * 2 / 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0.2,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: THelperFunctions.screenWidth(context) * 0.5,
                    ),
                    child: Text(
                      "Tran Trung Hieu",
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: THelperFunctions.screenWidth(context) * 0.3,
                    child: Text(
                      "0837 394 311",
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: THelperFunctions.screenWidth(context) * 0.8,
                child: Text(
                  "147 Hoang Huu Nam, Tan Phu, Thu Duc, HCM",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
          ),
          TRoundedIcon(
            icon: Iconsax.edit,
            width: 30,
            size: 20,
            height: 30,
            onPressed: () {
              goShipmentInfo();
            },
          )
        ],
      ),
    );
  }
}

class TBottomCheckout extends StatelessWidget {
  const TBottomCheckout({
    super.key,
  });

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
            const TProductPriceText(price: "5000"),
            const SizedBox(width: TSizes.md),
            ElevatedButton(
              onPressed: () {},
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

class TProductCheckout extends StatelessWidget {
  const TProductCheckout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.sm, vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0.2,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.shop),
              const SizedBox(
                width: TSizes.spacebtwItems / 2,
              ),
              Text(
                "Innisfree",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          SizedBox(
              width: THelperFunctions.screenWidth(context),
              child: const Divider(
                thickness: 0.2,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TRoundedImage(
                imageUrl: TImages.product3,
                applyImageRadius: true,
                isNetworkImage: true,
                onPressed: () => {},
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
                width: THelperFunctions.screenWidth(context) * 0.28,
              ),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TProductTitleText(
                        title: TProductDetail.name,
                        maxLines: 2,
                        smallSize: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TProductPriceText(
                            price: TProductDetail.price,
                            currencySign: '\₫',
                          ),
                          Text(
                            "x1",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.shop_voucher,
                  style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context)!.select_or_enter_code,
                          style: Theme.of(context).textTheme.bodySmall),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.message_to_shop,
                  style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context)!.leave_a_message,
                          style: Theme.of(context).textTheme.bodySmall),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.shipping_carrier,
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Giao hàng nhanh",
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.total_amount,
                  style: Theme.of(context).textTheme.bodyMedium),
              const TProductPriceText(
                price: "550",
              )
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
        ],
      ),
    );
  }
}
