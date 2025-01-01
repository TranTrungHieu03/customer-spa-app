import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/presentation/blocs/form_skin/form_skin_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/form_item_page.dart';
import 'package:spa_mobile/features/home/presentation/widgets/introduction_form.dart';
import 'package:spa_mobile/features/home/presentation/widgets/option_item.dart';

class FormCollectDataScreen extends StatefulWidget {
  const FormCollectDataScreen({super.key});

  @override
  State<FormCollectDataScreen> createState() => _FormCollectDataScreenState();
}

class _FormCollectDataScreenState extends State<FormCollectDataScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocListener<FormSkinBloc, FormSkinState>(
        listener: (context, state) {
          if (state is FormSkinPageChanged) {
            pageController.animateToPage(
              state.pageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        child: Stack(
          children: [
            BlocBuilder<FormSkinBloc, FormSkinState>(
              builder: (context, state) {
                return Form(
                    key: formKey,
                    child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          context
                              .read<FormSkinBloc>()
                              .add(OnPageChangedEvent(pageIndex: index));
                        },
                        children: [
                          TIntroductionForm(
                            pageController: pageController,
                          ),
                          TFormItemPage(
                            pageController: pageController,
                            question: 'What is your skin type?',
                            child: const Column(
                              children: [
                                TOptionItem(
                                  icon: Iconsax.gallery,
                                  title: 'Dry',
                                  isChoose: true,
                                ),
                                SizedBox(height: TSizes.sm),
                                TOptionItem(
                                  title: 'Da dầu',
                                  icon: Iconsax.happyemoji,
                                  isChoose: false,
                                )
                              ],
                            ),
                          ),
                        ]));
              },
            ),
          ],
        ));
  }
}

class FormNextBtn extends StatelessWidget {
  const FormNextBtn({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () => context.read<FormSkinBloc>().add(NextPageEvent()),
          child: Text(
            AppLocalizations.of(context)!.next.toUpperCase(),
          )),
    );
  }
}

class FormSubmitBtn extends StatelessWidget {
  const FormSubmitBtn({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 10,
      child: ElevatedButton(
        onPressed: () => context.read<FormSkinBloc>().add(NextPageEvent()),
        child: Text(AppLocalizations.of(context)!.submit.toUpperCase()),
      ),
    );
  }
}
