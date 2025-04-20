import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/constants/skin_analysis.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/skin_data.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({
    super.key,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: false,
        title: Text(AppLocalizations.of(context)!.analysis_result),
        actions: [
          TRoundedIcon(
              icon: Iconsax.home_2,
              onPressed: () {
                goHome();
                // context.read<SkinAnalysisBloc>().add(ResetSkinAnalysisEvent());
              })
        ],
      ),
      body: BlocConsumer<SkinAnalysisBloc, SkinAnalysisState>(
        listener: (context, state) {
          if (state is SkinAnalysisError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          AppLogger.debug("SkinAnalysisState: $state");
          if (state is SkinAnalysisLoading) {
            return const Center(child: TLoader());
          } else if (state is SkinAnalysisLoaded) {
            final routines = state.routines;
            AppLogger.debug(routines);
            final skinHealth = state.skinHealth;
            AppLogger.debug(skinHealth);
            return Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TRoundedContainer(
                          backgroundColor: Colors.greenAccent.shade200,
                          borderColor: TColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.sm),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.skin_condition.toUpperCase(),
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              TSkinData(
                                title: AppLocalizations.of(context)!.skin_type,
                                iconData: Iconsax.drop3,
                                iconColor: Colors.purple,
                                backgroundIconColor: Colors.purple.shade50,
                                value: SkinAnalysis.getSkinTypeName(context, skinHealth.skinType.skinType),
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              TSkinData(
                                title: AppLocalizations.of(context)!.skin_age,
                                iconData: Iconsax.battery_charging4,
                                iconColor: Colors.deepOrange,
                                backgroundIconColor: Colors.orange.shade50,
                                value: skinHealth.skinAge.value.toString(),
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              TSkinData(
                                title: AppLocalizations.of(context)!.skin_color,
                                iconData: Iconsax.blend,
                                iconColor: Colors.yellow.shade700,
                                backgroundIconColor: Colors.yellow.shade100,
                                value: SkinAnalysis.getSkinColorName(context, skinHealth.skinColor.value),
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              TSkinData(
                                title: AppLocalizations.of(context)!.acne,
                                iconData: Iconsax.bubble,
                                iconColor: Colors.white,
                                backgroundIconColor: Colors.grey.shade500,
                                value: "${skinHealth.acne.rectangle.length} ${AppLocalizations.of(context)!.zone}",
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              TSkinData(
                                title: AppLocalizations.of(context)!.mole,
                                iconData: Iconsax.story,
                                iconColor: Colors.blue,
                                backgroundIconColor: Colors.blue.shade100,
                                value: "${skinHealth.mole.rectangle.length} ${AppLocalizations.of(context)!.zone}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  Text(
                    AppLocalizations.of(context)!.please_visit_store,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          goFormData(skinHealth, true);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.editForm,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  (routines.isEmpty)
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_suitable_treatment,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      :
                      // Instead of ListView.separated, we use Column to display routine items
                      Column(
                          children: List.generate(routines.length, (index) {
                            final routine = routines[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => goRoutineDetail(routine.skincareRoutineId.toString()),
                                  child: TRoundedContainer(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(routine.description),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  formatMoney(routine.totalPrice.toString()),
                                                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            goRoutineDetail(routine.skincareRoutineId.toString());
                                          },
                                        ),
                                        const SizedBox(
                                          height: TSizes.md,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index < routines.length - 1) const SizedBox(height: TSizes.sm),
                              ],
                            );
                          }),
                        ),
                ],
              ),
            );
          } else if (state is SkinAnalysisError) {
            return const TErrorBody();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
