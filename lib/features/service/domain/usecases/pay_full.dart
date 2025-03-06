import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/request_payos_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class PayFull implements UseCase<Either, PayFullParams> {
  final AppointmentRepository _appointmentRepository;

  PayFull(this._appointmentRepository);

  @override
  Future<Either<Failure, String>> call(PayFullParams params) async {
    return await _appointmentRepository.payFull(params);
  }
}

class PayFullParams {
  final int orderId;
  final String totalAmount;
  final RequestPayOsModel request;

  PayFullParams({required this.totalAmount, required this.orderId, required this.request});

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "totalAmount": totalAmount,
      "request": request.toJson(),
    };
  }
}
