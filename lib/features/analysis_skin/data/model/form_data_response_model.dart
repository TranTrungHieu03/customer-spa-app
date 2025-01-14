import 'package:spa_mobile/features/analysis_skin/data/model/form_data_response_item_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/form_data_response_item.dart';

class FormDataResponseModel extends FormDataResponse {
  FormDataResponseModel({required super.key, required this.items});

  final List<FormDataResponseItemModel> items;

  factory FormDataResponseModel.fromJson(Map<String, dynamic> json) {
    return FormDataResponseModel(
      key: json['key'] as String,
      items: (json['items'] as List<dynamic>).map((item) => FormDataResponseItemModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
