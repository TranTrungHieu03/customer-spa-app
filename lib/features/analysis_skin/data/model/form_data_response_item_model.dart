import 'package:spa_mobile/features/analysis_skin/domain/entities/form_data_response_item.dart';

class FormDataResponseItemModel extends FormDataResponseItem {
  FormDataResponseItemModel({required super.value, required super.keyItem});

  factory FormDataResponseItemModel.fromJson(Map<String, dynamic> json) => FormDataResponseItemModel(
        keyItem: json["keyItem"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "keyItem": keyItem,
        "value": value,
      };
}
