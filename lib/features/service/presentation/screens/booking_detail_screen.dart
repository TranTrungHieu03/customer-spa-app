import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.sm),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "09:10 09/10/2024",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              TRoundedContainer(
                shadow: true,
                padding: EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TRoundedImage(
                          applyImageRadius: true,
                          imageUrl: TImages.thumbnailService,
                          isNetworkImage: true,
                          width: THelperFunctions.screenWidth(context) * 0.2,
                          height: THelperFunctions.screenWidth(context) * 0.2,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: TSizes.sm,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      THelperFunctions.screenWidth(context) *
                                          0.4),
                              child: TProductTitleText(
                                title: "Service Name 1",
                                maxLines: 1,
                              ),
                            ),
                            Text("30 mins"),
                            Text("6-step process. Includes 10-min massage"),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              TRoundedContainer(
                shadow: true,
                padding: EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TRoundedImage(
                          applyImageRadius: true,
                          imageUrl: TImages.thumbnailService,
                          isNetworkImage: true,
                          width: THelperFunctions.screenWidth(context) * 0.2,
                          height: THelperFunctions.screenWidth(context) * 0.2,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: TSizes.sm,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      THelperFunctions.screenWidth(context) *
                                          0.4),
                              child: TProductTitleText(
                                title: "Service Name 1",
                                maxLines: 1,
                              ),
                            ),
                            Text("30 mins"),
                            Text("6-step process. Includes 10-min massage"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Staff name",
                      style: Theme.of(context).textTheme.titleLarge),
                  Text("Nguyễn Hiền")
                ],
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              TRoundedContainer(
                radius: 10,
                padding: const EdgeInsets.all(TSizes.sm),
                borderColor: TColors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.payment_details,
                        style: Theme.of(context).textTheme.titleMedium),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .total_order_amount,
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
              ),
              TextButton(onPressed: () {}, child: Text("Cancel"))
            ],
          ),
        ),
      ),
    );
  }
}