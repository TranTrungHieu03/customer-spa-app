import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class BookRoutineParams {
  final int userId;
  final int routineId;
  final int branchId;
  final String appointmentTime;
  final String note;
  final int? voucherId;
  final String paymentMethod;

  BookRoutineParams(
      {required this.userId,
      required this.routineId,
      required this.branchId,
      required this.appointmentTime,
      required this.paymentMethod,
      this.voucherId,
      required this.note});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'routineId': routineId,
      'branchId': branchId,
      'appointmentTime': appointmentTime,
      'voucherId': voucherId,
      'note': note,
      'paymentMethod': paymentMethod
    };
  }
}

class BookRoutine implements UseCase<Either, BookRoutineParams> {
  final RoutineRepository _repository;

  BookRoutine(this._repository);

  @override
  Future<Either<Failure, int>> call(BookRoutineParams params) async {
    return await _repository.bookRoutine(params);
  }
}
