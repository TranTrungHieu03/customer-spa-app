import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/request_payos_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class PayDeposit implements UseCase< Either, PayDepositParams> {
  final AppointmentRepository _appointmentRepository;

  PayDeposit(this._appointmentRepository);

  @override
  Future<Either<Failure, String>> call(PayDepositParams params) async {
    return await _appointmentRepository.payDeposit(params);
  }
}
class PayDepositParams {
  final int orderId;
  final String totalAmount;
  final RequestPayOsModel request;
  final int percent;

  PayDepositParams({required this.totalAmount, required this.orderId, required this.request, required this.percent});

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "totalAmount": totalAmount,
      "request": request.toJson(),
      "percent": percent.toString()
    };
  }
}