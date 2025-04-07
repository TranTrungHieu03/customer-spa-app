import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_vouchers.dart';

abstract class VoucherRepository {
  Future<Either<Failure, List<VoucherModel>>> getVouchersByDate(GetVouchersParams params);
}
