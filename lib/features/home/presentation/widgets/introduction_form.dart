import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/form_collect_data_screen.dart';

class TIntroductionForm extends StatelessWidget {
  const TIntroductionForm({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        actions: [
          TRoundedIcon(
            icon: Iconsax.info_circle,
            color: Colors.black,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.title_form,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.description_form,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TRoundedImage(
              imageUrl: TImages.formSkin,
              isNetworkImage: true,
              fit: BoxFit.cover,
              width: THelperFunctions.screenWidth(context) * 0.8,
              height: 300,
              applyImageRadius: true,
            ),
            const SizedBox(height: 20),
            const Spacer(),
            FormNextBtn(pageController: pageController)
          ],
        ),
      ),
    );
  }
}
