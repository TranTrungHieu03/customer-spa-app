import 'package:flutter/material.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_vertical_card.dart';

class ServiceListView extends StatelessWidget {
  final List<ServiceModel> services;

  const ServiceListView({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Services Recommended",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: TColors.primary,
              ),
        ),
        const SizedBox(height: TSizes.sm),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
            itemBuilder: (context, index) {
              final service = services[index];
              return TServiceCard(service: service);
            },
          ),
        ),
      ],
    );
  }
}
