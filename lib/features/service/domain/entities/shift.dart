import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        startTime,
        endTime,
      ];
}
