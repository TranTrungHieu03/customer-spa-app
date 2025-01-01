import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/presentation/screens/form_collect_data_screen.dart';

class TFormItemPage extends StatelessWidget {
  const TFormItemPage(
      {super.key,
      required this.pageController,
      required this.question,
      required this.child});

  final PageController pageController;
  final String question;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () {
          pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInQuad);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
        child: Column(
          children: [
            Text(question,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            const Spacer(),
            child,
            const SizedBox(height: TSizes.lg),
            FormNextBtn(pageController: pageController),
            const SizedBox(height: TSizes.sm),
          ],
        ),
      ),
    );
  }
}
