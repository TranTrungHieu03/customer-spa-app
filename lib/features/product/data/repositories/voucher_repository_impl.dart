import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/datasources/voucher_remote_data_source.dart';
import 'package:spa_mobile/features/product/domain/repository/voucher_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_vouchers.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VoucherModel>>> getVouchersByDate(GetVouchersParams params) async {
    try {
      List<VoucherModel> result = await remoteDataSource.getVouchersByDate(params);
      return Right(result);
    } on AppException catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
