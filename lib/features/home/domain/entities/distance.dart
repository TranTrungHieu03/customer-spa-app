import 'package:equatable/equatable.dart';

class Distance extends Equatable {
  final String text;
  final int value;

  const Distance({required this.value, required this.text});

  @override
  // TODO: implement props
  List<Object?> get props => [value, text];
}
