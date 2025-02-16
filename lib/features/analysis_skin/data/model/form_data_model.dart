import 'package:spa_mobile/features/analysis_skin/domain/entities/form_collect_data.dart';

class FormCollectDataModel extends FormCollectData {
  final List<FormAnswerModel>? answer;

  const FormCollectDataModel({required super.id, required super.question, super.isMultiple = false, super.isText = false, this.answer});

// /// Factory method to create an instance from JSON
// factory FormCollectDataModel.fromJson(Map<String, dynamic> json) {
//   return FormCollectDataModel(
//     id: json['id'] as String,
//     question: json['question'] as String,
//     isMultiple: json['isMultiple'] as bool,
//     answer: (json['answer'] as List<dynamic>)
//         .map((e) => FormAnswerModel.fromJson(e as Map<String, dynamic>))
//         .toList(),
//   );
// }
//
// /// Method to convert an instance to JSON
// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'question': question,
//     'isMultiple': isMultiple,
//     'answer': answer.map((e) => e.toJson()).toList(),
//   };
// }
}

class FormAnswerModel extends FormAnswer {
  const FormAnswerModel({required super.title, required super.value});

  factory FormAnswerModel.fromJson(Map<String, dynamic> json) {
    return FormAnswerModel(
      title: json['title'] as String,
      value: json['value']  ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
    };
  }
}
