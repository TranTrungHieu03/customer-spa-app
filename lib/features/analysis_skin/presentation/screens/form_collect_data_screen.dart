import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/form_data_skin_analysis.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/acne_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_age_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_type_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/form_data_skin/form_data_skin_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/form_skin/form_skin_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/submit_form_screen.dart';
import 'package:spa_mobile/features/home/presentation/widgets/form_item_page.dart';
import 'package:spa_mobile/features/home/presentation/widgets/introduction_form.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperFormCollectData extends StatelessWidget {
  const WrapperFormCollectData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SkinAnalysisBloc>(
      create: (context) => SkinAnalysisBloc(skinAnalysisViaImage: serviceLocator(), skinAnalysisViaForm: serviceLocator()),
      child: const FormCollectDataScreen(),
    );
  }
}

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
    final formSkinAcne = FormDataSkinAnalysis.acneStatus(context);
    final formSkinEye = FormDataSkinAnalysis.eyeStatus(context);
    final formSkinWrinkle = FormDataSkinAnalysis.wrinkleStatus(context);
    final PageController pageController = PageController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final SkinHealthModel skinHealthModel = SkinHealthModel.empty();
    final TextEditingController skinAgeController =
        TextEditingController(text: skinHealthModel.skinAge.value > 0 ? skinHealthModel.skinAge.value.toString() : "");

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormDataSkinBloc()..add(UpdateSkinHealthEvent(skinHealthModel)),
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
            if (state is FormSkinError) {
              TSnackBar.successSnackBar(context, message: state.message);
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
                                    question: formSkinAge.question,
                                    isMultiChoice: formSkinAge.isMultiple,
                                    child: formSkinAge.answer,
                                    isText: true,
                                    answerValue: values.skinAge.value > 0 ? values.skinAge.value : 0,
                                    formController: skinAgeController,
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
                                                if (value.isNotEmpty) {
                                                  final sanitizedValue = value.replaceFirst(RegExp(r'^0+'), '');
                                                  skinAgeController.value = TextEditingValue(
                                                    text: sanitizedValue,
                                                    selection: TextSelection.collapsed(offset: sanitizedValue.length),
                                                  );

                                                  if (int.parse(sanitizedValue) > 0) {
                                                    final newFormData = values.copyWith(
                                                      skinAge: SkinAgeModel(
                                                        value: int.parse(sanitizedValue),
                                                      ),
                                                    );
                                                    context.read<FormDataSkinBloc>().add(
                                                          UpdateSkinHealthEvent(newFormData),
                                                        );
                                                  } else {
                                                    TSnackBar.warningSnackBar(context, message: "Age must be greater than 0");
                                                  }
                                                }
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
                                            )),
                                        const SizedBox(width: TSizes.sm),
                                        Text("years", style: Theme.of(context).textTheme.bodyMedium),
                                      ],
                                    ),
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinType.question,
                                    isMultiChoice: formSkinType.isMultiple,
                                    child: formSkinType.answer,
                                    answerValue: values.skinType.skinType,
                                    onChanged: (newValue) {
                                      final newFormData = values.copyWith(skinType: SkinTypeModel(skinType: newValue.first, details: []));
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
                                      final newFormData = values.copyWith(skinColor: BlackheadModel(value: newValue.first, confidence: 0));
                                      context.read<FormDataSkinBloc>().add(
                                            UpdateSkinHealthEvent(newFormData),
                                          );
                                    },
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinAcne.question,
                                    isMultiChoice: formSkinAcne.isMultiple,
                                    child: formSkinAcne.answer,
                                    answerValues: THelperFunctions.listAcneStatus(values),
                                    onChanged: (newValue) {
                                      final newFormData = values.copyWith(
                                        acne: newValue.contains("acne")
                                            ? AcneModel(length: 1, rectangle: values.acne.rectangle)
                                            : AcneModel(length: 0, rectangle: values.acne.rectangle),
                                        closedComedones: newValue.contains("closedComedones")
                                            ? AcneModel(rectangle: values.closedComedones.rectangle, length: 1)
                                            : AcneModel(rectangle: values.closedComedones.rectangle, length: 0),
                                        blackhead: newValue.contains("blackhead")
                                            ? BlackheadModel(value: 1, confidence: values.blackhead.confidence)
                                            : BlackheadModel(value: 10, confidence: values.blackhead.confidence),
                                      );
                                      context.read<FormDataSkinBloc>().add(
                                            UpdateSkinHealthEvent(newFormData),
                                          );
                                    },
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinEye.question,
                                    isMultiChoice: formSkinEye.isMultiple,
                                    child: formSkinEye.answer,
                                    answerValues: THelperFunctions.listEyeStatus(values),
                                    onChanged: (newValue) {
                                      AppLogger.info("Before copyWith: ${values.toJson()}");

                                      final newFormData = values.copyWith(
                                          darkCircle: newValue.contains("darkCircle")
                                              ? BlackheadModel(value: 1, confidence: values.darkCircle.confidence)
                                              : BlackheadModel(value: 0, confidence: values.darkCircle.confidence),
                                          eyePouch: newValue.contains("eyePouch")
                                              ? BlackheadModel(value: 1, confidence: values.eyePouch.confidence)
                                              : BlackheadModel(value: 0, confidence: values.eyePouch.confidence));

                                      AppLogger.info("After copyWith: ${newFormData.toJson()}");
                                    },
                                  ),
                                  TFormItemPage(
                                    pageController: pageController,
                                    question: formSkinWrinkle.question,
                                    isMultiChoice: formSkinWrinkle.isMultiple,
                                    child: formSkinWrinkle.answer,
                                    answerValues: THelperFunctions.listWrinkleStatus(values),
                                    onChanged: (newValue) {
                                      final newFormData = values.copyWith(
                                          crowsFeet: newValue.contains("crowsFeet")
                                              ? BlackheadModel(value: 1, confidence: values.crowsFeet.confidence)
                                              : BlackheadModel(value: 0, confidence: values.crowsFeet.confidence),
                                          eyeFinelines: newValue.contains("eyeFinelines")
                                              ? BlackheadModel(value: 1, confidence: values.eyeFinelines.confidence)
                                              : BlackheadModel(value: 0, confidence: values.eyeFinelines.confidence),
                                          glabellaWrinkle: newValue.contains("glabellaWrinkle")
                                              ? BlackheadModel(value: 1, confidence: values.glabellaWrinkle.confidence)
                                              : BlackheadModel(value: 0, confidence: values.glabellaWrinkle.confidence),
                                          nasolabialFold: newValue.contains("nasolabialFold")
                                              ? BlackheadModel(value: 1, confidence: values.nasolabialFold.confidence)
                                              : BlackheadModel(value: 0, confidence: values.nasolabialFold.confidence));
                                      context.read<FormDataSkinBloc>().add(
                                            UpdateSkinHealthEvent(newFormData),
                                          );
                                    },
                                  ),
                                  BlocProvider(
                                    create: (context) => SkinAnalysisBloc(
                                      skinAnalysisViaImage: serviceLocator(),
                                      skinAnalysisViaForm: serviceLocator(),
                                    ),
                                    child: SubmitFormScreen(pageController: pageController, model: state.values),
                                  )
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
    this.isHasValue = true,
  });

  final PageController pageController;
  final bool isHasValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHasValue ? TColors.primary : TColors.primary.withOpacity(0.6),
            side: BorderSide(
              color: isHasValue ? TColors.primary : TColors.primary.withOpacity(0.6),
              width: 1.0,
            ),
          ),
          onPressed: () {
            if (isHasValue) {
              context.read<FormSkinBloc>().add(NextPageEvent());
            }
          },
          child: Text(
            AppLocalizations.of(context)!.next.toUpperCase(),
          )),
    );
  }
}
//
// class FormSubmitBtn extends StatelessWidget {
//   const FormSubmitBtn({
//     super.key,
//     required this.pageController,
//   });
//
//   final PageController pageController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 16,
//       bottom: 10,
//       child: ElevatedButton(
//         onPressed: () => context.read<SkinAnalysisBloc>().add(AnalysisViaFormEvent(SkinAnalysisViaFormParams())),
//         child: Text(AppLocalizations.of(context)!.submit.toUpperCase()),
//       ),
//     );
//   }
// }
