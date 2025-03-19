import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class TServiceCard extends StatelessWidget {
  final ServiceModel service;

  const TServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => goServiceDetail(service.serviceId),
      child: TRoundedContainer(
        width: THelperFunctions.screenWidth(context) * 0.45,
        height: 150,
        radius: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TRoundedImage(
              applyImageRadius: true,
              imageUrl: service.images.isNotEmpty ? service.images[0] : TImages.thumbnailService,
              isNetworkImage: service.images.isNotEmpty,
              width: THelperFunctions.screenWidth(context) * 0.45,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (service.serviceCategory != null)
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: THelperFunctions.screenWidth(context) * 0.44,
                              ),
                              child: TRoundedContainer(
                                padding: EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xs * 0.5),
                                backgroundColor: TColors.primary,
                                child: Text(
                                  service.serviceCategory?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                  maxLines: 1,
                                ),
                              )),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: THelperFunctions.screenWidth(context) * 0.44,
                            ),
                            child: TProductTitleText(
                              title: service.name,
                              smallSize: true,
                              maxLines: 2,
                            )),
                        TProductPriceText(price: service.price.toString())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
