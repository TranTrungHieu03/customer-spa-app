import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperAnalysingImageScreen extends StatelessWidget {
  const WrapperAnalysingImageScreen({super.key, required this.imagePath});

  final File imagePath;

  @override
  Widget build(BuildContext context) {
    AppLogger.info(imagePath);
    return BlocProvider<SkinAnalysisBloc>(
      create: (context) => SkinAnalysisBloc(skinAnalysisViaImage: serviceLocator(), skinAnalysisViaForm: serviceLocator()),
      child: AnalysingImageScreen(imagePath: imagePath),
    );
  }
}

class AnalysingImageScreen extends StatefulWidget {
  const AnalysingImageScreen({super.key, required this.imagePath});

  final File imagePath;

  @override
  State<AnalysingImageScreen> createState() => _AnalysingImageScreenState();
}

class _AnalysingImageScreenState extends State<AnalysingImageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SkinAnalysisBloc, SkinAnalysisState>(
      listener: (context, state) {
        if (state is SkinAnalysisLoaded) {
          goSkinResult();
        }
        if (state is SkinAnalysisError) {
          goHome();
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is SkinAnalysisLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    TImages.imageScanning,
                    width: THelperFunctions.screenWidth(context) * 0.5,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  Text(
                    AppLocalizations.of(context)!.scanningImage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        return const ErrorScreen();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SkinAnalysisBloc>().add(AnalysisViaImageEvent(SkinAnalysisViaImageParams(widget.imagePath)));
  }
}
