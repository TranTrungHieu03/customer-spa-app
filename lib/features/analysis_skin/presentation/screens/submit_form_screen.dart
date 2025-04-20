import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_form.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';

class SubmitFormScreen extends StatefulWidget {
  const SubmitFormScreen({
    super.key,
    required this.pageController,
    required this.model,
  });

  final PageController pageController;
  final SkinHealthModel model;

  @override
  State<SubmitFormScreen> createState() => _SubmitFormScreenState();
}

class _SubmitFormScreenState extends State<SubmitFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () {
          widget.pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInQuad,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: BlocConsumer<SkinAnalysisBloc, SkinAnalysisState>(builder: (context, state) {
          // if (state is SkinAnalysisInitial) {
          return Column(
            children: [
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SkinAnalysisBloc>().add(
                          AnalysisViaFormEvent(
                            SkinAnalysisViaFormParams(widget.model),
                          ),
                        );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.submit.toUpperCase(),
                  ),
                ),
              ),
              if (state is SkinAnalysisLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: TColors.primary,
                  ),
                )
            ],
          );
          // } else if (state is SkinAnalysisLoaded) {
          //   return const SizedBox.shrink();
          // }
          // return const SizedBox.shrink();
        }, listener: (context, state) {
          if (state is SkinAnalysisError) {
            TSnackBar.errorSnackBar(context, message: state.message);
            goHome();
          }
          if (state is SkinAnalysisLoaded) {
            // TSnackBar.successSnackBar(context, message: state.message);
            goSkinResult();
          }
        }),
      ),
    );
  }
}
