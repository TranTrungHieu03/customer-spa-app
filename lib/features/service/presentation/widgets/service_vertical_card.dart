import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
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
      onTap: () => goServiceDetail(service.serviceId.toString()),
      child: TRoundedContainer(
        width: THelperFunctions.screenWidth(context) * 0.45,
        height: 200,
        radius: 10,
        child: Column(
          children: [
            TRoundedImage(
              applyImageRadius: true,
              imageUrl: TImages.thumbnailService,
              isNetworkImage: true,
              width: THelperFunctions.screenWidth(context) * 0.45,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: THelperFunctions.screenWidth(context) * 0.45,
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
    );
  }
}
