import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkinAnalysis {
  //Skin-color
  static String getSkinColorName(BuildContext context, int value) {
    switch (value) {
      case 0:
        return AppLocalizations.of(context)!.transparent_white;
      case 1:
        return AppLocalizations.of(context)!.white;
      case 2:
        return AppLocalizations.of(context)!.naturally;
      case 3:
        return AppLocalizations.of(context)!.wheat;
      case 4:
        return AppLocalizations.of(context)!.dark;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

  //Skin-type
  static String getSkinTypeName(BuildContext context, int value) {
    switch (value) {
      case 0:
        return AppLocalizations.of(context)!.oily_skin;
      case 1:
        return AppLocalizations.of(context)!.dry_skin;
      case 2:
        return AppLocalizations.of(context)!.neutral_skin;
      case 3:
        return AppLocalizations.of(context)!.combination_skin;

      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }
}
