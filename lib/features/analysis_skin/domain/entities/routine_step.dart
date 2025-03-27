import 'package:equatable/equatable.dart';

class RoutineStep extends Equatable {
  final int skinCareRoutineStepId;
  final int skincareRoutineId;
  final String name;
  final String? description;
  final int step;
  final String? intervalBeforeNextStep;

  const RoutineStep({
    required this.skinCareRoutineStepId,
    required this.skincareRoutineId,
    required this.name,
    this.description,
    required this.step,
    required this.intervalBeforeNextStep,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [skincareRoutineId, name];
}
