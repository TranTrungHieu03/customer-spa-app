import 'package:spa_mobile/features/analysis_skin/domain/entities/rectangle.dart';

class RectangleModel extends Rectangle {
  RectangleModel({required super.left, required super.top, required super.width, required super.height});

  factory RectangleModel.fromJson(Map<String, dynamic> json) =>
      RectangleModel(
        left: json["left"],
        top: json["top"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() =>
      {
        "left": left,
        "top": top,
        "width": width,
        "height": height,
      };

  factory RectangleModel.empty() =>
      RectangleModel(
        left: 0,
        top: 0,
        width: 0,
        height: 0,
      );
}
