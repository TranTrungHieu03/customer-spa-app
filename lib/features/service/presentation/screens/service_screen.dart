import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_categories.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_vertical_card.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Text(
          AppLocalizations.of(context)!.service,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TRoundedIcon(
            icon: Iconsax.ticket,
            onPressed: () => goServiceHistory(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () => goSearch(),
                  child: TRoundedContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.md),
                          child: Text(AppLocalizations.of(context)!.search,
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        TRoundedIcon(icon: Iconsax.search_favorite)
                      ],
                    ),
                  )),
              const SizedBox(
                height: TSizes.sm,
              ),
              Text(AppLocalizations.of(context)!.service_type,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: TSizes.sm,
              ),
              TServiceCategories(),
              const SizedBox(
                height: TSizes.sm,
              ),
              TGridLayout(
                  itemCount: 8,
                  crossAxisCount: 2,
                  itemBuilder: (context, index) {
                    return const TServiceCard();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
