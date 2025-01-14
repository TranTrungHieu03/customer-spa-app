import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/form_data_skin_analysis.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_age_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_type_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/form_data_skin/form_data_skin_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/form_skin/form_skin_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/form_item_page.dart';
import 'package:spa_mobile/features/home/presentation/widgets/introduction_form.dart';

class FormCollectDataScreen extends StatefulWidget {
  const FormCollectDataScreen({super.key});

  @override
  State<FormCollectDataScreen> createState() => _FormCollectDataScreenState();
}

class _FormCollectDataScreenState extends State<FormCollectDataScreen> {
  @override
  Widget build(BuildContext context) {
    final formSkinType = FormDataSkinAnalysis.skinType(context);
    final formSkinAge = FormDataSkinAnalysis.skinAge(context);
    final formSkinColor = FormDataSkinAnalysis.skinColor(context);
    final PageController pageController = PageController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController skinAgeController = TextEditingController();
    late SkinHealthModel values = SkinHealthModel.empty();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormDataSkinBloc()..add(UpdateSkinHealthEvent(values)),
        ),
        BlocProvider(
          create: (context) => FormSkinBloc(),
        )
      ],
      child: BlocListener<FormSkinBloc, FormSkinState>(
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
                      child: BlocBuilder<FormDataSkinBloc, FormDataSkinState>(
                        builder: (context, state) {
                          if (state is FormDataSkinUpdated) {
                            final values = state.values;
                            return PageView(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (index) {
                                  context.read<FormSkinBloc>().add(OnPageChangedEvent(pageIndex: index));
                                },
                                children: [
                                  TIntroductionForm(
                                    pageController: pageController,
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinType.question,
                                    isMultiChoice: formSkinType.isMultiple,
                                    child: formSkinType.answer,
                                    answerValue: values.skinType.skinType,
                                    onChanged: (newValue) {
                                      final newFormData = values.copyWith(skinType: SkinTypeModel(skinType: newValue, details: []));
                                      context.read<FormDataSkinBloc>().add(
                                            UpdateSkinHealthEvent(newFormData),
                                          );
                                    },
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinColor.question,
                                    isMultiChoice: formSkinColor.isMultiple,
                                    child: formSkinColor.answer,
                                    answerValue: values.skinColor.value,
                                    onChanged: (newValue) {
                                      final newFormData = values.copyWith(skinColor: BlackheadModel(value: newValue, confidence: 0));
                                      context.read<FormDataSkinBloc>().add(
                                            UpdateSkinHealthEvent(newFormData),
                                          );
                                    },
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinAge.question,
                                    isMultiChoice: formSkinAge.isMultiple,
                                    child: formSkinAge.answer,
                                    isText: true,
                                    answerValue: values.skinType.skinType,
                                    onChanged: (newValue) {},
                                    children: Flex(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: TextField(
                                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30),
                                            controller: skinAgeController,
                                            onChanged: (value) {
                                              final newFormData = values.copyWith(skinAge: SkinAgeModel(value: int.parse(value)));
                                              context.read<FormDataSkinBloc>().add(
                                                    UpdateSkinHealthEvent(newFormData),
                                                  );
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: TSizes.sm),
                                              border: UnderlineInputBorder(),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black38,
                                                  width: 1.5,
                                                ),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black38,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: TSizes.sm),
                                        Text("years", style: Theme.of(context).textTheme.headlineSmall),
                                      ],
                                    ),
                                  ),
                                ]);
                          }
                          return const SizedBox();
                        },
                      ));
                },
              ),
            ],
          )),
    );
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
