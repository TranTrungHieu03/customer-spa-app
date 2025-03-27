import 'package:flutter/material.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_card_routine.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class ServiceListView extends StatelessWidget {
  final List<ServiceModel> services;

  const ServiceListView({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dịch vụ (${services.length})", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          margin: const EdgeInsets.symmetric(vertical: TSizes.xs),
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
            itemBuilder: (context, index) {
              final service = services[index];
              return TServiceCardRoutine(service: service);
            },
          ),
        ),
      ],
    );
  }
}
