import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/form_data_model.dart';

class FormDataSkinAnalysis {
  static FormCollectDataModel skinType(BuildContext context) =>
      FormCollectDataModel(id: "1", question: AppLocalizations.of(context)!.skinTypeQuestion, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.oily_skin, value: 0),
        FormAnswerModel(title: AppLocalizations.of(context)!.dry_skin, value: 1),
        FormAnswerModel(title: AppLocalizations.of(context)!.neutral_skin, value: 2),
        FormAnswerModel(title: AppLocalizations.of(context)!.combination_skin, value: 3),
      ]);

  static FormCollectDataModel skinAge(BuildContext context) =>
      FormCollectDataModel(id: "2", question: AppLocalizations.of(context)!.skinAgeQuestion, isText: true);

  static FormCollectDataModel skinColor(BuildContext context) =>
      FormCollectDataModel(id: "3", question: AppLocalizations.of(context)!.skinColorQuestion, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.transparent_white, value: 0),
        FormAnswerModel(title: AppLocalizations.of(context)!.white, value: 1),
        FormAnswerModel(title: AppLocalizations.of(context)!.naturally, value: 2),
        FormAnswerModel(title: AppLocalizations.of(context)!.wheat, value: 3),
        FormAnswerModel(title: AppLocalizations.of(context)!.dark, value: 4),
        FormAnswerModel(title: AppLocalizations.of(context)!.unknown, value: 5),
      ]);

  static FormCollectDataModel acneStatus(BuildContext context) =>
      FormCollectDataModel(id: "4", question: AppLocalizations.of(context)!.skinAcneQuestion, isMultiple: true, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.acneSpec, value: "acne"),
        FormAnswerModel(title: AppLocalizations.of(context)!.blackHead, value: "blackHead"),
        FormAnswerModel(title: AppLocalizations.of(context)!.closedComedones, value: "closedComedones"),
        FormAnswerModel(title: AppLocalizations.of(context)!.unknown, value: "unknown"),
        FormAnswerModel(title: AppLocalizations.of(context)!.noneOfThem, value: "none"),
      ]);

  static FormCollectDataModel wrinkleStatus(BuildContext context) =>
      FormCollectDataModel(id: "5", question: AppLocalizations.of(context)!.skinWrinkleQuestion, isMultiple: true, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.crowsFeet, value: "crowsFeet"),
        FormAnswerModel(title: AppLocalizations.of(context)!.eyeFinelines, value: "eyeFinelines"),
        FormAnswerModel(title: AppLocalizations.of(context)!.glabellaWrinkle, value: "glabellaWrinkle"),
        FormAnswerModel(title: AppLocalizations.of(context)!.nasolabialFold, value: "nasolabialFold"),
        FormAnswerModel(title: AppLocalizations.of(context)!.unknown, value: "unknown"),
        FormAnswerModel(title: AppLocalizations.of(context)!.noneOfThem, value: "none"),
      ]);

  static FormCollectDataModel eyeStatus(BuildContext context) =>
      FormCollectDataModel(id: "6", question: AppLocalizations.of(context)!.skinEyeQuestion, isMultiple: true, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.eyePouch, value: "eyePouch"),
        FormAnswerModel(title: AppLocalizations.of(context)!.darkCircle, value: "darkCircle"),
        FormAnswerModel(title: AppLocalizations.of(context)!.unknown, value: "unknown"),
        FormAnswerModel(title: AppLocalizations.of(context)!.noneOfThem, value: "none"),
      ]);

  static FormCollectDataModel otherStatus(BuildContext context) =>
      FormCollectDataModel(id: "7", question: AppLocalizations.of(context)!.skinOtherQuestion, answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.skinSpot, value: 0),
        FormAnswerModel(title: AppLocalizations.of(context)!.unknown, value: "unknown"),
        FormAnswerModel(title: AppLocalizations.of(context)!.noneOfThem, value: "none"),
      ]);
}
