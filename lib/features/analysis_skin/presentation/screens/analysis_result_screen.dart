import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/constants/skin_analysis.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_routine.dart';
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
        showBackArrow: true,
        title: Text(AppLocalizations.of(context)!.analysis_result),
      ),
      body: BlocConsumer<SkinAnalysisBloc, SkinAnalysisState>(
        listener: (context, state) {
          if (state is SkinAnalysisError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is SkinAnalysisLoading) {
            const TLoader();
          } else if (state is SkinAnalysisLoaded) {
            final routines = state.routines;
            final skinHealth = state.skinHealth;
            return Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: SingleChildScrollView(
                child: Column(
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
                                // TSkinData(
                                //   title: "General skin health",
                                //   iconData: Iconsax.gemini,
                                //   iconColor: TColors.primary,
                                //   backgroundIconColor: Colors.greenAccent.shade100,
                                //   value: "80%",
                                // ),
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
                                  value: skinHealth.acne.rectangle.length.toString() + (" ") + AppLocalizations.of(context)!.zone,
                                ),
                                const SizedBox(
                                  height: TSizes.sm,
                                ),
                                TSkinData(
                                  title: AppLocalizations.of(context)!.mole,
                                  iconData: Iconsax.story,
                                  iconColor: Colors.blue,
                                  backgroundIconColor: Colors.blue.shade100,
                                  value: skinHealth.mole.rectangle.length.toString() + (" ") + AppLocalizations.of(context)!.zone,
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
                      AppLocalizations.of(context)!.recommendation.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return TServiceRoutine(
                            routineModel: routines[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: TSizes.md,
                          );
                        },
                        itemCount: 5,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const TErrorBody();
        },
      ),
    );
  }
}
