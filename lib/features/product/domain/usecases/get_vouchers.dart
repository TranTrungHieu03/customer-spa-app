import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/voucher_repository.dart';

class GetVouchersParams {
  final String date;

  GetVouchersParams(this.date);
}

class GetVouchers implements UseCase<Either, GetVouchersParams> {
  final VoucherRepository _repository;

  GetVouchers(this._repository);

  @override
  Future<Either> call(GetVouchersParams params) async {
    return await _repository.getVouchersByDate(params);
  }
}
