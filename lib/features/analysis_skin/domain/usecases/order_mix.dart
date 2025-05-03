import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class OrderMixParams {
  final int customerId;
  final int branchId;
  final int? voucherId;
  final List<int> productBranchIds;
  final List<int> productQuantities;
  final List<int> serviceIds;
  final List<int> serviceQuantities;
  final List<int> staffIds;
  final List<DateTime> appointmentDates;
  final double totalAmount;
  final bool isAuto;
  final String paymentMethod;

  OrderMixParams({
    required this.customerId,
    required this.branchId,
    this.voucherId,
    required this.productBranchIds,
    required this.productQuantities,
    required this.serviceIds,
    required this.serviceQuantities,
    required this.staffIds,
    required this.appointmentDates,
    required this.totalAmount,
    required this.isAuto,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "branchId": branchId,
        "voucherId": voucherId,
        "productBranchIds": List<int>.from(productBranchIds.map((x) => x)),
        "productQuantities": List<int>.from(productQuantities.map((x) => x)),
        "serviceIds": List<int>.from(serviceIds.map((x) => x)),
        "serviceQuantities": List<int>.from(serviceQuantities.map((x) => x)),
        "staffIds": List<int>.from(staffIds.map((x) => x)),
        "appointmentDates": List<String>.from(appointmentDates.map((x) => x.toIso8601String())),
        "totalAmount": totalAmount,
        "isAuto": isAuto,
        'paymentMethod': paymentMethod
      };
}

class OrderMix implements UseCase<Either, OrderMixParams> {
  final RoutineRepository _repository;

  OrderMix(this._repository);

  @override
  Future<Either> call(OrderMixParams params) async {
    return await _repository.orderMix(params);
  }
}
