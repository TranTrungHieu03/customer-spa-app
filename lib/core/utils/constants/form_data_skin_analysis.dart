import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/form_data_model.dart';

class FormDataSkinAnalysis {
  static FormCollectDataModel skinType(BuildContext context) => FormCollectDataModel(id: "1", question: "What's your skin type?", answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.oily_skin, value: 0),
        FormAnswerModel(title: AppLocalizations.of(context)!.dry_skin, value: 1),
        FormAnswerModel(title: AppLocalizations.of(context)!.neutral_skin, value: 2),
        FormAnswerModel(title: AppLocalizations.of(context)!.combination_skin, value: 3),
      ]);

  static FormCollectDataModel skinAge(BuildContext context) => const FormCollectDataModel(id: "1", question: "Your skin age", isText: true);

  static FormCollectDataModel skinColor(BuildContext context) => FormCollectDataModel(id: "1", question: "What's your skin color", answer: [
        FormAnswerModel(title: AppLocalizations.of(context)!.transparent_white, value: 0),
        FormAnswerModel(title: AppLocalizations.of(context)!.white, value: 1),
        FormAnswerModel(title: AppLocalizations.of(context)!.naturally, value: 2),
        FormAnswerModel(title: AppLocalizations.of(context)!.wheat, value: 3),
        FormAnswerModel(title: AppLocalizations.of(context)!.dark, value: 4),
      ]);
}
