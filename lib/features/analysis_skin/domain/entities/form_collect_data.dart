import 'package:equatable/equatable.dart';

class FormCollectData extends Equatable {
  final String id;
  final String question;
  final bool isMultiple;
  final bool isText;

  const FormCollectData({required this.id, required this.question, required this.isMultiple, required this.isText});

  @override
  List<Object?> get props => [id];
}

class FormAnswer extends Equatable {
  final String title;
  final dynamic value;

  const FormAnswer({required this.title, required this.value});

  @override
  List<Object?> get props => [value];
}
