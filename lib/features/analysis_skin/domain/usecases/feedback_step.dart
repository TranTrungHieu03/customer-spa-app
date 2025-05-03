import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class FeedbackStepParams {
  final int stepId;
  // final int staffId;
  final int userId;
  final DateTime actionDate;
  final String stepLogger;
  final String notes;

  FeedbackStepParams({
    required this.stepId,
    // required this.staffId,
    required this.userId,
    required this.actionDate,
    required this.stepLogger,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        "stepId": stepId,
        // "staffId": staffId,
        "userId": userId,
        "actionDate": actionDate.toIso8601String(),
        "step_Logger": stepLogger,
        "notes": notes,
      };
}

class FeedbackStep implements UseCase<Either, FeedbackStepParams> {
  final RoutineRepository _repository;

  FeedbackStep(this._repository);

  @override
  Future<Either> call(FeedbackStepParams params) async {
    return await _repository.feedbackStep(params);
  }
}
