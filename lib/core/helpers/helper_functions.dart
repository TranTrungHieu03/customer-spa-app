import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/acne_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    if (value == "Green") {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    }
    return null;
  }

  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop, child: const Text('OK')),
            ],
          );
        });
  }

  static navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static String getFormatDate(DateTime date, {String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static bool checkIsTrueSkinForm(dynamic model) {
    if (model is AcneModel) {
      return model.length > 0 || model.rectangle.isNotEmpty;
    }
    if (model is BlackheadModel) {
      return model.value == 1;
    }

    return false;
  }

  static List<String> listAcneStatus(SkinHealthModel model) {
    List<String> ans = [];

    if (checkIsTrueSkinForm(model.acne)) {
      ans.add("acne");
    }
    if (checkIsTrueSkinForm(model.closedComedones)) {
      ans.add("closedComedones");
    }
    if (checkIsTrueSkinForm(model.blackhead)) {
      ans.add("blackHead");
    }
    return ans;
  }

  static List<String> listWrinkleStatus(SkinHealthModel model) {
    List<String> ans = [];

    if (checkIsTrueSkinForm(model.crowsFeet)) {
      ans.add("crowsFeet");
    }
    if (checkIsTrueSkinForm(model.eyeFinelines)) {
      ans.add("eyeFinelines");
    }
    if (checkIsTrueSkinForm(model.glabellaWrinkle)) {
      ans.add("glabellaWrinkle");
    }
    if (checkIsTrueSkinForm(model.glabellaWrinkle)) {
      ans.add("nasolabialFold");
    }
    return ans;
  }

  static List<String> listEyeStatus(SkinHealthModel model) {
    List<String> ans = [];

    if (checkIsTrueSkinForm(model.eyePouch)) {
      ans.add("eyePouch");
      AppLogger.debug("eyePouch");
    }
    if (checkIsTrueSkinForm(model.darkCircle)) {
      ans.add("darkCircle");
      AppLogger.debug("darkCircle");
    }

    return ans;
  }
}
